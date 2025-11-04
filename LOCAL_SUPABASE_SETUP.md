# Local Supabase Development Setup

This guide shows you how to use Supabase locally with Docker instead of connecting to a cloud instance.

## Prerequisites

1. **Docker Desktop** must be installed and running
   - Check with: `docker --version` and `docker info`
   - Start Docker Desktop if it's not running

2. **Supabase CLI** is already installed (via `pnpm add -D supabase`)

## Quick Start

### 1. Start Local Supabase

```bash
pnpm supabase:start
```

This will:
- Download and start all Supabase services in Docker containers
- Take a few minutes the first time (downloading images)
- Create a local database on port `54322`

### 2. Get Connection String

After starting, you'll see output like:

```
Database URL: postgresql://postgres:postgres@127.0.0.1:54322/postgres
Studio URL: http://127.0.0.1:54323
```

The **Database URL** is what you need for your `.env` file.

### 3. Configure Your .env File

Update your `.env` file with the local Supabase connection:

```env
POSTGRES_URL=postgresql://postgres:postgres@127.0.0.1:54322/postgres
BASE_URL=http://localhost:3000
AUTH_SECRET=your-auth-secret-here
```

**Note:** The default password is `postgres` for local Supabase.

### 4. Run Migrations

```bash
pnpm db:migrate
```

This will apply your Drizzle migrations to the local database.

### 5. Seed the Database

```bash
pnpm db:seed
```

This creates the test user (`test@test.com` / `admin123`).

### 6. Start Your App

```bash
pnpm dev
```

## Useful Commands

```bash
# Start Supabase
pnpm supabase:start

# Check status
pnpm supabase:status

# Open Supabase Studio (database GUI)
pnpm supabase:studio

# Reset database (drops all data, runs migrations + seed)
pnpm supabase:reset

# Stop Supabase
pnpm supabase:stop
```

## Switching Between Local and Cloud

### Using Local Supabase

1. Make sure Docker is running
2. Run `pnpm supabase:start`
3. Update `.env`:
   ```env
   POSTGRES_URL=postgresql://postgres:postgres@127.0.0.1:54322/postgres
   ```

### Using Cloud Supabase

1. Run `pnpm supabase:stop` to stop local instance
2. Update `.env` with your cloud connection string:
   ```env
   POSTGRES_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
   ```

## Port Conflicts

If you see an error like:
```
Bind for 0.0.0.0:54322 failed: port is already allocated
```

This means another Postgres container is running. Stop it:

```bash
# Stop the old docker-compose Postgres
docker stop next_saas_starter_postgres

# Or stop all Postgres containers
docker ps | grep postgres
docker stop <container-id>
```

## Accessing Supabase Studio

Once Supabase is running, open:

**http://127.0.0.1:54323**

This gives you:
- Table Editor - View and edit your database tables
- SQL Editor - Run SQL queries
- API Documentation
- Authentication management
- Storage management

## Troubleshooting

### Docker Not Running

Error: `Cannot connect to the Docker daemon at unix:///var/run/docker.sock`

**Solution:**
- Start Docker Desktop
- Wait for it to fully start (whale icon should be stable in menu bar)
- Try again: `pnpm supabase:start`

### Port Already in Use

Error: `port is already allocated`

**Solution:**
```bash
# Find what's using the port
docker ps | grep 54322

# Stop the conflicting container
docker stop <container-name>

# Try starting Supabase again
pnpm supabase:start
```

### Reset Everything

If things get messy:

```bash
# Stop and remove all Supabase containers
pnpm supabase:stop
docker ps -a | grep supabase
docker rm <container-ids>

# Restart fresh
pnpm supabase:start
```

### Check Docker is Working

```bash
docker --version
docker info
docker ps
```

If any of these fail, Docker isn't running or accessible.

## Differences: Local vs Cloud

| Feature | Local | Cloud |
|---------|-------|-------|
| Database | Docker container | Supabase cloud |
| Port | 54322 | 5432 |
| Studio | http://127.0.0.1:54323 | Dashboard UI |
| Storage | Local Docker | Cloud storage |
| Auth | Local (no email sending) | Full auth with emails |
| API | http://127.0.0.1:54321 | Your project URL |

## Migration Workflow

When working locally:

1. Make schema changes in your code
2. Generate migration: `pnpm db:generate`
3. Test locally: `pnpm db:migrate`
4. When ready, apply to cloud: Update `.env` to cloud URL and run `pnpm db:migrate`

## Benefits of Local Development

✅ **Faster** - No network latency  
✅ **Free** - No usage limits  
✅ **Private** - Data never leaves your machine  
✅ **Offline** - Works without internet  
✅ **Safe** - Experiment without affecting production  
✅ **Fast Reset** - Quickly reset database for testing

