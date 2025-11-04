# Testing Local Supabase + Docker Setup

## Quick Test Commands

### 1. Check Docker is Running
```bash
docker info
```
✅ Should show Docker system information

### 2. Check Supabase Containers
```bash
docker ps | grep supabase
```
✅ Should show 12+ containers running

### 3. Check Supabase Status
```bash
pnpm supabase:status
```
✅ Should show all services running with URLs

### 4. Test Database Connection
```bash
# Using the connection string from supabase status
psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -c "SELECT version();"
```
✅ Should return PostgreSQL version

Or test with your app:
```bash
# Run migrations
pnpm db:migrate

# Seed database
pnpm db:seed
```
✅ Should complete without errors

### 5. Test Supabase Studio
Open in browser: http://127.0.0.1:54323
✅ Should open Supabase Studio interface

### 6. Run Complete Test Script
```bash
./test-local-supabase.sh
```
✅ Should pass all checks

## Manual Testing Checklist

- [ ] Docker Desktop is running
- [ ] Supabase containers are running (12+ containers)
- [ ] `pnpm supabase:status` shows all services
- [ ] `.env` file has local Supabase URL
- [ ] Database migrations run successfully
- [ ] Database seeding completes
- [ ] Supabase Studio is accessible
- [ ] Can query database via Studio or psql
- [ ] Next.js app can connect to database

## Common Issues & Solutions

### Issue: "Cannot connect to Docker daemon"
**Solution:**
- Start Docker Desktop
- Wait for it to fully start
- Verify: `docker info`

### Issue: "Port 54322 already allocated"
**Solution:**
```bash
# Stop conflicting container
docker stop next_saas_starter_postgres

# Or check what's using the port
docker ps | grep 54322
```

### Issue: "Supabase not running"
**Solution:**
```bash
# Start Supabase
pnpm supabase:start

# Wait for it to finish (first time takes 2-3 minutes)
# Then check status
pnpm supabase:status
```

### Issue: "Database connection failed"
**Solution:**
1. Verify Supabase is running: `pnpm supabase:status`
2. Check `.env` file has correct URL
3. Verify Docker containers are healthy: `docker ps`

## Verification Commands

### Check Container Health
```bash
docker ps --format "table {{.Names}}\t{{.Status}}" | grep supabase
```
All containers should show "(healthy)" status

### Test API Endpoint
```bash
curl http://127.0.0.1:54321/rest/v1/
```
Should return API response

### Test Database Tables
```bash
psql postgresql://postgres:postgres@127.0.0.1:54322/postgres -c "\dt"
```
Should list your tables after migrations

## Expected Test Results

✅ **Docker**: Running and accessible
✅ **Containers**: 12 Supabase containers healthy
✅ **Database**: Connected on port 54322
✅ **Studio**: Accessible on port 54323
✅ **API**: Accessible on port 54321
✅ **Migrations**: Apply successfully
✅ **Seeding**: Creates test data

## Integration Test

After all tests pass:

1. **Start your app:**
   ```bash
   pnpm dev
   ```

2. **Test authentication:**
   - Go to http://localhost:3000/sign-up
   - Create a test account
   - Verify it appears in Supabase Studio

3. **Verify in Supabase Studio:**
   - Open http://127.0.0.1:54323
   - Navigate to Table Editor
   - Check your `users` and `teams` tables
   - Verify data matches what you created

## Performance Test

Local Supabase should be very fast:
- Database queries: < 5ms
- API responses: < 10ms
- No network latency
- No rate limits

If you see slow performance, check:
- Docker resource allocation
- System resources (CPU/RAM)
- Container health status

