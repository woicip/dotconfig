server { 
  listen 80; 
  listen [::]:80; 

  root /var/www/103.196.155.121/html; 
  index index.html index.htm index.nginx-debian.html; 

  server_name 103.196.155.121;

  location / { 
    try_files $uri $uri/ =404; 
  } 

  location /route-path-1/ { 
    proxy_set_header X-Real-IP $remote_addr; 
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
    proxy_set_header Host $host; 
    proxy_set_header X-NginX-Proxy true; 
    proxy_pass http://127.0.0.1:3000/; 
    proxy_redirect http://127.0.0.1:3000/ https://$server_name/; 
  } 

  location /route-path-2/ { 
    proxy_set_header X-Real-IP $remote_addr; 
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
    proxy_set_header Host $host; 
    proxy_set_header X-NginX-Proxy true; 
    proxy_pass http://127.0.0.1:3001/; 
    proxy_redirect http://127.0.0.1:3001/ https://$server_name/; 
  } 
}