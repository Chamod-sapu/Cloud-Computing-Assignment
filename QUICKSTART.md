# Quick Start Guide - E-Commerce MapReduce

## For the Impatient (5-Minute Setup)

### 1. Install Hadoop (One-Time Setup)
```bash
cd scripts
chmod +x install_hadoop.sh
./install_hadoop.sh
source ~/.bashrc
```

### 2. Start Hadoop
```bash
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
jps  # Verify services are running
```

### 3. Generate Data
```bash
cd code
python3 generate_data.py
```

### 4. Run MapReduce Job
```bash
cd ../scripts
chmod +x run_mapreduce.sh
./run_mapreduce.sh
```

### 5. View Results
```bash
cd ../code
python3 analyze_results.py ../output/final_results.txt
```

## Alternative: Test Locally First (No Hadoop)
```bash
cd scripts
chmod +x local_test.sh
./local_test.sh
```

## Generate Report
```bash
cd code
npm install -g docx  # One-time install
node generate_report.js
# Opens: ../docs/Assignment_Report.docx
```

## Web Interfaces
- **HDFS NameNode**: http://localhost:9870
- **YARN ResourceManager**: http://localhost:8088

## Common Issues

**Hadoop won't start:**
```bash
$HADOOP_HOME/sbin/stop-all.sh
rm -rf ~/hadoopdata/*
$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/sbin/start-all.sh
```

**Permission denied:**
```bash
chmod +x scripts/*.sh
chmod +x code/*.py
```

**Port already in use:**
```bash
# Check what's using the port
sudo lsof -i :9000
sudo lsof -i :8088
# Kill the process or change Hadoop port config
```

## What to Submit

1. ✅ Source code (GitHub or zip)
2. ✅ Dataset (sales_data.csv or link to Kaggle dataset)
3. ✅ README.md with instructions
4. ✅ Report (2 pages max)
5. ✅ Screenshots/logs showing:
   - Hadoop installation (jps output)
   - Job running (YARN web UI)
   - Results (final output)

## Pro Tips

- Test with small data first (1000 rows) before full dataset
- Take screenshots as you go for documentation
- Record a quick screen video showing the job running
- Check the Google Sheet to ensure no duplicate datasets
- Add your team members' names to README and report

## Need Help?

Check:
1. README.md - Detailed instructions
2. Hadoop logs: `$HADOOP_HOME/logs/`
3. YARN web UI: http://localhost:8088 for job status

---
**Good luck with your assignment!** 🚀
