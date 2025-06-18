# Use Python base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install cron and system dependencies
RUN apt-get update && apt-get install -y \
    cron \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    default-libmysqlclient-dev \
    libmariadb-dev-compat \
    libmariadb-dev \
    pkg-config \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set up cron job
COPY crontab /etc/cron.d/my_cron_job
RUN chmod 0644 /etc/cron.d/my_cron_job \
 && echo "" >> /etc/cron.d/my_cron_job \
 && crontab /etc/cron.d/my_cron_job

# Add and set permissions for entrypoint script
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]