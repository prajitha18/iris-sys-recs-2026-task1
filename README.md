# Nginx Reverse Proxy for Rails Application

This project demonstrates how to set up **Nginx** as a reverse proxy for a **Rails application**.  
All requests to the Rails app go through Nginx on port `80`. Direct access to Rails is blocked.

---

## Table of Contents
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)
- [Testing](#testing)
- [Notes](#notes)

---

## Prerequisites
- [Docker](https://www.docker.com/) installed  
- [Docker Compose](https://docs.docker.com/compose/) (optional)  
- Rails application running on port `3000`  

---


---

## Setup Instructions

### 1. Nginx Configuration
Create `nginx/default.conf`:

![code](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%203(config%20code).png?raw=true)

### 2. Nginx Dockerfile

Create nginx/Dockerfile:
```
FROM nginx:latest
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```
### 3. Build and Run Nginx Container
```
cd nginx
docker build -t nginx-reverse-proxy .
docker run -d --name nginx-proxy -p 80:80 nginx-reverse-proxy
```
Run with:
```
docker-compose up -d
```
### Testing

Open http://localhost
 in a browser

Rails application should load via Nginx

Direct access to Rails on port 3000 is discouraged
## Screenshot
![output](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%203.png?raw=true)
