# Task 1: Pack Rails Application in a Docker Container

## Objective
- Package the Rails application into a Docker container image.

## Steps Followed
1. Created a `Dockerfile` for the Rails application.
2. Specified base image, dependencies, and working directory in the Dockerfile.
3. Added Rails app files into the container using `COPY`.
4. Ran `bundle install` inside the container to install dependencies.
5. Built the Docker image:
```bash
docker build -t iris-rails-app .
6. Verified the image creation with:
```bash 
docker images
7. Ran the container to ensure the Rails app starts correctly:
```bash
docker run -d -p 3000:3000 iris-rails-app
