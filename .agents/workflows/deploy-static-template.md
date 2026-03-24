---
description: Template global pentru deploy orice proiect static pe Cloud Run
---

# Deploy Static Site to Cloud Run (Template Global)

Acest workflow funcționează pentru ORICE proiect static (HTML/CSS/JS).

## Pre-requisites
- gcloud authenticated (`lemuriandeals@gmail.com`)
- Project: `evident-trees-453923-f9`
- Region: `europe-west1`

## 1. Creează fișierele necesare

### Dockerfile
```dockerfile
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY . /usr/share/nginx/html/
RUN rm -f /usr/share/nginx/html/Dockerfile \
          /usr/share/nginx/html/.dockerignore \
          /usr/share/nginx/html/.gcloudignore \
          /usr/share/nginx/html/cloudbuild.yaml \
          /usr/share/nginx/html/nginx.conf \
          /usr/share/nginx/html/.DS_Store
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
```

### nginx.conf (cu security headers)
```nginx
server {
    listen 8080;
    root /usr/share/nginx/html;
    index index.html;
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_types text/plain text/css application/javascript application/json image/svg+xml;
    gzip_min_length 256;
    location ~* \.(png|jpg|jpeg|gif|ico|svg|css|js|woff2?)$ {
        expires 7d;
        add_header Cache-Control "public, immutable";
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    }
    location / {
        add_header Cache-Control "public, max-age=300, must-revalidate";
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header Content-Security-Policy "default-src 'self'; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data:; script-src 'self' 'unsafe-inline';" always;
        try_files $uri $uri/ /index.html;
    }
}
```

### .dockerignore
```
.git
.DS_Store
.npm-cache
*.sh
Dockerfile
.dockerignore
```

### .gcloudignore
```
.DS_Store
.npm-cache/
*.sh
.git/
.gitignore
.gcloudignore
cloudbuild.yaml
```

### cloudbuild.yaml
```yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'europe-west1-docker.pkg.dev/$PROJECT_ID/cloud-run-source-deploy/SERVICE_NAME:$SHORT_SHA', '-t', 'europe-west1-docker.pkg.dev/$PROJECT_ID/cloud-run-source-deploy/SERVICE_NAME:latest', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', '--all-tags', 'europe-west1-docker.pkg.dev/$PROJECT_ID/cloud-run-source-deploy/SERVICE_NAME']
  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    args: ['gcloud', 'run', 'deploy', 'SERVICE_NAME', '--image', 'europe-west1-docker.pkg.dev/$PROJECT_ID/cloud-run-source-deploy/SERVICE_NAME:$SHORT_SHA', '--region', 'europe-west1', '--allow-unauthenticated', '--memory', '128Mi', '--cpu', '1', '--min-instances', '0', '--max-instances', '3', '--cpu-throttling']
images:
  - 'europe-west1-docker.pkg.dev/$PROJECT_ID/cloud-run-source-deploy/SERVICE_NAME'
options:
  logging: CLOUD_LOGGING_ONLY
```

## 2. Deploy

```bash
// turbo
gcloud run deploy SERVICE_NAME --source . --region europe-west1 --allow-unauthenticated --memory 128Mi --cpu 1 --max-instances 3 --cpu-throttling
```

## 3. Setup CI/CD

```bash
git init && git add . && git commit -m "initial"
gh repo create SERVICE_NAME --public --source . --push
```

Then connect Cloud Build trigger in Console.

## 4. Setup Monitoring

```bash
gcloud monitoring uptime create "SERVICE_NAME Uptime" \
  --resource-type=uptime-url \
  --resource-labels=host=SERVICE_NAME-657910053930.europe-west1.run.app,project_id=evident-trees-453923-f9 \
  --protocol=https --path="/" --period=5 \
  --project=evident-trees-453923-f9
```
