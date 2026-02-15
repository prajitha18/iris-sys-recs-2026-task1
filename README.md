# Dockerized Rails Application Project

This project demonstrates a **complete Dockerized setup** for a Rails application with MySQL, Nginx, load balancing, persistence, and request rate limiting. The project is divided into multiple branches, each focusing on a specific task or feature.  

The main goal is to build a **production-ready environment** for a Rails application using Docker and Docker Compose.

---

## Project Overview

The project covers:

1. **Rails Application Containerization**  
   - Pack the Rails app into a Docker container image.  
   - Launch the app in a container and connect it to a MySQL database container.

2. **MySQL Database Setup**  
   - Launch MySQL in a separate container.  
   - Database port is **internal only**, not exposed to the host.  
   - Enable **persistent storage** for database data.

3. **Application Exposure**  
   - Rails app exposed to host on **localhost:8080**.  

4. **Nginx Reverse Proxy & Load Balancing**  
   - Launch an Nginx container to act as a reverse proxy.  
   - Load balances incoming requests across multiple Rails app containers (3 replicas).  
   - Nginx exposed at **localhost:80**, Rails app should not be accessed directly.

5. **Persistence**  
   - Persistent storage for MySQL data and Nginx configuration, so data and config survive container restarts.

6. **Request Rate Limiting**  
   - Limit the number of requests a client can send to the app using Nginx.  
   - Prevents abuse or accidental overload.  

7. **Docker Compose Orchestration**  
   - All containers can be brought up together with **one command**.  
   - Simplifies management of multiple containers and ensures proper networking.

---

## Branch Overview

| Branch Name            | Task / Feature |
|------------------------|----------------|
| `rails-docker`         | Containerize Rails application and run in Docker. |
| `mysql-container`      | Set up MySQL container with internal-only networking and persistence. |
| `nginx-reverse-proxy`  | Configure Nginx as reverse proxy for Rails app. |
| `load-balancing`       | Launch multiple Rails app containers and configure Nginx load balancing. |
| `persistence`          | Add persistent storage for MySQL and Nginx. |
| `docker-compose`       | Orchestrate all containers using Docker Compose. |
| `rate-limit`           | Add request rate limiting in Nginx. |

---

## Accessing the Application

- **Via Nginx (recommended):** [http://localhost](http://localhost)  
- **Direct Rails app (internal, not recommended):** localhost:8080 (for testing)  
- **Database:** Internal container access only  

---

## Quick Start

1. Build and launch all containers with Docker Compose:

```bash
docker-compose up -d
```
2. Stop all containers:
```
docker-compose down
```

3. Reload Nginx after config changes:
```
docker exec -it nginx-container nginx -s reload
```
### References

Docker Documentation

Docker Compose Documentation

Nginx Limit Request Module

Rails Guides

### Result: A fully Dockerized, load-balanced, persistent Rails application setup with Nginx reverse proxy and request rate limiting.
