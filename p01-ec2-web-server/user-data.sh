#!/bin/bash
# User data runs once, as root, the first time the instance boots.
dnf update -y
dnf install -y httpd
systemctl enable --now httpd          # start Apache now and on every boot

# IMDSv2: ask for a session token first, then use it to read metadata
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)

cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
  <title>Harmattan Digital</title>
  <style>
    body { font-family: Arial, sans-serif; background: #1a3c6e; color: white; text-align: center; padding: 50px; }
    .box { background: #2e75b6; border-radius: 12px; padding: 40px; display: inline-block; }
    h1 { font-size: 2.5em; color: #ffcc00; }
    .tag { background: #ffcc00; color: #1a3c6e; border-radius: 6px; padding: 4px 12px; font-weight: bold; }
  </style>
</head>
<body>
  <div class='box'>
    <h1>Welcome to Harmattan Digital</h1>
    <p>Hosted on <span class='tag'>Amazon EC2</span></p>
    <p>Instance ID: <span class='tag'>$INSTANCE_ID</span></p>
    <p>Availability Zone: <span class='tag'>$AZ</span></p>
    <p>Public IP: <span class='tag'>$PUBLIC_IP</span></p>
  </div>
</body>
</html>
EOF