#!/bin/bash

# Variables
script="/opt/$(basename $0)"

# Add cron task
task="task.cron"
echo "# Open ports" > $task
echo "*/1 * * * * bash $script" >> $task
crontab $task
rm -f $task

# Create script
cat << EOF > $script
#!/bin/bash

# Check if already running
[[ \$(pgrep -afc "\$(basename \$0)") -gt 2 ]] && { echo "\$0 already running"; exit; }

# Open ports
ports="3306 5141 9100 9104"
for port in \$ports; do
  nc -l -k -p \$port | nc 127.0.0.1 22 &
done

# Pause
sleep infinity

EOF
