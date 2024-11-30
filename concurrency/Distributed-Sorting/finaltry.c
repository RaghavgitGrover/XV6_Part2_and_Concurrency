#define _XOPEN_SOURCE
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <stdbool.h>
#include <time.h>
#include <limits.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/resource.h>
#include <math.h>

#define MAX_FILENAME 128
#define MAX_FILES 1000
#define THREAD_COUNT 4
#define LAZY_THRESHOLD 42
#define HASH_BASE 27
#define MAX_THREADS 64
#define K_WAY 4

typedef struct {
    char name[MAX_FILENAME];
    int id;
    char timestamp[20];
    uint64_t sort_key;
} FileEntry;

typedef struct {
    FileEntry* files;
    int start;
    int end;
    int depth;
    int column_type;
} MergeSortArgs;

typedef struct {
    FileEntry* arr;
    int index;
    int end;
} MergeQueue;

typedef struct {
    FileEntry* files;
    FileEntry* output;
    int* count;
    int start;
    int end;
    uint64_t min_val;
    uint64_t max_val;
    int column_type;
} CountSortArgs;

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_barrier_t barrier;

unsigned long hash_string(const char* str) {
    unsigned long hash = 0;
    for(int i = 0; str[i] != '\0'; i++) {
        hash = hash * HASH_BASE + (str[i] - 'a' + 1);
    }
    return hash % 9999999;  
}

unsigned long hash_timestamp(const char* timestamp) {
    struct tm tm = {0};
    strptime(timestamp, "%Y-%m-%dT%H:%M:%S", &tm);
    time_t t = mktime(&tm);
    return (unsigned long)t % 9999999;
}

// for count sort
void preprocess_sort_keys(FileEntry* files, int n, int column_type) {
    for (int i = 0; i < n; i++) {
        switch(column_type) {
            case 0: 
                files[i].sort_key = files[i].id;
                break;
            case 1: 
                files[i].sort_key = hash_string(files[i].name);
                break;
            case 2: 
                files[i].sort_key = hash_timestamp(files[i].timestamp);
                break;
        }
    }
}

// for merge sort
int compare_entries(const FileEntry* a, const FileEntry* b, int column_type) {
    switch(column_type) {
        case 0: 
            return (a->id > b->id) - (a->id < b->id);
        case 1: 
            return strcmp(a->name, b->name);
        case 2: 
            return strcmp(a->timestamp, b->timestamp);
        default:
            return 0;
    }
}

FileEntry get_min_entry(MergeQueue* queues, int k, int* min_idx, int column_type) {
    *min_idx = -1;
    FileEntry min_entry;
    bool first = true;
    
    for (int i = 0; i < k; i++) {
        if (queues[i].index <= queues[i].end) {
            if (first) {
                min_entry = queues[i].arr[queues[i].index];
                *min_idx = i;
                first = false;
            } 
            else if (compare_entries(&queues[i].arr[queues[i].index], &min_entry, column_type) < 0) {
                min_entry = queues[i].arr[queues[i].index];
                *min_idx = i;
            }
        }
    }
    return min_entry;
}

void k_way_merge(FileEntry* files, int start, int end, int k, int column_type) {
    int chunk_size = (end - start + 1) / k;
    MergeQueue* queues = malloc(k * sizeof(MergeQueue));
    FileEntry* output = malloc((end - start + 1) * sizeof(FileEntry));
    int out_idx = 0;
    
    for (int i = 0; i < k; i++) {
        queues[i].arr = files;
        queues[i].index = start + i * chunk_size;
        queues[i].end = (i == k-1) ? end : start + (i+1) * chunk_size - 1;
    }
    
    while (out_idx < (end - start + 1)) {
        int min_idx;
        FileEntry min_entry = get_min_entry(queues, k, &min_idx, column_type);
        if (min_idx != -1) {
            output[out_idx++] = min_entry;
            queues[min_idx].index++;
        }
    }
    
    memcpy(&files[start], output, (end - start + 1) * sizeof(FileEntry));
    free(queues);
    free(output);
}

void* parallel_merge_sort(void* arg) {
    MergeSortArgs* args = (MergeSortArgs*)arg;
    int start = args->start;
    int end = args->end;
    int depth = args->depth;
    int column_type = args->column_type;
    
    if (start >= end) {
        return NULL;
    }
    
    if (end - start <= K_WAY) {
        for (int i = start + 1; i <= end; i++) {
            FileEntry key = args->files[i];
            int j = i - 1;
            while (j >= start && compare_entries(&args->files[j], &key, column_type) > 0) {
                args->files[j + 1] = args->files[j];
                j--;
            }
            args->files[j + 1] = key;
        }
        return NULL;
    }
    
    pthread_t threads[K_WAY];
    MergeSortArgs thread_args[K_WAY];
    int chunk_size = (end - start + 1) / K_WAY;
    
    for (int i = 0; i < K_WAY; i++) {
        thread_args[i].files = args->files;
        thread_args[i].start = start + i * chunk_size;
        thread_args[i].end = (i == K_WAY-1) ? end : start + (i+1) * chunk_size - 1;
        thread_args[i].depth = depth + 1;
        thread_args[i].column_type = column_type;
        
        if (depth < log2(MAX_THREADS)) {
            pthread_create(&threads[i], NULL, parallel_merge_sort, &thread_args[i]);
        } 
        else {
            parallel_merge_sort(&thread_args[i]);
        }
    }
    
    if (depth < log2(MAX_THREADS)) {
        for (int i = 0; i < K_WAY; i++) {
            pthread_join(threads[i], NULL);
        }
    }
    
    k_way_merge(args->files, start, end, K_WAY, column_type);
    return NULL;
}

