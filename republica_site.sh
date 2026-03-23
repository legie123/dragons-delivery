#!/bin/bash
# Script de re-publicare pe Surge.sh
# Rulează-l oricând site-urile dau "Unavailable"

echo "📤 Re-publicare Wolt..."
npx surge --project "/Users/user/Desktop/BUSSINES/Antigraity/DRAGONS DELIVERY/wolt-style" --domain wolt-recrutare-curieri.surge.sh

echo ""
echo "📤 Re-publicare Bolt Food..."
npx surge --project "/Users/user/Desktop/BUSSINES/Antigraity/DRAGONS DELIVERY/bolt-style" --domain bolt-recrutare-curieri.surge.sh

echo ""
echo "✅ GATA! Ambele site-uri sunt din nou live!"
echo "🔗 Wolt:  https://wolt-recrutare-curieri.surge.sh"
echo "🔗 Bolt:  https://bolt-recrutare-curieri.surge.sh"
