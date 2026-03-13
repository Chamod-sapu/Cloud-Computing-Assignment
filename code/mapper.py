#!/usr/bin/env python3
import sys

# Skip header
first_line = True

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    
    if first_line:
        first_line = False
        if "Region" in line and "Country" in line:
            continue
            
    fields = line.split(',')
    
    if len(fields) < 14:
        continue
        
    region = fields[0].strip()
    country = fields[1].strip()
    item_type = fields[2].strip()
    sales_channel = fields[3].strip()
    order_date = fields[5].strip()
    
    try:
        units_sold = int(fields[8].strip())
        revenue = float(fields[11].strip())
        profit = float(fields[13].strip())
    except ValueError:
        continue
        
    # Extract month-year from Order Date (M/D/YYYY)
    date_parts = order_date.split('/')
    if len(date_parts) == 3:
        month = date_parts[0]
        year = date_parts[2]
        month_year = f"{year}-{month.zfill(2)}"
    else:
        month_year = "Unknown"
        
    # Map by Region and Item Type
    key_region_item = f"RegionItem|{region}_{item_type}"
    print(f"{key_region_item}\t1,{units_sold},{revenue},{profit}")
    
    # Map by Country
    key_country = f"Country|{country}"
    print(f"{key_country}\t1,{units_sold},{revenue},{profit}")
    
    # Map by Sales Channel
    key_channel = f"Channel|{sales_channel}"
    print(f"{key_channel}\t1,{units_sold},{revenue},{profit}")
    
    # Map by Monthly sales trends
    key_month = f"Month|{month_year}"
    print(f"{key_month}\t1,{units_sold},{revenue},{profit}")
