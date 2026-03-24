-----
title: Upgrading PostgreSQL 14 to 18 on macOS with Homebrew
blurb: A step-by-step walkthrough of the gotchas, errors, and solutions when jumping four major versions using a bash loop
published: true
published_date: 2026-03-02 18:00:00
tags: postgresql, homebrew, macos, database, upgrade, pg_upgrade, troubleshooting
-----

*A step-by-step walkthrough of the gotchas, errors, and solutions when jumping four major versions using a bash loop*

## The Mission

I recently needed to upgrade my local PostgreSQL installation from version 14 to 18 on macOS using Homebrew. Sounds simple, right? Just run `brew upgrade postgresql` and call it a day?

Not quite. PostgreSQL major version upgrades require migrating the actual data directory, and when you're jumping four versions at once, things get interesting. Here's how I navigated the maze of errors and got everything working.

## What I Learned the Hard Way

### You Can't Upgrade Directly Across Multiple Versions

PostgreSQL's `pg_upgrade` utility only supports **one major version at a time**. This means 14→18 isn't possible in one shot. You must chain the upgrades: ```14 → 15 → 16 → 17 → 18```


### Each Version Needs Its Own `pg_upgrade` Binary

Here's the counter-intuitive part: you must use the **target version's** `pg_upgrade` binary, not the source version's. So for 17→18, you use `/opt/homebrew/opt/postgresql@18/bin/pg_upgrade`, not the one from `@17`.

### Locale and Checksum Settings Must Match Exactly

Your old cluster's settings are locked in stone. If PostgreSQL 14 was initialized with `LC_COLLATE=C` and no data checksums, every subsequent version must use those exact same flags. Miss this, and `pg_upgrade` will bail with cryptic errors.

## The Complete Upgrade Process

### Step 1: Install All Intermediate Versions

```bash
brew install postgresql@15 postgresql@16 postgresql@17 postgresql@18
```

### Step 2: Stop the current server

```
brew services stop postgresql@14
```

### Step 3: Run the Automated Upgrade Loop

```bash
#!/bin/bash
set -e

# Upgrade chain: 14 → 15 → 16 → 17 → 18
for old in 14 15 16 17; do
  new=$((old + 1))
  echo "=========================================="
  echo "Upgrading PostgreSQL $old → $new"
  echo "=========================================="
  
  # Remove any existing new version data directory
  rm -rf $(brew --prefix)/var/postgresql@${new}
  
  # Initialize new version with C locale and no data checksums
  # (These flags must match your original PostgreSQL 14 cluster)
  $(brew --prefix)/opt/postgresql@${new}/bin/initdb \
    -D $(brew --prefix)/var/postgresql@${new} \
    --locale=C \
    --no-data-checksums \
    -E UTF8
  
  # Run pg_upgrade using the TARGET version's binary
  $(brew --prefix)/opt/postgresql@${new}/bin/pg_upgrade \
    -b $(brew --prefix)/opt/postgresql@${old}/bin \
    -B $(brew --prefix)/opt/postgresql@${new}/bin \
    -d $(brew --prefix)/var/postgresql@${old} \
    -D $(brew --prefix)/var/postgresql@${new}
    
  echo "✓ Completed $old → $new"
  echo ""
done

echo "=========================================="
echo "All upgrades complete!"
echo "=========================================="
```

We just have to save this as upgrade_postgres.sh, make it executable, and run it:

```bash
chmod +x upgrade_postgres.sh
./upgrade_postgres.sh
```

### The Errors I Hit (And How to Fix Them)

Error 1: "lc_collate values for database 'template1' do not match: old 'C', new 'en_US.UTF-8'"
Cause: The new cluster was initialized with a different locale than the old one.
Fix: Always use --locale=C (or whatever your original cluster used) when running initdb. Check your old cluster's locale with:

```bash
$(brew --prefix)/opt/postgresql@14/bin/psql -c "SHOW lc_collate;"
```

Error 2: "old cluster does not use data checksums but the new one does"
Cause: Newer PostgreSQL versions enable data checksums by default, but my old cluster didn't have them.
Fix: Add --no-data-checksums to the initdb command to match the old cluster's configuration.

PostgreSQL 18 is now running smoothly on my machine. The four-version jump was worth it for the new features and performance improvements.

Catch you on the next one.
