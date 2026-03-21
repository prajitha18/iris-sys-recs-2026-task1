#  Production-Grade Docker System

**NGINX + Rails + MySQL + NFS + Prometheus + Grafana**

---

#  Overview

This project implements a **production-style containerized architecture** using Docker, focusing on:

* Reverse proxy using NGINX
* Load balancing across multiple app replicas
* Secure multi-network design
* Shared storage using NFS
* Monitoring with Prometheus & Grafana
* Automated database backups
* Rate limiting and access control

The system is designed with **real-world engineering principles**, prioritizing scalability, security, and maintainability.

---

#  Architecture

```
Client
   ↓
NGINX (Reverse Proxy)
   ↓
App Replicas (3 containers)
   ↓
MySQL (internal only)
   ↓
Shared Storage (NFS)

Monitoring:
Prometheus → Grafana (protected)
```

---

#  Network Design

## Networks Used

| Network          | Purpose                                  |
| ---------------- | ---------------------------------------- |
| `public`         | External access (only NGINX exposed)     |
| `app_net`        | Communication between app, DB, and NGINX |
| `storage_net`    | NFS shared storage                       |
| `monitoring_net` | Prometheus and Grafana                   |

---

##  Design Decisions

### 1. Network Isolation

* Only NGINX is exposed to the public
* Database is internal-only
* Grafana is not directly exposed

 Reduces attack surface and improves security

---

### 2. Multi-Network Attachments

| Service    | Networks                        |
| ---------- | ------------------------------- |
| NGINX      | public, app_net, monitoring_net |
| App        | app_net, storage_net            |
| DB         | app_net                         |
| NFS        | storage_net                     |
| Backup     | app_net, storage_net            |
| Prometheus | monitoring_net                  |
| Grafana    | monitoring_net                  |

 Each service only gets required access (**least privilege principle**)

---

#  NGINX Configuration

## Key Features Implemented

### 1. Load Balancing

```nginx
upstream app_servers {
    least_conn;
    server app:3000 max_fails=3 fail_timeout=10s;
}
```

### Decision:

* Use `least_conn` for better distribution under uneven load
* Use Docker DNS (`app`) instead of hardcoding container names

 Supports dynamic scaling

---

### 2. Health Checks & Failover

```nginx
server app:3000 max_fails=3 fail_timeout=10s;
```

* Marks backend as failed after repeated errors
* Automatically routes traffic to healthy instances

---

### 3. Rate Limiting

```nginx
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=5r/s;
```

```nginx
limit_req zone=api_limit burst=10 nodelay;
```

### Decision:

* Limit each IP to 5 requests/sec
* Burst support for short spikes

 Prevents abuse and overload
 Returns **HTTP 429** when exceeded

---

### 4. Subdomain Routing

```nginx
server_name app.localhost;
server_name grafana.localhost;
```

### Grafana Login
 Username: admin
 
 Password: admin

### Decision:

* Separate services via subdomains
* Mimics real production routing

---

### 5. Basic Authentication

```nginx
auth_basic "Restricted";
auth_basic_user_file /etc/nginx/.htpasswd;
```

### Decision:

* Protect internal services (Grafana)
* Implemented at proxy level

 No changes required in application

---

### 6. Graceful Reload

```bash
nginx -s reload
```

### Decision:

* Apply config changes without downtime
* Keeps existing connections active

---

#  Application Scaling Strategy

## Scaling Command

```
docker-compose up --scale app=3
```

This creates:

* app-1
* app-2
* app-3

---

## Design Decision

Instead of manually listing containers in NGINX:

```nginx
server app:3000;
```

### Why?

* Docker resolves `app` → multiple container IPs
* Enables automatic load distribution
* Avoids hardcoding container names

 Scalable and production-friendly approach

---

#  Database Design

```yaml
db:
  image: mysql:8
```

## Decisions:

* No exposed ports
* Only accessible via `app_net`

 Prevents direct external access

---

#  Shared Storage (NFS)

## Setup

* NFS server container
* Shared volume mounted in app containers

```yaml
volumes:
  - nfs_data:/shared
```

---

## Why NFS?

* Enables shared file access across replicas
* Required for uploads and consistency

---

#  Backup Strategy

## Implementation

```bash
mysqldump -h db -uroot -proot app_db > /backup/backup.sql
```

Runs every 60 seconds.

---

## Design Decisions

* Simple automated backup using a dedicated container
* Keeps backups separate from application

---

## Trade-offs

* Overwrites same file
* No versioning

 Improvement: add timestamp-based backups

---

#  Monitoring

## Prometheus

```yaml
scrape_configs:
  - job_name: 'app'
    static_configs:
      - targets: ['app:3000']
```

### Decision:

* Monitor application health
* Simple static configuration for clarity

---

## Grafana

* Connected to Prometheus
* Protected via NGINX Basic Auth

---

#  Secrets Management

## Current (Development)

```yaml
MYSQL_ROOT_PASSWORD: root
```

---

## Recommended (Production)

Use `.env` file:

```
MYSQL_ROOT_PASSWORD=strongpassword
```

### Why?

* Prevents secrets in code
* Industry best practice

---

#  Testing

## Load Balancing

* Send multiple requests → distributed responses

## Failover

* Stop one container → system still works

## Rate Limiting

* Excess requests → HTTP 429

## Authentication

* Grafana requires login

## Storage

* Files shared across replicas

---

#  Limitations

| Area          | Current     | Improvement       |
| ------------- | ----------- | ----------------- |
| Secrets       | Hardcoded   | Use `.env`        |
| Backup        | Single file | Add versioning    |
| Health checks | Passive     | Add active checks |
| Scaling       | Manual      | Auto-scaling      |

---

#  Production Best Practices Followed

* Network isolation
* Reverse proxy architecture
* Load balancing
* Automatic failover
* Rate limiting
* Monitoring integration
* Shared storage
* Backup automation

---

#  Conclusion

This project demonstrates:

* Strong system design fundamentals
* Real-world DevOps practices
* Scalable and secure architecture


