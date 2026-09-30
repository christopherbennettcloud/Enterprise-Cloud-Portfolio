#!/bin/bash
set -euo pipefail

# Install the temporary web service
dnf install -y nginx

# Create a simple application landing page
cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${project_name}</title>
</head>
<body>
  <h1>Enterprise Logistics Platform</h1>
  <p>Environment: ${environment}</p>
  <p>The application server is running successfully.</p>
</body>
</html>
EOF

# Listen on the application port expected by the load balancer
cat > /etc/nginx/conf.d/logistics.conf <<'EOF'
server {
    listen 8080;
    server_name _;

    root /usr/share/nginx/html;

    location = /health {
        access_log off;
        default_type text/plain;
        return 200 "healthy\n";
    }

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

# Start the service automatically
systemctl enable nginx
systemctl start nginx