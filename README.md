# Task 2 – Dockerizing Rails Application with MySQL

## Objective

The objective of this task is to run the Rails application and MySQL database in separate Docker containers and ensure they can communicate internally.  
The Rails application should be accessible on the host at port `8080`, while the MySQL database should remain internal to the Docker network and not exposed externally.

---


- Rails container exposes port `8080` to the host.  
- MySQL container port is **not exposed** to the host, only accessible internally within the Docker network.

---

## Implementation Steps

### 1. Create a Docker Network

Create a dedicated Docker network to allow the Rails app and MySQL containers to communicate internally:

```bash
docker network create rails-mysql-network
```
### 2. Launch MySQL Container

Run the MySQL container inside the network without exposing it to the host:
![output](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-2a/screenshots/task%202%20(%20connecting%20sql).png?raw=true)
### 3. Configure Rails Database Connection

Update your Rails config/database.yml to connect to the MySQL container:
![code](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-2a/screenshots/task%202%20(connecting%20sql2).png?raw=true)
### 4. Build Rails Docker Image
```
docker build -t iris-rails-app .
```
### 5. Launch Rails Container

Run the Rails container and attach it to the same network:
```
docker run -d \
  --name iris-rails \
  --network rails-networkmen \
  -p 8080:3000 \
  iris-rails-app
```
## Application Access

After launching both containers, the Rails application can be accessed at:

http://localhost:8080

The MySQL database is internal only and cannot be accessed from the host directly.

## Screenshot
[output2](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-2a/screenshots/task%202%20(output).png?raw=true)
## Results
Rails application successfully connected to MySQL in separate containers.

Rails accessible on host at localhost:8080.

MySQL is internal, ensuring security and isolation.
