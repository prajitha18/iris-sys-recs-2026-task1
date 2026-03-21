#  IRIS Sys Recs 2026 Task -2 - Production-Grade Docker Infrastructure

##  What This Project Demonstrates

This repository is not just a Docker setup ,
it is a **mini production infrastructure** designed with real-world backend engineering principles:

*  Secure by default (zero unnecessary exposure)
*  Horizontally scalable (multi-replica architecture)
*  Fully observable (metrics + dashboards)
*  Persistent (shared storage + backups)
*  Controlled entry point (reverse proxy gateway)

---

##  Architecture Philosophy

This system is built on **three core ideas**:

### 1. **Everything is Private by Default**

No service is exposed unless absolutely necessary.

 Only **NGINX** is public
 Everything else lives in isolated internal networks

---

### 2. **Separation of Concerns**

Each responsibility is isolated:

* Traffic handling : NGINX
* Business logic : App replicas
* Data : MySQL
* Storage : NFS
* Observability : Prometheus + Grafana

---

### 3. **Least Privilege Networking**

Every container can only talk to what it *must* talk to — nothing more.

---

##  System Architecture

```
                 INTERNET
                     │
                     ▼
              ┌────────────┐
              │   NGINX    │  ← Only public entry
              └────┬───────┘
                   │
        ┌──────────┼──────────┐
        ▼          ▼          ▼
     app1       app2       app3   ← Load balanced replicas
        │          │          │
        └──────┬───┴───┬──────┘
               ▼       ▼
            MySQL     NFS
                         │
                     Backup

Monitoring Layer:
Prometheus <-- scrapes everything
Grafana <-- visualizes (via NGINX only)
```

---

##  Network Design (Critical Decision)

| Network         | Who Lives Here                 | Why                   |
| --------------- | ------------------------------ | --------------------- |
| **public**      | NGINX                          | External entry only   |
| **application** | NGINX, App replicas, MySQL     | Backend communication |
| **storage**     | App replicas, NFS, Backup      | Shared file access    |
| **monitoring**  | Prometheus, Grafana, exporters | Metrics pipeline      |

---

##  Multi-Network Strategy (Important Insight)

Some containers connect to **multiple networks**:

* **NGINX**

  * public --> receives traffic
  * application --> forwards traffic

* **App replicas**

  * application --> serve requests
  * storage --> read/write files
  * monitoring --> expose metrics

* **Prometheus**

  * monitoring --> core system
  * application --> scrape app metrics

 This is what makes the system **connected yet secure**

---

##  Reverse Proxy (NGINX) – The Brain

###  Load Balancing

* Distributes traffic across all 3 replicas
* Ensures scalability and fault tolerance

---

###  Health Checks + Failover

* Automatically removes unhealthy containers
* Keeps system available even if one replica crashes

---

###  Zero-Downtime Reload

```bash
nginx -s reload
```

* Updates config without killing active users

---

###  Rate Limiting

* Protects system from abuse
* Returns **429 Too Many Requests**

---

###  Smart Routing (Subdomains)

| Route                | Destination |
| -------------------- | ----------- |
| app.localhost        | Application |
| grafana.localhost    | Grafana     |
| prometheus.localhost | Prometheus  |

---

###  Authentication Layer

* Grafana & Prometheus protected using **Basic Auth**

 Important:
Security is enforced **at the gateway**, not inside containers

---

##  Shared Storage (NFS) – Horizontal Scaling Backbone

### Why NFS?

In multi-replica systems:

* Each container is isolated
* Without shared storage → inconsistent data

### Solution:

* Central NFS server
* All replicas mount the same directory

---

###  Proven Guarantees

* Upload from app1 → visible in app2/app3
* Data survives container restarts
* Backup service reads same data

---

##  Monitoring Stack – Full Observability

###  Prometheus Collects:

*  Node Exporter → system stats
*  cAdvisor → container stats
*  NGINX → request metrics
*  App → custom metrics

---

### Grafana Visualizes:

* CPU usage
* Memory usage
* Container restarts
* Request rate
* Error rate

---

###  Secure Access

* No direct ports exposed
* Access only via:

  * `grafana.localhost`
  * `prometheus.localhost`

---

##  Backup System – Data Safety Layer

* Periodically backs up NFS data
* Ensures recovery from failures

 Without this , NFS becomes a single point of failure

---

##  Key Engineering Decisions (What Makes This Strong)

###  1. Zero Trust Exposure

* Only NGINX is public
* Everything else is hidden

---

###  2. Modular Design

* Each component replaceable independently

---

###  3. Observability First

* Metrics are not optional — built-in

---

###  4. Fault Tolerance

* Multi-replica + failover

---

###  5. Real-World Alignment

This architecture mirrors:

* Microservices infra
* Kubernetes patterns (simplified)
* Cloud production systems

---

##  Branch Strategy

Each task is implemented independently:

| Branch          | Focus                   |
| --------------- | ----------------------- |
| `main`          | overview  |
| `reverse-proxy` | NGINX config            |
| `nfs-storage`   | Shared storage          |
| `monitoring`    | Prometheus + Grafana    |
| `backup`        | Backup service          |

 Each branch contains:

* Config files
* Screenshots
* Step-by-step explanation

---



##  Run the Project

```bash
docker-compose up --build
```

### Access:

*  http://app.localhost
*  http://grafana.localhost (auth required)

---

##  Final Thoughts


✔ Secure network isolation
✔ Production-grade reverse proxy
✔ Distributed storage system
✔ Full observability stack
✔ Automated data protection

---

##  If You’re Reviewing This

This system reflects:

* Strong understanding of Docker networking
* Real-world backend architecture thinking
* Security-first mindset
* Scalability and reliability principles

---

