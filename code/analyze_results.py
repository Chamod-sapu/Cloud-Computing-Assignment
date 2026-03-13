#!/usr/bin/env python3
import sys
import os

if len(sys.argv) < 2:
    print("Usage: python3 analyze_results.py <results_file>")
    sys.exit(1)

results_file = sys.argv[1]

categories = {}

try:
    with open(results_file, 'r') as f:
        for line in f:
            parts = line.strip().split('\t')
            if len(parts) >= 6:
                key, count, units, revenue, profit, margin = parts[0], int(parts[1]), int(parts[2]), float(parts[3]), float(parts[4]), float(parts[5])
                cat_type = key.split('|')[0]
                cat_value = key.split('|')[1] if '|' in key else key
                
                if cat_type not in categories:
                    categories[cat_type] = []
                categories[cat_type].append({
                    'name': cat_value,
                    'count': count,
                    'units': units,
                    'revenue': revenue,
                    'profit': profit,
                    'margin': margin
                })
except FileNotFoundError:
    print(f"Error: Could not find file {results_file}")
    sys.exit(1)

print("="*80)
print(" 📊 E-COMMERCE SALES ANALYSIS MAPREDUCE REPORT ".center(80))
print("="*80)

for cat_name, items in categories.items():
    print(f"\n⚡ Top 5 by {cat_name} (Ranked by Revenue) ⚡")
    print("-" * 80)
    print(f"{'Name':<35} | {'Orders':<8} | {'Revenue ($)':<15} | {'Profit Margin (%)'}")
    print("-" * 80)
    
    # Sort by revenue descending
    items.sort(key=lambda x: x['revenue'], reverse=True)
    
    for item in items[:5]:
        print(f"{item['name'].replace('_', ' '):<35} | {item['count']:<8} | ${item['revenue']:<14,.2f} | {item['margin']:.2f}%")
        
print("\n" + "="*80)
print("Insight Summary:")
print("- We can clearly see specific product types and regions driving the most revenue")
print("- Channels have very distinct order counts vs total output revenue")
print("- MapReduce processed multiple dimensions efficiently in one pass!")
print("="*80)
