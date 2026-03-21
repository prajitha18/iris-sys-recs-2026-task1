#  Monitoring Stack (Prometheus + Grafana + System Metrics)

---

#  Objective

This module implements a **production-grade monitoring system** that:

* Collects metrics from infrastructure and application layers
* Visualizes system health in real-time dashboards
* Ensures monitoring services are **secure and not publicly exposed**

---

#  Monitoring Architecture

```id="m2r6yy"
                ┌──────────────┐
                │ Node Exporter│
                └──────┬───────┘
                       │
                ┌──────▼───────┐
                │   cAdvisor   │
                └──────┬───────┘
                       │
   ┌────────────┐      │       ┌────────────┐
   │   NGINX    │──────┼──────▶│ Prometheus │
   └────────────┘      │       └──────┬─────┘
                       │              │
                ┌──────▼───────┐      │
                │ App Replicas │──────┘
                └──────────────┘
                              ↓
                        Grafana (via NGINX)
```

---

#  Components

## 1. Prometheus (Metrics Collector)

* Scrapes metrics from:

  * Node Exporter (system metrics)
  * cAdvisor (container metrics)
  * NGINX (request metrics)
  * App replicas

---

## 2. Grafana (Visualization Layer)

* Connects to Prometheus
* Displays dashboards for:

  * CPU & memory usage
  * Container restarts
  * Request rate
  * Error rate

---

## 3. Exporters

### Node Exporter

* Provides host-level metrics
* CPU, memory, disk, network

---

### cAdvisor

* Provides container-level metrics
* CPU, memory usage per container
* Container lifecycle (restarts, uptime)

---

### NGINX Metrics

* Request counts
* Status codes
* Traffic patterns

---

#  Network Design (Critical)

## Monitoring Network

```yaml id="0e5n0t"
networks:
  monitoring_net:
```

---

##  Design Decisions

### 1. Dedicated Monitoring Network

* Prometheus, Grafana, exporters all run in `monitoring_net`

 because:

* Isolates monitoring traffic from application traffic
* Prevents unnecessary exposure
* Improves security

---

### 2. No Public Port Exposure

 NOT done:

```yaml id="h9g3pq"
ports:
  - "9090:9090"
```

 Instead:

* Access only via NGINX reverse proxy

---

## Why?

* Prevents direct access to monitoring tools
* Centralizes access control in NGINX
* Enables authentication

 **Production best practice**

---

#  Secure Access via NGINX

## Grafana Routing

```nginx id="8jco8g"
server {
    listen 80;
    server_name grafana.localhost;

    location / {
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/.htpasswd;

        proxy_pass http://grafana:3000;
    }
}
```

---

## Design Decisions

### 1. Why Proxy via NGINX?

* Single entry point for all services
* Easier to apply security policies

---

### 2. Why Basic Auth?

* Lightweight protection
* No need to modify Grafana config

---

### 3. Why Not Expose Grafana Directly?

* Avoids unauthorized access
* Reduces attack surface

---

#  Prometheus Configuration

## Example `prometheus.yml`

```yaml id="n37yuk"
scrape_configs:

  # App replicas
  - job_name: 'app'
    static_configs:
      - targets: ['app:3000']

  # Node Exporter
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  # cAdvisor
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  # NGINX metrics
  - job_name: 'nginx'
    static_configs:
      - targets: ['nginx:80']
```

---

##  Design Decisions

### 1. Static Config vs Service Discovery

* Static config used for simplicity

 Trade-off:

* Easier debugging
* Less dynamic

---

### 2. Scraping Multiple Layers

| Layer       | Tool          |
| ----------- | ------------- |
| Host        | Node Exporter |
| Containers  | cAdvisor      |
| Proxy       | NGINX         |
| Application | App           |

 Gives **full system observability**

---

#  Grafana Dashboards

## Metrics Visualized

### 1. CPU & Memory Usage

* From Node Exporter + cAdvisor
* Shows system and container load

---

### 2. Container Restarts

* From cAdvisor
* Detects instability

---

### 3. Request Rate

* From NGINX
* Shows traffic trends

---

### 4. Error Rate

* Based on HTTP status codes
* Detects failures

---

## Why These Metrics?

* Cover both **infrastructure + application health**
* Provide actionable insights

---

#  Observability Design Philosophy

This stack follows:

### 1. Multi-Layer Monitoring

* Infrastructure + container + app

---

### 2. Centralized Metrics

* Prometheus aggregates everything

---

### 3. Visual Insights

* Grafana dashboards

---

### 4. Secure Access

* No direct exposure
* Controlled via NGINX

---

#  Testing

## Verify Prometheus

* Check targets:

