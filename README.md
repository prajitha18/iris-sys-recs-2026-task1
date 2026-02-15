# Persistent Database and Nginx Configuration

This project demonstrates how to **enable data persistence** for your Rails application setup:  

- **Database container**: Data remains intact even if the container stops or is removed.  
- **Nginx container**: Configuration files remain persistent across container restarts.

All other functionality remains the same as the Nginx load balancing setup.

---

## Prerequisites
- Docker installed  
- Rails application ready in containers  
- Database container (e.g., Postgres)  
- Nginx configuration files prepared  

---

## Setup Overview

1. **Database Persistence**
   - Use a **Docker volume** to store database files.
   - The database container uses this volume so that data is not lost when the container is removed.

2. **Nginx Configuration Persistence**
   - Mount a host directory (or Docker volume) to `/etc/nginx/conf.d/` in the Nginx container.
   - Any changes to configuration files are saved on the host and persist across container restarts.

---

## Running the Application with Persistence

### 1. Create a volume for the database
```bash
docker volume create rails-db-data
```
### 2. Start the database container with persistent volume
![input](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%205%20(2).png?raw=true)
## Debugging & Cleanup

During development, Docker can create multiple unused containers, networks, and volumes.  
To clean up and free space, the following steps were used:

1. **List all Docker volumes**  
```bash
docker volume ls
```
Remove all unused volumes, networks, and containers
```
docker system prune -a --volumes
```
This command removes all stopped containers, unused networks, dangling images, and unused volumes.
Only active volumes used by running containers remain intact.

Verify cleanup
```
docker volume ls
docker ps -a
```
![input2](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%205(1).png?raw=true)


### 3. Start Nginx container with persistent configuration 
```
docker run -d --name nginx-proxy \
  -p 80:80 \
  -v /path/to/nginx/conf:/etc/nginx/conf.d \
  your-nginx-image
```
![input5](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%205(persistance).png?raw=true)
### Testing

Database changes remain intact even if the database container is removed and recreated.

Nginx configuration changes persist even after restarting the Nginx container.

Application continues to run normally through Nginx load balancing.

### Notes

Docker volumes are the preferred way to persist container data.

Host-mounted directories are useful for configuration files you want to edit without rebuilding the container.

This setup ensures safe data persistence for development and testing environments.

## Screenshot

![output2](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%205(3).png?raw=true)
