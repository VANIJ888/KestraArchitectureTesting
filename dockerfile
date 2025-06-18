FROM python:3.12-slim
WORKDIR /app
COPY . /app

FROM ubuntu:latest

RUN apt-get update && apt-get install -y cron

# Copy your cron job file (e.g., crontab) into the container
COPY crontab /etc/cron.d/my_cron_job
RUN chmod 0644 /etc/cron.d/my_cron_job
RUN echo "" >> /etc/cron.d/my_cron_job
RUN crontab /etc/cron.d/my_cron_job

# Add an entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh


# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your app
COPY . .

# RUN pip install -r requirements.txt
ENTRYPOINT ["/docker-entrypoint.sh"]
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     libssl-dev \
#     libffi-dev \
#     python3-dev \
#     default-libmysqlclient-dev \
#     libmariadb-dev-compat \
#     libmariadb-dev \
#     pkg-config