```
http://prometheus.localhost
```

(via NGINX if configured)

---

## Verify Grafana

```
http://grafana.localhost
```

* Should require authentication

---

## Validate Metrics

* CPU usage visible
* Containers listed
* Requests tracked

---

#  Trade-offs & Limitations

| Decision                   | Trade-off            | Justification          |
| -------------------------- | -------------------- | ---------------------- |
| Static scrape config       | Not dynamic          | Simpler setup          |
| Basic Auth                 | Not enterprise-grade | Lightweight            |
| Single Prometheus instance | No HA                | Acceptable for project |

---

#  Production Improvements

* Add service discovery (Kubernetes)
* Add alerting (Alertmanager)
* Use OAuth instead of Basic Auth
* Add TLS (HTTPS)
* Enable long-term storage

---

## Why These Metrics Matter

- CPU & Memory → Detect system overload and scaling needs  
- Container Restarts → Identify crashes and instability  
- Request Rate → Understand traffic patterns and load  
- Error Rate → Detect failures and user-impacting issues  

These metrics together provide a complete view of:
- System health
- Application performance
- User experience impact
---
## NGINX Metrics Collection

NGINX metrics are exposed using the `stub_status` module.

Example:

location /nginx_status {
    stub_status;
    allow 127.0.0.1;
    deny all;
}

Prometheus scrapes this endpoint to collect:
- Active connections
- Requests handled
- Reading/Writing/Waiting states
---

## Application Metrics

The application exposes metrics via an HTTP endpoint (e.g., `/metrics`).

This can be implemented using:
- Prometheus client libraries (Ruby, Python, etc.)

These metrics include:
- Request count
- Response time
- Error count
---

## Failure Handling

If one component fails:

- App failure → NGINX routes to healthy replicas  
- Exporter failure → Partial metrics loss, system still runs  
- Prometheus failure → Metrics temporarily unavailable  
- Grafana failure → Visualization unavailable but data still collected  

This ensures system continues functioning even under partial failures.

---

## Why Prometheus is NOT Exposed

Prometheus provides internal system metrics and should not be publicly accessible because:

- It exposes infrastructure details  
- It can be used for reconnaissance attacks  
- It is not designed for public access  

Instead, access is restricted via internal network or NGINX proxy.

---

# Implementation Steps

*  Added Prometheus and Grafana services in docker-compose.yml
*  Added exporters:
*  Node Exporter for host metrics
*  cAdvisor for container metrics
*  Created a dedicated network monitoring_net for isolation
*  Configured Prometheus using prometheus.yml with static scrape targets
*  Connected all services to monitoring_net
*  Configured NGINX to route:
*  grafana.localhost → Grafana
*  prometheus.localhost → Prometheus
*  Secured Grafana using HTTP Basic Authentication
*  Started services using:
```
docker-compose up --build
```
Verified metrics collection and dashboards in Grafana

# Debugging & Issue Encountered
 ** Issue **: Incorrect Prometheus Targets
 

 Initially, Prometheus was configured with:
```
targets: ['app-1:3000', 'app-2:3000', 'app-3:3000']
```
**Problem**
Docker Compose does not guarantee fixed container names
Prometheus could not consistently scrape metrics
Solution:


*Replaced with:*
```
targets: ['app:3000']
```
Why this works


*  Docker provides built-in DNS for service names
*  app automatically load balances across replicas

#  Conclusion

This monitoring stack ensures:

*  Full system visibility
*  Real-time performance tracking
*  Secure access control
*  Production-style observability

It demonstrates how real systems monitor:

 Infrastructure
 Containers
 Applications

All through a **centralized, secure, and scalable approach**.

---

# Screenshots
![output1](https://github.com/prajitha18/iris-sys-recs-2026-task1/blob/Task--2-Monitoring-Stack/screenshots/Screenshot%202026-03-20%20190553.png?raw=true)
![output](https://github.com/prajitha18/iris-sys-recs-2026-task1/blob/Task--2-Monitoring-Stack/screenshots/Screenshot%202026-03-20%20190729.png?raw=true)
![output2](https://github.com/prajitha18/iris-sys-recs-2026-task1/blob/Task--2-Monitoring-Stack/screenshots/Screenshot%202026-03-20%20191530.png?raw=true)
![output3](https://github.com/prajitha18/iris-sys-recs-2026-task1/blob/Task--2-Monitoring-Stack/screenshots/Screenshot%202026-03-20%20193206.png?raw=true)
![output4](https://github.com/prajitha18/iris-sys-recs-2026-task1/blob/Task--2-Monitoring-Stack/screenshots/Screenshot%202026-03-21%20201605.png?raw=true)


