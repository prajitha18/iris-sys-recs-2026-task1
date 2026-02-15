# Task 1 – Dockerizing the Rails Application

## Objective

The objective of this task is to package the Rails application into a Docker container image and successfully run it inside a Docker container.

---

## Architecture Overview

At this stage, only the Rails application is containerized.

Host Machine

Docker Container (Rails Application)


---

## Implementation Steps

### 1. Created a Dockerfile

A `Dockerfile` was created in the root directory of the project to containerize the Rails application.

**Dockerfile content:**

```dockerfile
FROM ruby:3.2

WORKDIR /app

# Install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Expose Rails default port
EXPOSE 3000
# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
```
### 2. Built Docker Image
```
docker build -t iris-rails-app1 .
```
### 3. Launched Docker Container
```
docker run -d -p 8080:3000 iris-rails-app1

```
## Application Access

After running the container, the application was accessible at:

http://localhost:8080
## Screenshot
![output1](https://github.com/prajitha18/iris-sys-recs-2026/blob/task-1a/screenshots/task1-building-image.png)


``
