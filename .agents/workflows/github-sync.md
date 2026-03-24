---
description: GitHub Bridge - Sincronizare automată Mac ↔ Remote PC prin GitHub
---

# GitHub Bridge Protocol 🔄

Acest workflow descrie cum sincronizăm automat proiectele între **Mac (local)** și **Remote PC (Windows)** folosind GitHub ca punte.

## Arhitectură

```
Mac (editezi) → auto-push (10s) → GitHub → auto-pull (2 min) → Windows Remote PC
```

## Componente

### 1. Mac — Auto-Push (permanent activ)

- **Script**: `auto-sync.sh` — monitorizează schimbările cu `fswatch` și face push automat
- **LaunchAgent**: `com.dragons-delivery.autosync.plist` — pornește auto-sync la login, permanent
- **Cooldown**: 10 secunde (grupează editările rapide)

#### Comenzi utile Mac:
```bash
# Verifică dacă auto-sync rulează
launchctl list | grep dragons

# Oprire temporară
launchctl unload ~/Library/LaunchAgents/com.dragons-delivery.autosync.plist

# Repornire
launchctl load ~/Library/LaunchAgents/com.dragons-delivery.autosync.plist

# Vezi log-uri
tail -f /tmp/dragons-delivery-autosync.log
```

### 2. Remote PC (Windows) — Auto-Pull

Pe Antigravity-ul de pe Windows, scrie:

> „Clonează repo-ul https://github.com/legie123/dragons-delivery.git în C:\ANDREI\DRAGONS-DELIVERY și setează un Task Scheduler care face git pull automat la fiecare 2 minute pentru sincronizare continuă cu GitHub."

#### Script auto-pull Windows (referință):
```powershell
# auto-pull.ps1 — rulează la fiecare 2 minute via Task Scheduler
Set-Location "C:\ANDREI\DRAGONS-DELIVERY"
git pull origin main --quiet
```

## GitHub Repo

- **URL**: https://github.com/legie123/dragons-delivery.git
- **Branch**: `main`

## Aplicabilitate

Acest protocol poate fi replicat pentru **orice proiect** care trebuie sincronizat între Mac și Remote PC:

1. Creează un repo GitHub pentru proiect
2. Copiază și adaptează `auto-sync.sh` pentru noul proiect
3. Creează un LaunchAgent similar
4. Pe Windows, clonează repo-ul și setează auto-pull

## Troubleshooting

| Problemă | Soluție |
|---|---|
| Auto-sync nu pornește | `launchctl load ~/Library/LaunchAgents/com.dragons-delivery.autosync.plist` |
| Push eșuează | Verifică `tail /tmp/dragons-delivery-autosync-error.log` |
| Conflicte git | Nu edita fișiere pe ambele mașini simultan |
| Windows nu primește updates | Verifică Task Scheduler pe Windows |
