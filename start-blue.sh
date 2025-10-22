#!/bin/bash
# Start script for Blue environment
set -e

cat > /etc/rc.local <<'EOF'
#!/bin/bash
exit 0
EOF
chmod +x /etc/rc.local

# Install minimal webserver (nginx) - Amazon Linux 2
if command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y nginx
  systemctl enable nginx
  cat > /usr/share/nginx/html/index.html <<'HTML'
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>Blue Environment</title></head>
  <body>
    <h1>Blue Environment</h1>
    <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
  </body>
</html>
HTML
  systemctl start nginx
else
  # fallback: python http.server
  mkdir -p /var/www/html
  cat > /var/www/html/index.html <<'HTML'
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>Blue Environment</title></head>
  <body>
    <h1>Blue Environment</h1>
  </body>
</html>
HTML
  nohup python3 -m http.server 80 --directory /var/www/html >/var/log/simple_http.log 2>&1 &
fi
