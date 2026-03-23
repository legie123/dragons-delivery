---
description: How to deploy and manage the Dragons Delivery Cloud Run service
---

# Dragons Delivery — Deploy & Manage

## Project Details
- **Project:** `evident-trees-453923-f9`
- **Region:** `europe-west1`
- **Service:** `dragons-delivery`
- **Repo:** https://github.com/legie123/dragons-delivery
- **Live URL:** https://dragons-delivery-657910053930.europe-west1.run.app

## Deploy via CI/CD (recommended)

```bash
cd "/Users/user/Desktop/BUSSINES/Antigraity/DRAGONS DELIVERY"
git add .
git commit -m "describe your changes"
git push
```

Cloud Build will auto-build and deploy on push to `main`.

## Deploy Manually

```bash
cd "/Users/user/Desktop/BUSSINES/Antigraity/DRAGONS DELIVERY"
// turbo
gcloud run deploy dragons-delivery \
  --source . \
  --region europe-west1 \
  --allow-unauthenticated \
  --memory 128Mi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 3 \
  --cpu-throttling
```

## Check Status

```bash
// turbo
gcloud run services describe dragons-delivery --region=europe-west1 --format="yaml(status.url,status.conditions)"
```

## View Logs

```bash
// turbo
gcloud run services logs read dragons-delivery --region=europe-west1 --limit=20
```

## Test Headers

```bash
// turbo
curl -sI https://dragons-delivery-657910053930.europe-west1.run.app/
```

## Rollback

```bash
# List revisions
// turbo
gcloud run revisions list --service=dragons-delivery --region=europe-west1

# Rollback to a specific revision
gcloud run services update-traffic dragons-delivery \
  --region=europe-west1 \
  --to-revisions=REVISION_NAME=100
```

## System Cleanup (if RAM is high)

```bash
killall Safari 2>/dev/null
killall "Google Chrome" 2>/dev/null
rm -rf ~/.npm/_cacache/* 2>/dev/null
```
