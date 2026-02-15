# Task: Docker Compose Setup

## Task Description
This task involves using **Docker Compose** to bring multiple containers (e.g., application, database, Nginx) up together with a **single command**, instead of starting each container individually.  

## Steps Taken
1. Created a `docker-compose.yml` file defining all services:
   - Application container (e.g., Iris System Recs app)
   - Database container
   - Optional Nginx container for reverse proxy
2. Configured ports, environment variables, and volume mappings in the `docker-compose.yml`.
3. Tested the setup locally to ensure all containers start together and communicate correctly.

## Commands / Configuration Used
```markdown
```bash
# To start all containers together:
docker-compose up -d

# To stop all containers:
docker-compose down
```

## Screenshots

![Containers Up](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-original(contains-all-the-branches-instead-of-main)/screenshots/task%205%20(compose).png?raw=true)

