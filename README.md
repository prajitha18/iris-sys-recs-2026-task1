\# Task 1 – Dockerizing the Rails Application



\## Objective



The objective of this task is to package the Rails application into a Docker container image and successfully run it inside a Docker container.



---



\## Architecture Overview



At this stage, only the Rails application is containerized.



Host Machine  

↓  

Docker Container (Rails Application)



---



\## Implementation Steps



\### 1. Created a Dockerfile



A `Dockerfile` was created in the root directory of the project to containerize the Rails application.



Dockerfile content:



```dockerfile

FROM ruby:3.2



WORKDIR /app



\# Install dependencies

COPY Gemfile Gemfile.lock ./

RUN bundle install



\# Copy application code

COPY . .



\# Expose Rails default port

EXPOSE 3000



\# Start Rails server

CMD \["rails", "server", "-b", "0.0.0.0"]

```



---



\### 2. Built Docker Image



The following command was used to build the Docker image:



```bash

docker build -t iris-rails-app1 .

```



This created a Docker image named `iris-rails-app1`.



---



\### 3. Launched Docker Container



The container was started using:



```bash

docker run -d -p 8080:3000 iris-rails-app1

```



Explanation:



\- `-d` runs the container in detached mode

\- `8080:3000` maps container port 3000 to host port 8080



---



\## Application Access



After running the container, the application was accessible at:



http://localhost:8080



---



\## Screenshots



\### Docker Image Build



!\[Docker Build](screenshots/task1-building-image.png)







\## Result



\- Rails application successfully containerized

\- Docker image built successfully

\- Container launched without errors

\- Application accessible via localhost:8080



---



\## Conclusion



The Rails application has been successfully packaged into a Docker container image and launched as a running container, fulfilling the requirements of Task 1.



