# Quick Start Guide

## Local Supabase Development (Fastest Setup)

1. **Make sure Docker Desktop is running**

2. **Start Local Supabase**
   ```bash
   pnpm supabase:start
   ```
   Wait for it to finish (first time takes ~2-3 minutes to download images).

3. **Update .env file**
   ```env
   POSTGRES_URL=postgresql://postgres:postgres@127.0.0.1:54322/postgres
   BASE_URL=http://localhost:3000
   AUTH_SECRET=your-secret-here
   ```
   Generate AUTH_SECRET: `openssl rand -base64 32`

4. **Run migrations**
   ```bash
   pnpm db:migrate
   ```

5. **Seed database**
   ```bash
   pnpm db:seed
   ```

6. **Start development server**
   ```bash
   pnpm dev
   ```

7. **Access Supabase Studio**
   Open http://127.0.0.1:54323 in your browser

## Cloud Supabase

If you prefer using cloud Supabase:

1. **Run setup**
   ```bash
   pnpm db:setup
   ```
   Choose **(S)** for Cloud Supabase and enter your connection string.

2. **Run migrations and seed**
   ```bash
   pnpm db:migrate
   pnpm db:seed
   ```

## Useful Commands

```bash
# Local Supabase
pnpm supabase:start       # Start local Supabase
pnpm supabase:stop        # Stop local Supabase
pnpm supabase:status      # Check status
pnpm supabase:studio      # Open Supabase Studio

# Database
pnpm db:migrate           # Run migrations
pnpm db:seed              # Seed database
pnpm db:generate          # Generate new migration
pnpm db:studio            # Open Drizzle Studio

# Development
pnpm dev                  # Start Next.js dev server
```

## Troubleshooting

**Docker not running?**
- Start Docker Desktop
- Wait for it to fully start (whale icon stable)
- Try again: `pnpm supabase:start`

**Port conflict?**
- Stop existing containers: `docker stop next_saas_starter_postgres`
- Or change port in `supabase/config.toml`

**Need help?**
- See [LOCAL_SUPABASE_SETUP.md](./LOCAL_SUPABASE_SETUP.md) for detailed guide
- See [README.md](./README.md) for full documentation

