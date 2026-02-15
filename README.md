# Nginx Request Rate Limiting

This project demonstrates **limiting HTTP requests per client** using Nginx to protect your application from overload or abuse.

---

## Objective

- Limit requests per second per client  
- Return `429 Too Many Requests` if the limit is exceeded  
- Allow short bursts without affecting performance

---

## Prerequisites

- Docker installed ([Docker Desktop](https://www.docker.com/products/docker-desktop/))  
- Basic Nginx knowledge  

---

## Project Structure

nginx-rate-limit/
 Dockerfile
 default.conf
 html/index.html

---

## Nginx Configuration (`default.conf`)

```nginx
http {
    limit_req_zone $binary_remote_addr zone=one:10m rate=5r/s;

    server {
        listen 80;
        server_name localhost;

        location / {
            limit_req zone=one burst=10 nodelay;
            root /usr/share/nginx/html;
            index index.html;
        }
    }
}
```
##Docker Setup

Dockerfile:
```
FROM nginx:alpine
COPY default.conf /etc/nginx/conf.d/default.conf
COPY html /usr/share/nginx/html
```


Build & Run:
```
docker build -t nginx-rate-limit .
docker run -d -p 8080:80 --name nginx-rate-limit-container nginx-rate-limit
```

Reload Nginx (after changes):
```
docker exec -it nginx-rate-limit-container nginx -s reload
```
Testing Rate Limit
```
for i in {1..20}; do curl -i http://localhost:8080/; done
```
##screenshot
![output](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-7a/screenshots/Task%207.png)
