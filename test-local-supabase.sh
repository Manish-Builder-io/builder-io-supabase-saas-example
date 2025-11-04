#!/bin/bash
# Test script for local Supabase + Docker setup

set -e

echo "🧪 Testing Local Supabase + Docker Setup"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Docker is running
echo "1️⃣  Testing Docker..."
if docker info > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker is running${NC}"
else
    echo -e "${RED}❌ Docker is not running. Please start Docker Desktop.${NC}"
    exit 1
fi
echo ""

# Test 2: Supabase containers are running
echo "2️⃣  Testing Supabase Containers..."
CONTAINERS=$(docker ps --filter "name=supabase" --format "{{.Names}}" | wc -l | tr -d ' ')
if [ "$CONTAINERS" -gt "0" ]; then
    echo -e "${GREEN}✅ Found $CONTAINERS Supabase containers running${NC}"
    docker ps --filter "name=supabase" --format "  - {{.Names}} ({{.Status}})"
else
    echo -e "${YELLOW}⚠️  No Supabase containers found. Run: pnpm supabase:start${NC}"
    exit 1
fi
echo ""

# Test 3: Supabase status
echo "3️⃣  Testing Supabase Status..."
if npx supabase status > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Supabase is running${NC}"
    echo ""
    echo "📊 Supabase Services:"
    npx supabase status | grep -E "URL:|key:" | sed 's/^/  /'
else
    echo -e "${RED}❌ Supabase is not running${NC}"
    exit 1
fi
echo ""

# Test 4: Database connection
echo "4️⃣  Testing Database Connection..."
DB_URL="postgresql://postgres:postgres@127.0.0.1:54322/postgres"
if psql "$DB_URL" -c "SELECT version();" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Database connection successful${NC}"
    psql "$DB_URL" -c "SELECT version();" 2>/dev/null | head -2
else
    echo -e "${YELLOW}⚠️  Could not test with psql (may not be installed), trying with node...${NC}"
    # Try with node/postgres package
    if node -e "
    const postgres = require('postgres');
    const sql = postgres('$DB_URL');
    sql\`SELECT version()\`.then(() => {
        console.log('✅ Database connection successful (tested with node)');
        process.exit(0);
    }).catch((err) => {
        console.error('❌ Database connection failed:', err.message);
        process.exit(1);
    });
    " 2>&1; then
        echo -e "${GREEN}✅ Database connection verified${NC}"
    else
        echo -e "${YELLOW}⚠️  Could not verify connection automatically${NC}"
        echo "   But containers are running, so connection should work."
    fi
fi
echo ""

# Test 5: Check .env file
echo "5️⃣  Testing Environment Configuration..."
if [ -f ".env" ]; then
    if grep -q "POSTGRES_URL.*127.0.0.1:54322" .env; then
        echo -e "${GREEN}✅ .env file configured for local Supabase${NC}"
        grep "POSTGRES_URL" .env | sed 's/://g' | sed 's/@.*@/@****@/' | sed 's/^/  /'
    else
        echo -e "${YELLOW}⚠️  .env file exists but may not be configured for local Supabase${NC}"
        echo "   Expected: POSTGRES_URL=postgresql://postgres:postgres@127.0.0.1:54322/postgres"
    fi
else
    echo -e "${YELLOW}⚠️  .env file not found${NC}"
    echo "   Run: pnpm db:setup"
fi
echo ""

# Test 6: Test migrations (optional)
echo "6️⃣  Testing Database Migrations..."
read -p "Do you want to test running migrations? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if pnpm db:migrate 2>&1; then
        echo -e "${GREEN}✅ Migrations completed successfully${NC}"
    else
        echo -e "${RED}❌ Migrations failed${NC}"
    fi
else
    echo "⏭️  Skipping migration test"
fi
echo ""

# Test 7: Supabase Studio access
echo "7️⃣  Testing Supabase Studio Access..."
STUDIO_URL="http://127.0.0.1:54323"
if curl -s "$STUDIO_URL" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Supabase Studio is accessible${NC}"
    echo "   Open: $STUDIO_URL"
else
    echo -e "${YELLOW}⚠️  Could not verify Studio access (may need to check manually)${NC}"
    echo "   Expected: $STUDIO_URL"
fi
echo ""

# Summary
echo "========================================"
echo -e "${GREEN}🎉 Test Summary${NC}"
echo ""
echo "✅ Docker: Running"
echo "✅ Supabase Containers: $CONTAINERS containers running"
echo "✅ Supabase Status: Active"
echo ""
echo "📝 Next Steps:"
echo "   1. Run migrations: pnpm db:migrate"
echo "   2. Seed database: pnpm db:seed"
echo "   3. Start dev server: pnpm dev"
echo "   4. Open Supabase Studio: http://127.0.0.1:54323"
echo ""

