# Nginx Load Balancer for Rails Application (Without Docker Compose)

This project demonstrates how to configure **Nginx** as a **load balancer** for multiple Rails application containers.  
All requests to port `80` go through **Nginx**, which distributes traffic across **three Rails containers**, all connected to a single database container.

---

## Prerequisites
- Docker installed  
- Rails application ready to run in containers  
- Database container (e.g., Postgres)

---

## Setup Overview

1. **Database Container**  
   - Launch a single database container that all Rails containers will connect to.

2. **Rails Application Containers**  
   - Launch **three separate Rails containers**.  
   - Each container connects to the same database.  
   - Do not expose Rails ports publicly; Nginx will forward requests.

3. **Nginx Load Balancer**  
   - Launch an Nginx container configured to forward requests to all three Rails containers.  
   - Load balancing uses **round-robin** by default.  
   - Expose Nginx on **port 80**.

> Full Nginx and Rails configuration files are available in the `nginx/` and Rails folders.
> ![output3](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%204%20(load%20balancing).png?raw=true)

---

## Running the Application

![input](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%204%20(launcing%202%20more%20containers).png?raw=true)
![input1](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%204(connecting%20using%201%20data%20base.png?raw=true)

The application is now accessible at http://localhost

Nginx automatically distributes requests across the three Rails containers.

### Testing

Open http://localhost

Requests should be routed to different Rails containers in round-robin fashion.

Direct access to Rails container ports is discouraged.
### Screenshot
![output](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%204%20(output1).png?raw=true)
![output2](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%204%20(output2).png?raw=true)
![input2](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-3a/screenshots/task%204%20(output3).png?raw=true)

### Notes

All Rails containers share a single database; ensure database consistency.

Nginx round-robin is the default load balancing method.

This setup is a precursor to Docker Compose, which can simplify multi-container management.

You can extend Nginx to add SSL, caching, or advanced routing in the future.
