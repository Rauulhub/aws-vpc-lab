#!/bin/bash
# Actualiza paquetes
yum update -y

# Instala utilidades necesarias
yum install -y aws-cli httpd jq

# Habilita y levanta servidor web
systemctl enable httpd
systemctl start httpd

# Obtiene token para metadatos (IMDSv2)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Recupera metadatos
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)
PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

# Crea archivo HTML con información
echo "<html><body><h1>This message was generated on instance $INSTANCE_ID with the following IP: $PRIVATE_IP</h1></body></html>" \
  > /var/www/html/index.html

# Genera archivo txt y sube a S3 (bucket ya configurado)
FILENAME="instance-${INSTANCE_ID}.txt"
echo "Instance ID: $INSTANCE_ID | IP: $PRIVATE_IP" > /tmp/$FILENAME

# Reemplaza <BUCKET_NAME> por el nombre real si lo provee el entorno
aws s3 cp /tmp/$FILENAME s3://<BUCKET_NAME>/
