#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <stdbool.h>  

#define ANSI_YELLOW "\033[38;5;227m" 
#define ANSI_RESET "\033[0m"        
#define ANSI_RED "\033[31;5;160m"   
#define ANSI_GREEN "\033[38;5;40m"  
#define ANSI_WHITE "\033[38;5;255m" 
#define ANSI_PINK "\033[38;5;213m"  

typedef struct {
    int file_number;
    bool deletion_status;  
    int number_of_readers;
    int number_of_writers;
    int total_occupants;  
    pthread_mutex_t lock;
    pthread_cond_t cond;
} Filenode;

typedef struct {
    int request_number;
    int user_number;
    int file_number;
    char operation[10];
    int request_time;
    int send_time;  
} Requestnode;

Filenode filelist[1000];
Requestnode requestlist[100000];

void initialize_files() {
    memset(filelist, 0, sizeof(filelist));
    int i = 0;
    while (i < 1000) {
        filelist[i].file_number = i;  
        filelist[i].deletion_status = false;  
        pthread_mutex_init(&filelist[i].lock, NULL); 
        pthread_cond_init(&filelist[i].cond, NULL);  
        i++;
    }
}

int can_process_request(Filenode* file, Requestnode* req, int c) {
    if (file->deletion_status) return 0;  
    if (strcmp(req->operation, "READ") == 0) {
        if (file->total_occupants < c) return 1;  
        else return 0;
    } 
    else if (strcmp(req->operation, "WRITE") == 0) {
        if (file->number_of_writers == 0 && file->total_occupants == 0) return 1;
        else return 0;  
    } 
    else if (strcmp(req->operation, "DELETE") == 0) {
        if (file->total_occupants == 0) return 1;  
        else return 0;  
    }
    return 0;
}

void* handle_request(void* arg) {
    struct {
        Requestnode* req;
        int r, w, d, t, start_time, c;
    } *data = arg;
    
    Requestnode* req = data->req;
    Filenode* file = &filelist[req->file_number];
    int sleep_time;
    if (strcmp(req->operation, "DELETE") == 0) sleep_time = data->d;
    else if (strcmp(req->operation, "READ") == 0) sleep_time = data->r;
    else sleep_time = data->w;
    
    sleep(req->request_time);
    
    int current_time = ((int)time(NULL)) - data->start_time;
    printf(ANSI_YELLOW "User %d has made the request for performing %s on file %d at %d seconds" ANSI_RESET "\n", req->user_number, req->operation, req->file_number, current_time);
           
    req->send_time = current_time;
    
    sleep(1);  
    
    struct timespec timeout;
    
    while (1) {
        current_time = ((int)time(NULL)) - data->start_time;
        if (current_time >= req->send_time + data->t) {
            printf(ANSI_RED "User %d canceled the request due to no response at %d seconds" ANSI_RESET "\n", req->user_number, req->send_time + data->t);
            free(data);
            return NULL;
        }
        timeout.tv_sec = time(NULL) + (req->send_time + data->t - current_time);
        timeout.tv_nsec = 0;
        pthread_mutex_lock(&file->lock);
        if (file->deletion_status) {
            printf(ANSI_WHITE "LAZY has declined the request of User %d at %d seconds because an invalid/deleted file was requested" ANSI_RESET "\n", req->user_number, current_time);
            pthread_mutex_unlock(&file->lock);
            free(data);
            return NULL;
        }
        if (can_process_request(file, req, data->c)) {
            if (strcmp(req->operation, "READ") == 0) {
                file->number_of_readers++;
                file->total_occupants++;
            } 
            else if (strcmp(req->operation, "WRITE") == 0) {
                file->number_of_writers++;
                file->total_occupants++;
            } 
            else file->deletion_status = true;  
            printf(ANSI_PINK "LAZY has taken up the request of User %d at %d seconds" ANSI_RESET "\n", req->user_number, current_time);                  
            pthread_mutex_unlock(&file->lock);
            
            sleep(sleep_time);
            
            pthread_mutex_lock(&file->lock);
            if (strcmp(req->operation, "READ") == 0) {
                file->number_of_readers--;
                file->total_occupants--;
            } 
            else if (strcmp(req->operation, "WRITE") == 0) {
                file->number_of_writers--;
                file->total_occupants--;
            }
            
            current_time = ((int)time(NULL)) - data->start_time;
            printf(ANSI_GREEN "The request for User %d was completed at %d seconds" ANSI_RESET "\n", req->user_number, current_time);
                   
            pthread_cond_broadcast(&file->cond);
            pthread_mutex_unlock(&file->lock);
            free(data);
            return NULL;
        }
        int wait_result = pthread_cond_timedwait(&file->cond, &file->lock, &timeout);
        pthread_mutex_unlock(&file->lock);
        if (wait_result == ETIMEDOUT) {
            current_time = ((int)time(NULL)) - data->start_time;
            printf(ANSI_RED "User %d cancelled the request due to no response at %d seconds" ANSI_RESET "\n", req->user_number, req->send_time + data->t);
            free(data);
            return NULL;
        }
    }
}

int compare_requests(const void* a, const void* b) {
    const Requestnode* req1 = (const Requestnode*)a;
    const Requestnode* req2 = (const Requestnode*)b;
    if (req1->request_time != req2->request_time) return req1->request_time - req2->request_time;
    return req1->request_number - req2->request_number;
}

int main() {
    int r, w, d, n, c, t, number_of_requests = 0;
    scanf("%d %d %d %d %d %d", &r, &w, &d, &n, &c, &t);
    initialize_files();  
    int user_number, file_number, request_time;
    char operation[10];
    while (1) {
        if (scanf("%d %d %s %d", &user_number, &file_number, operation, &request_time) != 4) {
            char stop_command[10];
            scanf("%s", stop_command);
            if (strcmp(stop_command, "STOP") == 0) break;
        } 
        else {
            // user_number, file_number, request_time should be > 0, move to the next iteration if not
            if (user_number <= 0 || file_number <= 0 || file_number > n) {
                printf("\nInvalid request %d %d %s %d ignored\n", user_number, file_number, operation, request_time);   
                continue;
            }
            if (!(strcmp(operation, "READ") == 0 || strcmp(operation, "WRITE") == 0 || strcmp(operation, "DELETE") == 0)) {
                printf("\nInvalid request %d %d %s %d ignored\n", user_number, file_number, operation, request_time); 
                continue;
            }
            Requestnode new_request = {
                .user_number = user_number,
                .file_number = file_number,
                .request_time = request_time,
                .request_number = number_of_requests,
                .send_time = -1
            };
            strcpy(new_request.operation, operation);
            requestlist[number_of_requests] = new_request;
            number_of_requests++;
        }
    }
    qsort(requestlist, number_of_requests, sizeof(Requestnode), compare_requests);
    printf("LAZY has woken up!\n");
    pthread_t thread_list[number_of_requests];
    int start_time = (int)time(NULL);
    int i = 0;
    while (i < number_of_requests) {
        struct {
            Requestnode* req;
            int r, w, d, t, start_time, c;
        } *data = malloc(sizeof(*data));
        data->req = &requestlist[i];
        data->r = r;
        data->w = w;
        data->d = d;
        data->t = t;
        data->start_time = start_time;
        data->c = c;      
        pthread_create(&thread_list[i], NULL, handle_request, data);
        i++;
    }
    i = 0;
    while (i < number_of_requests) {
        pthread_join(thread_list[i], NULL);
        i++;
    }
    printf("LAZY has no more pending requests and is going back to sleep!\n");
    return 0;
}
