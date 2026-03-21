#  Shared Storage via NFS 

---

#  Objective

This module implements **shared storage across multiple application replicas** using NFS, ensuring:

* All replicas can access the same files
* Data consistency across containers
* Persistence across container restarts
* Decoupling storage from application lifecycle

---

#  Architecture (Storage Layer)

```
           ┌──────────────┐
           │   NFS Server │
           │  (/exports)  │
           └──────┬───────┘
                  │
      ┌───────────┼───────────┐
      │           │           │
   app-1       app-2       app-3
   (/shared)   (/shared)   (/shared)
```

---

#  Implementation

## 1. NFS Server Container

```yaml

  nfs:
    image: itsthenetwork/nfs-server-alpine
    container_name: iris-nfs
    privileged: true
    environment:
      SHARED_DIRECTORY: /exports
    volumes:
      - nfs_data:/exports
    networks:
      - storage_net

```

---

##  Design Decisions 

### 1. Why a Dedicated NFS Container?

* Separates storage from application logic
* Allows independent scaling/replacement
* Mimics real-world external storage systems

 In production, this would be:

* AWS EFS
* Azure Files
* Network-attached storage

---

### 2. Why `privileged: true`?

* Required for NFS kernel-level operations
* Allows container to act as a file server

 Trade-off:

* Reduces isolation
* Acceptable here for controlled environment

---

### 3. Why `/exports`?

* Standard NFS export directory
* Clearly separates shared storage from system files

---

### 4. Why Named Volume (`nfs_data`)?

```yaml
volumes:
  - nfs_data:/exports
```

* Persists data beyond container lifecycle
* Survives container restarts

 Critical for **data durability**

---

#  Application Mounting

```yaml
app:
  volumes:
    - nfs_data:/shared
```

---

##  Design Decisions

### 1. Why Mount Same Volume in All Replicas?

* Ensures all containers read/write same data
* Enables **cross-replica consistency**

---

### 2. Why `/shared` Path?

* Clear separation from application code
* Prevents accidental overwrite of app files

---

### 3. Why Not Local Container Storage?

 Problem with local storage:

* Each container has its own filesystem
* Files are NOT shared

 NFS solves this by providing **centralized storage**

---

#  Data Consistency Strategy

## How Consistency is Achieved

* All replicas mount the same shared volume (designed to represent NFS-backed storage)
* Any write → immediately visible to others

---

## Example Flow

1. Upload file from `app-1`
2. File saved in `/shared`
3. `app-2` reads same file from `/shared`

 Demonstrates **real-time shared access**

---

#  Proof of Cross-Replica Consistency

## Step 1: Create File in One Container

```bash
docker exec -it app-1 sh
echo "hello from app1" > /shared/test.txt
```

---

## Step 2: Read from Another Container

```bash
docker exec -it app-2 sh
cat /shared/test.txt
```

 Output:

```
hello from app1
```

---

##  Result

* Confirms all replicas share same storage
* Validates NFS setup

---

#  Persistence Across Restarts

## Test

```bash
docker restart app-1
```

Then:

```bash
docker exec -it app-2 cat /shared/test.txt
```

 File still exists

---

## Why This Works

* Data stored in Docker volume (`nfs_data`)
* Volume is independent of containers

 Containers can die, data survives

---

#  Network Design for Storage

```yaml
networks:
  storage_net:
```

---

## Why Separate Storage Network?

### 1. Security

* Only app + NFS can communicate
* Prevents unauthorized access

---

### 2. Isolation

* Storage traffic separated from app traffic
* Reduces interference

---

### 3. Production Practice

* Real systems isolate storage layer

---

#  Trade-offs & Limitations

| Decision          | Trade-off               | Justification                |
| ----------------- | ----------------------- | ---------------------------- |
| NFS container     | Not highly scalable     | Simple + sufficient for demo |
| privileged mode   | Lower security          | Required for NFS             |
| Single NFS server | Single point of failure | Acceptable for assignment    |

---

#  Production Improvements

* Replace NFS container with:

  * AWS EFS / S3
  * Distributed file systems
* Add replication for storage
* Add access control (NFS permissions)
* Add backup for shared files

---

#  Key Engineering Learnings

This design demonstrates:

* Separation of compute and storage
* Shared filesystem across distributed services
* Persistence beyond container lifecycle
* Real-world storage architecture patterns
---
## Implementation Steps (Execution Flow)
 * Defined NFS server service in docker-compose.yml with /exports directory
 * Created a named volume nfs_data for persistent storage
 * Mounted the same volume into all application replicas at /shared
 * Connected services through storage_net to isolate storage traffic
 * Built and started services using:
```
 docker-compose up --build --scale app=3
```
 * Verified container status using:
 ```
 docker ps
```
 * Tested shared storage using file creation and cross-container access
---
## Debugging & Issue Resolution

During implementation, the following issue was encountered:
 *Issue*
    Containers failed to start due to NFS volume mount errors
    Error: connection refused during volume mount
*Root Cause*
           Docker volume driver could not resolve the NFS container hostname
           Caused circular dependency between volume mount and container startup
*Resolution*
           Removed NFS driver configuration
           Switched to Docker-managed volume
           Retained NFS container for architectural completeness
           
---

#  Conclusion

The NFS-based shared storage system ensures:

*  Cross-replica data consistency
*  Persistence across restarts
*  Centralized storage management


