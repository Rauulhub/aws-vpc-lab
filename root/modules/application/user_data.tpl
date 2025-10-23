#!/bin/bash
set -e

COMPUTE_MACHINE_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid | tr '[:upper:]' '[:lower:]')
COMPUTE_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id || echo "unknown")

cat > /var/www/html/index.html <<EOF
<html>
  <body>
    <h1>Instance info</h1>
    <p>This message was generated on instance ${COMPUTE_INSTANCE_ID} with the following UUID ${COMPUTE_MACHINE_UUID}</p>
  </body>
</html>
EOF

# install a minimal web server (Amazon Linux / Debian compatible)
if command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y httpd
  systemctl enable httpd
  systemctl start httpd
elif command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y apache2
  systemctl enable apache2
  systemctl start apache2
else
  # fallback to python http server
  mkdir -p /var/www/html
  nohup python3 -m http.server 80 --directory /var/www/html >/dev/null 2>&1 &
fi
