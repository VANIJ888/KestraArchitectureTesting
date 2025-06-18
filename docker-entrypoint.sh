#!/bin/bash
# Start cron in the foreground
cron -f &

# Your application startup commands
# ...

# Keep the container running
tail -f /dev/null