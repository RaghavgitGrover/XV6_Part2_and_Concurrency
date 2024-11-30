import random
import string
import subprocess
import datetime
import time

def generate_random_name(length=4):
    """Generate a random alphanumeric name."""
    return ''.join(random.choices(string.ascii_lowercase, k=2) + 
                  random.choices(string.digits, k=2))

def generate_random_timestamp():
    """Generate a random timestamp between 1990 and 2023."""
    start = datetime.datetime(1990, 1, 1)
    end = datetime.datetime(2023, 12, 31)
    delta = end - start
    random_days = random.randrange(delta.days)
    random_date = start + datetime.timedelta(days=random_days)
    random_hour = random.randint(0, 23)
    random_minute = random.randint(0, 59)
    random_second = random.randint(0, 59)
    return random_date.replace(hour=random_hour, minute=random_minute, 
                             second=random_second).strftime('%Y-%m-%dT%H:%M:%S')

def generate_test_case(n):
    """Generate a test case with n entries."""
    entries = []
    used_ids = set()
    used_names = set()
    
    for _ in range(n):
        # Generate unique ID
        while True:
            id_num = random.randint(100, 999)
            if id_num not in used_ids:
                used_ids.add(id_num)
                break
        
        # Generate unique name
        while True:
            name = generate_random_name()
            if name not in used_names:
                used_names.add(name)
                break
                
        timestamp = generate_random_timestamp()
        entries.append((name, id_num, timestamp))
    
    return entries

def is_sorted_by_id(output_lines):
    """Check if output is sorted by ID."""
    prev_id = -1
    for line in output_lines:
        parts = line.strip().split()
        if len(parts) < 2:
            continue
        curr_id = int(parts[1])
        if curr_id < prev_id:
            return False
        prev_id = curr_id
    return True

def is_sorted_by_name(output_lines):
    """Check if output is sorted by name."""
    prev_name = ""
    for line in output_lines:
        parts = line.strip().split()
        if len(parts) < 1:
            continue
        curr_name = parts[0]
        if curr_name < prev_name and prev_name != "":
            return False
        prev_name = curr_name
    return True

def is_sorted_by_timestamp(output_lines):
    """Check if output is sorted by timestamp."""
    prev_timestamp = ""
    for line in output_lines:
        parts = line.strip().split()
        if len(parts) < 3:
            continue
        curr_timestamp = parts[2]
        if curr_timestamp < prev_timestamp and prev_timestamp != "":
            return False
        prev_timestamp = curr_timestamp
    return True

def run_test(entries, sort_type):
    """Run the test with given entries and sort type."""
    # Prepare input (match the format expected by a.out)
    input_str = f"{len(entries)}\n"
    for name, id_num, timestamp in entries:
        input_str += f"{name} {id_num} {timestamp}\n"
    
    try:
        process = subprocess.Popen(
            ['./a.out'], 
            stdin=subprocess.PIPE, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE, 
            text=True
        )
        
        # Set a timeout for the process (e.g., 60 seconds)
        stdout, stderr = process.communicate(input_str, timeout=60)
        
        # Check for any errors
        if stderr:
            print(f"Error in subprocess: {stderr}")
        
        # Check sorting
        output_lines = stdout.strip().split('\n')[2:-1]  # Skip header and timing info
        
        if sort_type == "ID":
            return is_sorted_by_id(output_lines)
        elif sort_type == "NAME":
            return is_sorted_by_name(output_lines)
        else:  # TIMESTAMP
            return is_sorted_by_timestamp(output_lines)
            
    except subprocess.TimeoutExpired:
        print("Test timed out.")
        return False
    except subprocess.CalledProcessError as e:
        print(f"Subprocess error: {e}")
        return False
    except Exception as e:
        print(f"Error running test: {e}")
        return False

def main():
    # Set the test size to 500 only
    test_sizes = [500]
    sort_types = ["ID", "NAME", "TIMESTAMP"]
    
    for size in test_sizes:
        print(f"\nRunning tests with {size} entries:")
        for sort_type in sort_types:
            print(f"\nTesting {sort_type} sort:")
            
            # Run multiple tests for each configuration
            for test_num in range(5):
                entries = generate_test_case(size)
                
                # Verify data is not already sorted
                entries_sorted = sorted(entries, 
                    key=lambda x: x[1] if sort_type == "ID" else 
                                x[0] if sort_type == "NAME" else x[2])
                if entries == entries_sorted:
                    # Regenerate if accidentally sorted
                    entries = generate_test_case(size)
                
                print(f"Test {test_num + 1}: ", end='')
                result = run_test(entries, sort_type)
                print("PASSED" if result else "FAILED")
                
                if not result:
                    print("Failed test case:")
                    print(f"{size}")
                    for entry in entries:
                        print(f"{entry[0]} {entry[1]} {entry[2]}")
                    print(sort_type)
                    break

if __name__ == "__main__":
    main()
