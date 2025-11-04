# Supabase Setup Guide

## Your Supabase Project Details

- **Project URL**: https://cdltkdwvxqeuhviwfevi.supabase.co
- **Project Reference**: `cdltkdwvxqeuhviwfevi`

## Step 1: Get Your Database Connection String

1. Go to your Supabase Dashboard: https://supabase.com/dashboard/project/cdltkdwvxqeuhviwfevi
2. Navigate to **Project Settings** (gear icon) → **Database**
3. Scroll down to the **Connection string** section
4. Under **URI**, you'll see a connection string like:
   ```
   postgresql://postgres:[YOUR-PASSWORD]@db.cdltkdwvxqeuhviwfevi.supabase.co:5432/postgres
   ```
5. Replace `[YOUR-PASSWORD]` with your actual database password
   - If you don't remember your password, you can reset it in the same Database settings page

### Alternative: Connection Pooling (Recommended for Production)

For better performance, especially in production, use the **Connection pooling** string:
- Under **Connection pooling**, copy the connection string
- This is especially useful for serverless environments

## Step 2: Create Your .env File

1. Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and replace `[YOUR-PASSWORD]` with your actual database password:
   ```env
   POSTGRES_URL=postgresql://postgres:your-actual-password@db.cdltkdwvxqeuhviwfevi.supabase.co:5432/postgres
   ```

3. Generate an AUTH_SECRET:
   ```bash
   openssl rand -base64 32
   ```
   Then add it to your `.env` file:
   ```env
   AUTH_SECRET=the-generated-secret-here
   ```

4. Your `.env` file should look like:
   ```env
   POSTGRES_URL=postgresql://postgres:your-password@db.cdltkdwvxqeuhviwfevi.supabase.co:5432/postgres
   BASE_URL=http://localhost:3000
   AUTH_SECRET=your-generated-secret
   ```

## Step 3: Run Migrations and Seed

After setting up your `.env` file:

```bash
# Run database migrations to create tables
pnpm db:migrate

# Seed the database with initial data
pnpm db:seed
```

This will create:
- All necessary database tables
- A test user: `test@test.com` / `admin123`

## Step 4: Start Development Server

```bash
pnpm dev
```

## Troubleshooting

### If you don't know your database password:
1. Go to Supabase Dashboard → Project Settings → Database
2. Click **Reset database password**
3. Set a new password
4. Update your `.env` file with the new password

### Connection Issues:
- Make sure your `.env` file is in the root directory
- Verify the connection string format is correct
- Check that your Supabase project is active (not paused)

