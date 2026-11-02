#!/bin/bash

# Exit immediately if any command fails to prevent writing incomplete HTML
set -e

# Request a session token from IMDSv2 valid for 21600 seconds (6 hours)
TOKEN=$(curl -s -f -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Define the base metadata URL and authentication header for reuse
METADATA_URL="http://169.254.169.254/latest/meta-data"
TOKEN_HEADER="X-aws-ec2-metadata-token: $TOKEN"

# Fetch the five required instance metadata values using the IMDSv2 token
INSTANCE_ID=$(curl -s -f -H "$TOKEN_HEADER" "$METADATA_URL/instance-id")
INSTANCE_TYPE=$(curl -s -f -H "$TOKEN_HEADER" "$METADATA_URL/instance-type")
REGION=$(curl -s -f -H "$TOKEN_HEADER" "$METADATA_URL/placement/region")
AZ=$(curl -s -f -H "$TOKEN_HEADER" "$METADATA_URL/placement/availability-zone")
PUBLIC_IP=$(curl -s -f -H "$TOKEN_HEADER" "$METADATA_URL/public-ipv4" || echo "None assigned")

# Capture the current date and time of the update using bash's built-in printf time formatter
printf -v UPDATE_TIME '%(%Y-%m-%d %H:%M:%S %Z)T' -1

# Write the rebuilt Globaltech HTML document directly to Apache's web root
printf '%s\n' "<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Globaltech - Instance Metadata</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            color: #222;
            margin: 40px;
        }
        .card {
            max-width: 600px;
            margin: 0 auto;
            background: #ffffff;
            padding: 24px 32px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }
        h1 {
            color: #0b4f6c;
            margin-top: 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            text-align: left;
            padding: 10px 12px;
            border-bottom: 1px solid #dcdfe3;
        }
        th {
            background-color: #eef2f5;
            width: 45%;
        }
        .timestamp {
            font-size: 0.85em;
            color: #555;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class=\"card\">
        <h1>Globaltech</h1>
        <p>Welcome to the Globaltech web portal. The table below displays live runtime metadata for the Amazon EC2 instance serving this page.</p>
        <table>
            <tr>
                <th>Property</th>
                <th>Value</th>
            </tr>
            <tr>
                <td>Instance ID</td>
                <td>$INSTANCE_ID</td>
            </tr>
            <tr>
                <td>Instance Type</td>
                <td>$INSTANCE_TYPE</td>
            </tr>
            <tr>
                <td>Region</td>
                <td>$REGION</td>
            </tr>
            <tr>
                <td>Availability Zone</td>
                <td>$AZ</td>
            </tr>
            <tr>
                <td>Public IPv4</td>
                <td>$PUBLIC_IP</td>
            </tr>
        </table>
        <p class=\"timestamp\">Last updated: $UPDATE_TIME</p>
    </div>
</body>
</html>" > /var/www/html/index.html