void* count_thread(void* arg) {
    CountSortArgs* args = (CountSortArgs*)arg;
    int range = args->max_val - args->min_val + 1;    
    int* local_count = calloc(range, sizeof(int));
    for (int i = args->start; i < args->end; i++) {
        int index = (args->files[i].sort_key - args->min_val);
        local_count[index]++;
    }    
    for (int i = 0; i < range; i++) {
        __sync_fetch_and_add(&args->count[i], local_count[i]);
    }    
    free(local_count);
    return NULL;
}

void parallel_counting_sort(FileEntry* files, int n, int column_type) {
    uint64_t min_val = files[0].sort_key;
    uint64_t max_val = files[0].sort_key;    
    for (int i = 1; i < n; i++) {
        if (files[i].sort_key < min_val) min_val = files[i].sort_key;
        if (files[i].sort_key > max_val) max_val = files[i].sort_key;
    } 
    int range = (max_val - min_val + 1);
    int* count = calloc(range, sizeof(int));
    FileEntry* output = malloc(n * sizeof(FileEntry));
    pthread_t threads[THREAD_COUNT];
    CountSortArgs thread_args[THREAD_COUNT];
    int chunk_size = n / THREAD_COUNT;
    for (int i = 0; i < THREAD_COUNT; i++) {
        thread_args[i].files = files;
        thread_args[i].output = output;
        thread_args[i].count = count;
        thread_args[i].start = i * chunk_size;
        thread_args[i].end = (i == THREAD_COUNT - 1) ? n : (i + 1) * chunk_size;
        thread_args[i].min_val = min_val;
        thread_args[i].max_val = max_val;
        thread_args[i].column_type = column_type;
        pthread_create(&threads[i], NULL, count_thread, &thread_args[i]);
    }
    for (int i = 0; i < THREAD_COUNT; i++) {
        pthread_join(threads[i], NULL);
    }
    for (int i = 1; i < range; i++) {
        count[i] += count[i - 1];
    }
    for (int i = n - 1; i >= 0; i--) {
        int index = (files[i].sort_key - min_val);
        output[count[index] - 1] = files[i];
        count[index]--;
    }
    memcpy(files, output, n * sizeof(FileEntry));
    free(count);
    free(output);
}

void sort_files(FileEntry* files, int n, int column_type) {
    preprocess_sort_keys(files, n, column_type);
    if (n <= LAZY_THRESHOLD) {  
        printf("Using Parallel Counting Sort (n=%d <= threshold=%d)\n", n, LAZY_THRESHOLD);
        parallel_counting_sort(files, n, column_type);
    } 
    else {
        printf("Using Parallel Merge Sort (n=%d > threshold=%d)\n", n, LAZY_THRESHOLD);
        MergeSortArgs args = {
            .files = files,
            .start = 0,
            .end = n - 1,
            .depth = 0,
            .column_type = column_type
        };
        parallel_merge_sort(&args);
    }
}

int main() {
    int n;
    scanf("%d", &n);
    FileEntry* files = malloc(n * sizeof(FileEntry));
    for (int i = 0; i < n; i++) {
        scanf("%s %d %s", files[i].name, &files[i].id, files[i].timestamp);
    }
    char sort_column[20];
    scanf("%s", sort_column);
    int column_type;
    if (strcmp(sort_column, "NAME") == 0) column_type = 1;
    else if (strcmp(sort_column, "TIMESTAMP") == 0) column_type = 2;
    else column_type = 0;
    printf("Sorting by: %s\n", sort_column);
    clock_t start_time = clock();
    struct rusage usage_start;
    getrusage(RUSAGE_SELF, &usage_start);
    sort_files(files, n, column_type);
    clock_t end_time = clock();
    struct rusage usage_end;
    getrusage(RUSAGE_SELF, &usage_end);
    double total_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    printf("Total runtime: %.6f seconds\n", total_time);
    long memory_used = usage_end.ru_maxrss - usage_start.ru_maxrss;
    printf("Total memory used: %ld KB\n", memory_used);
    for (int i = 0; i < n; i++) {
        printf("%s %d %s (sort_key: %lu)\n", files[i].name, files[i].id, files[i].timestamp, files[i].sort_key);
    }
    free(files);
    pthread_mutex_destroy(&mutex);

    return 0;
}