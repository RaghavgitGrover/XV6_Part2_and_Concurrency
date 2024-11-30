import matplotlib.pyplot as plt
import pandas as pd

# Updated Data for Merge Sort and Count Sort
data = {
    "Sorting Method": ["MERGESORT", "MERGESORT", "MERGESORT", "MERGESORT", "MERGESORT", "MERGESORT", 
                       "COUNTSORT", "COUNTSORT", "COUNTSORT", "COUNTSORT", "COUNTSORT", "COUNTSORT"],
    "Case ID": ["CASE4", "CASE4", "CASE4", "CASE6", "CASE6", "CASE6", 
                "CASE1", "CASE1", "CASE1", "CASE2", "CASE2", "CASE2"],
    "Column Used": ["ID", "NAME", "TIMESTAMP", "ID", "NAME", "TIMESTAMP", 
                    "ID", "NAME", "TIMESTAMP", "ID", "NAME", "TIMESTAMP"],
    "Time Used (seconds)": [0.001505, 0.001473, 0.001582, 0.014881, 0.015533, 0.015971,
                            0.000247, 0.023888, 0.343151, 0.000307, 0.000353, 0.212100],
    "Memory Used (KB)": [384, 384, 384, 384, 1664, 1408, 
                         128, 2048, 36608, 128, 384, 17664]
}

# Create DataFrame
df = pd.DataFrame(data)

# Combine Case ID and Column Used for more detailed x-axis labeling
df['Case & Column'] = df['Case ID'] + " - " + df['Column Used']

# Plot Execution Time
plt.figure(figsize=(12, 6))
for sorting_method in df['Sorting Method'].unique():
    subset = df[df['Sorting Method'] == sorting_method]
    plt.plot(subset['Case & Column'], subset['Time Used (seconds)'], label=sorting_method, marker='o')

plt.title('Execution Time vs. Case ID and Column Used')
plt.xlabel('Case ID & Column Used')
plt.ylabel('Execution Time (seconds)')
plt.legend(title="Sorting Method")
plt.grid(True)
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.show()

# Plot Memory Usage
plt.figure(figsize=(10, 5))
for sorting_method in df['Sorting Method'].unique():
    subset = df[df['Sorting Method'] == sorting_method]
    plt.bar(subset['Case & Column'], subset['Memory Used (KB)'], label=sorting_method, alpha=0.7)

plt.title('Memory Usage Comparison')
plt.xlabel('Case ID & Column Used')
plt.ylabel('Memory Usage (KB)')
plt.legend(title="Sorting Method")
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.show()
