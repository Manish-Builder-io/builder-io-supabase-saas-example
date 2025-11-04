#!/bin/bash
# Helper script to switch between local and cloud Supabase

set -e

ENV_FILE=".env"
LOCAL_URL="postgresql://postgres:postgres@127.0.0.1:54322/postgres"

case "$1" in
  local)
    echo "🔧 Switching to LOCAL Supabase..."
    
    # Check if Docker is running
    if ! docker info > /dev/null 2>&1; then
      echo "❌ Docker is not running. Please start Docker Desktop first."
      exit 1
    fi
    
    # Check if Supabase is running
    if ! npx supabase status > /dev/null 2>&1; then
      echo "🚀 Starting local Supabase..."
      npx supabase start
    else
      echo "✅ Local Supabase is already running"
    fi
    
    # Update .env file
    if [ -f "$ENV_FILE" ]; then
      # Backup current .env
      cp "$ENV_FILE" "$ENV_FILE.backup"
      
      # Update POSTGRES_URL
      if grep -q "^POSTGRES_URL=" "$ENV_FILE"; then
        sed -i.bak "s|^POSTGRES_URL=.*|POSTGRES_URL=$LOCAL_URL|" "$ENV_FILE"
        rm -f "$ENV_FILE.bak"
      else
        echo "POSTGRES_URL=$LOCAL_URL" >> "$ENV_FILE"
      fi
      
      echo "✅ Updated .env file to use LOCAL Supabase"
      echo "📍 Database URL: $LOCAL_URL"
    else
      echo "⚠️  .env file not found. Creating new one..."
      echo "POSTGRES_URL=$LOCAL_URL" > "$ENV_FILE"
      echo "BASE_URL=http://localhost:3000" >> "$ENV_FILE"
      echo "AUTH_SECRET=$(openssl rand -base64 32)" >> "$ENV_FILE"
    fi
    
    echo ""
    echo "📊 Supabase Studio: http://127.0.0.1:54323"
    echo "🔗 API URL: http://127.0.0.1:54321"
    ;;
    
  cloud)
    echo "☁️  Switching to CLOUD Supabase..."
    echo "Please enter your cloud Supabase connection string:"
    read -r CLOUD_URL
    
    if [ -z "$CLOUD_URL" ]; then
      echo "❌ No connection string provided"
      exit 1
    fi
    
    if [ -f "$ENV_FILE" ]; then
      # Backup current .env
      cp "$ENV_FILE" "$ENV_FILE.backup"
      
      # Update POSTGRES_URL
      if grep -q "^POSTGRES_URL=" "$ENV_FILE"; then
        sed -i.bak "s|^POSTGRES_URL=.*|POSTGRES_URL=$CLOUD_URL|" "$ENV_FILE"
        rm -f "$ENV_FILE.bak"
      else
        echo "POSTGRES_URL=$CLOUD_URL" >> "$ENV_FILE"
      fi
      
      echo "✅ Updated .env file to use CLOUD Supabase"
    else
      echo "⚠️  .env file not found. Creating new one..."
      echo "POSTGRES_URL=$CLOUD_URL" > "$ENV_FILE"
      echo "BASE_URL=http://localhost:3000" >> "$ENV_FILE"
      echo "AUTH_SECRET=$(openssl rand -base64 32)" >> "$ENV_FILE"
    fi
    
    echo "⚠️  Make sure to stop local Supabase if running: pnpm supabase:stop"
    ;;
    
  status)
    echo "📊 Supabase Status:"
    echo ""
    npx supabase status 2>/dev/null || echo "❌ Supabase not running locally"
    echo ""
    if [ -f "$ENV_FILE" ]; then
      echo "📝 Current .env POSTGRES_URL:"
      grep "^POSTGRES_URL=" "$ENV_FILE" | sed 's/POSTGRES_URL=.*@/POSTGRES_URL=****@/'
    fi
    ;;
    
  *)
    echo "Usage: $0 {local|cloud|status}"
    echo ""
    echo "Commands:"
    echo "  local   - Switch to local Supabase (starts if needed)"
    echo "  cloud   - Switch to cloud Supabase (prompts for connection string)"
    echo "  status  - Show current Supabase status"
    exit 1
    ;;
esac

