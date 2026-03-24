#!/bin/bash
# Auto-Sync: Watches for file changes and pushes to GitHub automatically
# Usage: ./auto-sync.sh (to start) | ./auto-sync.sh stop (to stop)

PROJECT_DIR="/Users/user/Desktop/BUSSINES/Antigraity/DRAGONS DELIVERY"
PIDFILE="/tmp/dragons-delivery-autosync.pid"
COOLDOWN=10  # seconds to wait after a change before pushing (batches rapid edits)

# --- Stop command ---
if [ "$1" = "stop" ]; then
    if [ -f "$PIDFILE" ]; then
        kill $(cat "$PIDFILE") 2>/dev/null
        rm -f "$PIDFILE"
        echo "✅ Auto-sync stopped."
    else
        echo "⚠️  Auto-sync is not running."
    fi
    exit 0
fi

# --- Check if already running ---
if [ -f "$PIDFILE" ] && kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    echo "⚠️  Auto-sync is already running (PID: $(cat $PIDFILE))"
    echo "   Run './auto-sync.sh stop' to stop it."
    exit 1
fi

echo "🚀 Dragons Delivery Auto-Sync Started!"
echo "   Watching: $PROJECT_DIR"
echo "   Pushing to: origin/main"
echo "   Cooldown: ${COOLDOWN}s (batches rapid edits)"
echo ""
echo "   Press Ctrl+C or run './auto-sync.sh stop' to stop."
echo ""

# --- Main sync function ---
do_sync() {
    cd "$PROJECT_DIR"
    
    # Check if there are changes
    if [ -n "$(git status --porcelain)" ]; then
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        echo "📦 [$TIMESTAMP] Changes detected, syncing..."
        
        git add -A
        git commit -m "auto-sync: $TIMESTAMP" --quiet
        
        if git push origin main --quiet 2>&1; then
            echo "✅ [$TIMESTAMP] Pushed to GitHub successfully!"
        else
            echo "❌ [$TIMESTAMP] Push failed. Will retry on next change."
        fi
    fi
}

# --- Save PID ---
echo $$ > "$PIDFILE"

# --- Cleanup on exit ---
trap 'rm -f "$PIDFILE"; echo ""; echo "👋 Auto-sync stopped."; exit 0' INT TERM

# --- Watch for changes ---
fswatch -o \
    --exclude '\.git' \
    --exclude '\.DS_Store' \
    --exclude 'node_modules' \
    --exclude '\.npm-cache' \
    --latency "$COOLDOWN" \
    "$PROJECT_DIR" | while read -r count; do
        do_sync
    done
