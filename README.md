#  Automated Backup System

##  Overview
This project includes an automated backup service that periodically:
- Dumps the MySQL database
- Archives shared application data from NFS storage
- Maintains a retention policy to keep only the latest backups

---

##  Components Used

- **MySQL Client (`mysqldump`)** → for database backups  
- **Tar Utility (`tar`)** → for compressing shared storage  
- **Docker Volume (NFS)** → source of persistent shared data  
- **Alpine Linux Container** → lightweight backup service  

---

##  How It Works

The backup service runs inside a container and executes a loop:

1. Waits for MySQL to become available  
2. Generates a timestamp  
3. Dumps the database  
4. Archives shared storage  
5. Deletes old backups (keeps latest 5)  
6. Repeats every 5 minutes  

---

##  Backup Workflow

[Start]

↓

Wait for MySQL

↓

Create Timestamp

↓

Dump MySQL → db_<timestamp>.sql

↓

Archive NFS → files_<timestamp>.tar.gz

↓

Delete old backups (keep last 5)

↓

Sleep (5 min)

↓

Repeat

---

## Types of Backups
 **Database Backup**
 
File format: .sql

Created using mysqldump

Contains:

Table structure

Data (INSERT statements)

**Storage Backup**

File format: .tar.gz

Contains:

Files from shared NFS volume

Uploaded assets / app storage

---

## Retention Policy
```
ls -tp | tail -n +6 | xargs -r rm -f --
```
Keeps only the latest 5 backups

Automatically deletes older ones

## Verification Steps

1. Check backup logs
```
docker logs -f iris-backup
```
Expected output:
```
=== BACKUP START ===
=== BACKUP DONE ===
```
2. Verify SQL file is not empty
```
type backups/db_<timestamp>.sql
```
Should contain:
```
CREATE TABLE ...
INSERT INTO ...
```
3. Extract storage backup
```
tar -xvf backups/files_<timestamp>.tar.gz
```
## Design Decisions

Isolated container → avoids affecting main app

Volume mounting → ensures access to shared storage

Loop-based execution → simple cron alternative

Retention policy → prevents storage overflow

Network separation → secure DB access

---

## Notes

Backup runs every 5 minutes

MySQL must be reachable via service name db

Data persists even if containers restart

---

## Outcome

This backup system ensures:

 Data safety
 Automatic recovery support
 Minimal manual intervention
 Production-like reliability

 ---

 # Screenshot
 ![output]()
 ![output1]()
 ![output2]()
 ![output3]()
 
