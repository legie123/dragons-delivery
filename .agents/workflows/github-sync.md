---
description: GitHub Bridge - Sincronizare automată Mac ↔ Remote PC prin GitHub
---

# GitHub Bridge Protocol 🔄

Sincronizăm automat proiectele între **Mac (local)** și **Remote PC (Windows)** folosind GitHub ca punte.

## Arhitectură

```
Mac (editezi) → auto-push (30s) → GitHub → auto-pull (2 min) → Windows Remote PC
```

## 1. Mac — Auto-Push

**Script**: `~/bin/dragons-autosync.sh` — verifică la 30s dacă sunt schimbări și face push automat.

### Comenzi:
```bash
# Pornire
nohup ~/bin/dragons-autosync.sh </dev/null >/dev/null 2>&1 &

# Oprire
~/bin/dragons-autosync.sh stop

# Status
~/bin/dragons-autosync.sh status

# Log-uri
tail -f /tmp/dragons-delivery-autosync.log
```

### Auto-start la login:
1. Deschide **System Settings → General → Login Items**
2. Click **+** și adaugă `~/bin/dragons-autosync-start.command`

## 2. Remote PC (Windows) — Auto-Pull

Pe Antigravity-ul de pe Windows, scrie:

> „Clonează repo-ul https://github.com/legie123/dragons-delivery.git în C:\ANDREI\DRAGONS-DELIVERY și setează un scheduled task care face git pull automat la fiecare 2 minute."

## GitHub Repo

- **URL**: https://github.com/legie123/dragons-delivery.git
- **Branch**: `main`

## Aplicabilitate

Acest protocol poate fi replicat pentru **orice proiect** între Mac și Remote PC:
1. Creează repo GitHub
2. Adaptează `dragons-autosync.sh` cu noul path
3. Pe Windows, clonează și setează auto-pull

## Troubleshooting

| Problemă | Soluție |
|---|---|
| Auto-sync nu rulează | `~/bin/dragons-autosync.sh status` |
| Push eșuează | `tail /tmp/dragons-delivery-autosync.log` |
| Conflicte git | Nu edita aceleași fișiere pe ambele mașini simultan |
