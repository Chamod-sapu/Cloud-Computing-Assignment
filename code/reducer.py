#!/usr/bin/env python3
import sys

current_key = None
total_count = 0
total_units = 0
total_revenue = 0.0
total_profit = 0.0

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
        
    parts = line.split('\t')
    if len(parts) != 2:
        continue
        
    key = parts[0]
    values = parts[1].split(',')
    
    if len(values) != 4:
        continue
        
    try:
        count = int(values[0])
        units = int(values[1])
        revenue = float(values[2])
        profit = float(values[3])
    except ValueError:
        continue
        
    if current_key == key:
        total_count += count
        total_units += units
        total_revenue += revenue
        total_profit += profit
    else:
        if current_key:
            profit_margin = (total_profit / total_revenue * 100) if total_revenue > 0 else 0
            # Print format: <Key>\t<Order_Count>\t<Units_Sold>\t<Revenue>\t<Profit>\t<Profit_Margin%>
            print(f"{current_key}\t{total_count}\t{total_units}\t{total_revenue:.2f}\t{total_profit:.2f}\t{profit_margin:.2f}")
        current_key = key
        total_count = count
        total_units = units
        total_revenue = revenue
        total_profit = profit

if current_key:
    profit_margin = (total_profit / total_revenue * 100) if total_revenue > 0 else 0
    print(f"{current_key}\t{total_count}\t{total_units}\t{total_revenue:.2f}\t{total_profit:.2f}\t{profit_margin:.2f}")
