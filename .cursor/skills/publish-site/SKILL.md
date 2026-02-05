---
name: publish-site
description: Build and publish the site to production. Use when the user wants to deploy, publish, push to prod, or make the site live.
---

# Build and Publish to Production

## When to Use

- User wants to deploy the site
- User wants to publish changes
- User mentions pushing to prod or making changes live

## Instructions

Run the single command that does everything:

```bash
rake push
```

This command:
1. Builds the Jekyll site to `_site/`
2. Stages all changes with `git add -A`
3. Commits with message "new content"
4. Pushes to origin master
5. Deploys `_site/` to the gh-pages branch

## Important

- **Always use `rake push`** - never call `deploy.sh` directly
- The site is hosted at https://fit.grin.io

## Local Preview First

To preview changes before publishing:
```bash
./dev.sh
```
This runs Jekyll with watch mode at http://localhost:4000.

## Reference

- See `cli.rake` for the push task implementation
- See `deploy.sh` for deployment details
- See `_config.yml` for site configuration
