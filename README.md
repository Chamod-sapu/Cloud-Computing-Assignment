# E-Commerce Sales Analysis using MapReduce

**Cloud Computing Assignment - Semester 7**  
**Module**: Cloud Computing (EE7222/EC7204)  
**Team Members**: EG/2020/3989, EG/2020/3979, EG/2020/4064

## Project Overview

This project implements a comprehensive MapReduce solution to analyze large-scale e-commerce sales data using Apache Hadoop. The analysis extracts meaningful business insights including sales patterns by region, product categories, sales channels, and temporal trends.

## Dataset Description

- **Source**: Synthetic e-commerce sales dataset (can be replaced with Kaggle dataset)
- **Size**: 100,000+ sales records
- **Format**: CSV with 14 columns
- **Columns**:
  - Order ID, Region, Country, Item Type, Sales Channel
  - Order Priority, Order Date, Ship Date
  - Units Sold, Unit Price, Unit Cost
  - Total Revenue, Total Cost, Total Profit

**Recommended Kaggle Datasets** (you can use instead of synthetic data):
1. [100,000 Sales Records](https://www.kaggle.com/datasets/okhiriadaveoseghale/100000-sales-records)
2. [E-Commerce Sales Dataset](https://www.kaggle.com/datasets/berkayalan/ecommerce-sales-dataset)

## MapReduce Task

**Objective**: Multi-dimensional sales aggregation and analysis

**Mapper Output**:
- Sales by Region and Item Type
- Sales by Country
- Sales by Sales Channel
- Monthly sales trends

**Reducer Output**:
- Order count
- Total units sold
- Total revenue
- Total profit
- Profit margin percentage

## Prerequisites

- Ubuntu 20.04 or later (or WSL2 on Windows)
- 4GB+ RAM recommended
- 20GB+ free disk space
- Internet connection for Hadoop download

## Installation & Setup

### Step 1: Clone/Download the Project

```bash
git clone <your-repo-url>
cd ecommerce-mapreduce
```

### Step 2: Install Hadoop

Run the automated installation script:

```bash
cd scripts
chmod +x install_hadoop.sh
./install_hadoop.sh
```

This script will:
- Install Java (OpenJDK 11)
- Install and configure SSH
- Download Hadoop 3.3.6
- Configure Hadoop in pseudo-distributed mode
- Format HDFS namenode

**After installation**, reload your environment:
```bash
source ~/.bashrc
```

### Step 3: Start Hadoop Services

```bash
# Start HDFS
$HADOOP_HOME/sbin/start-dfs.sh

# Start YARN
$HADOOP_HOME/sbin/start-yarn.sh

# Verify services are running
jps
```

You should see:
- NameNode
- DataNode
- ResourceManager
- NodeManager
- SecondaryNameNode

**Web Interfaces**:
- HDFS NameNode: http://localhost:9870
- YARN ResourceManager: http://localhost:8088

### Step 4: Generate Dataset

```bash
cd code
python3 generate_data.py
```

This creates `data/sales_data.csv` with 100,000 records.

**Alternative**: Download a dataset from Kaggle and place it in the `data/` folder, then modify the mapper to match the CSV structure.

## Running the MapReduce Job

### Execute the Complete Pipeline

```bash
cd scripts
chmod +x run_mapreduce.sh
./run_mapreduce.sh
```

This script will:
1. Check if Hadoop is running
2. Upload data to HDFS
3. Run the MapReduce job
4. Download results to `output/final_results.txt`
5. Display top 10 results

### Manual Execution (Alternative)

```bash
# 1. Upload data to HDFS
hdfs dfs -mkdir -p /user/$USER/ecommerce/input
hdfs dfs -put data/sales_data.csv /user/$USER/ecommerce/input/

# 2. Make scripts executable
chmod +x code/mapper.py code/reducer.py

# 3. Run MapReduce
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -files code/mapper.py,code/reducer.py \
    -mapper "python3 mapper.py" \
    -reducer "python3 reducer.py" \
    -input /user/$USER/ecommerce/input/sales_data.csv \
    -output /user/$USER/ecommerce/output

# 4. View results
hdfs dfs -cat /user/$USER/ecommerce/output/part-* | head -20
```

## Output Format

Results are tab-separated with the following columns:

```
<Key>\t<Order_Count>\t<Units_Sold>\t<Revenue>\t<Profit>\t<Profit_Margin%>
```

**Example**:
```
Asia|Cosmetics    523    2456789    123456789.50    45678901.25    37.02
Europe|Clothes    612    3567891    234567890.75    89012345.67    37.95
```

## Project Structure

```
ecommerce-mapreduce/
├── code/
│   ├── mapper.py           # MapReduce mapper
│   ├── reducer.py          # MapReduce reducer
│   └── generate_data.py    # Dataset generator
├── data/
│   └── sales_data.csv      # Input dataset (generated)
├── scripts/
│   ├── install_hadoop.sh   # Hadoop installation
│   └── run_mapreduce.sh    # Job execution script
├── output/
│   └── final_results.txt   # MapReduce results
├── docs/
│   └── report.pdf          # Analysis report
└── README.md               # This file
```

## Testing with Sample Data

Test with a small sample first:

```bash
# Create a small test file (1000 records)
head -1001 data/sales_data.csv > data/test_sample.csv

# Modify run_mapreduce.sh to use test_sample.csv
# Then run the job
```

## Troubleshooting

### Hadoop Not Starting
```bash
# Check logs
cat $HADOOP_HOME/logs/*.log

# Restart services
$HADOOP_HOME/sbin/stop-all.sh
$HADOOP_HOME/sbin/start-all.sh
```

### Port Already in Use
```bash
# Check what's using port 9000 or 8088
sudo lsof -i :9000
sudo lsof -i :8088
```

### Out of Memory
Edit `$HADOOP_HOME/etc/hadoop/mapred-site.xml` and add:
```xml
<property>
    <n>mapreduce.map.memory.mb</n>
    <value>2048</value>
</property>
```

## Performance Observations

- **Dataset Size**: 100,000 records
- **Processing Time**: ~2-5 minutes (depends on hardware)
- **Output Size**: ~500-1000 lines (aggregated results)

## Future Enhancements

1. Implement combiner for optimization
2. Add data visualization dashboard
3. Real-time streaming analysis
4. Integration with Apache Spark for comparison
5. Machine learning for sales prediction

## References

- [Apache Hadoop Documentation](https://hadoop.apache.org/docs/stable/)
- [Hadoop Streaming](https://hadoop.apache.org/docs/stable/hadoop-streaming/HadoopStreaming.html)
- [MapReduce Tutorial](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html)

## Team Members

Jayasinghe U.R – EG/2020/3989
Jayalath K.M.S.M – EG/2020/3979
Illangasinghe H.M.C.S.B – EG/2021/4560 

---
**University of Ruhuna - Faculty of Engineering**
