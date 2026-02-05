# AGENTS.md - GrinFit Project Guide

## Project Overview

GrinFit is a personal fitness and workout tracking blog built with Jekyll. It logs workouts, exercises, and fitness activities dating back to 2012. The site is hosted at https://fit.grin.io.

## Key Files

| Purpose | File(s) |
|---------|---------|
| CLI commands | `cli.rake` - all rake tasks for managing posts |
| Site config | `_config.yml` - Jekyll configuration |
| Development | `dev.sh` - local development server |
| Production server | `config.ru` - Rack configuration for Thin |
| Posts | `_posts/` - workout logs are stored here |
| Custom Liquid tags | `_plugins/` - especially `workout.rb` for the `{% w %}` tag |

## Quick Commands

Run `rake --tasks` to see all available commands. Key ones:

- `rake ls` - list recent posts
- `rake new TITLE` - create new post. ALWAYS START NEW POSTS WITH THIS.
- `rake edit [ID]` - edit a post
- `rake sl [a|b]` - create Stronglifts 5x5 workout post
- `rake tag ID tagname` - add tag to post
- `rake tags` - list all tags and their frequencies
- `rake push` - build, commit, push, and deploy

## Post Structure

Posts live in `_posts/` as markdown files with YAML frontmatter:

```yaml
---
_id_: '1234567890123456'
date: '2024-11-12 06:04:41'
tags:
- lifting
- stronglifts
title: Workout Title
---

Post content here...
```

The `{% w %}` Liquid tag formats workout notation (e.g., `{% w 5x5@145lb %}`).

## Dev & Deploying

```bash
./dev.sh          # Start local server with watch
rake push         # Publish site: build → commit → push → deploy
```

`rake push` commits to master and deploys the built `_site/` to the gh-pages branch.

Always use `rake push`. Never call the deploy.sh script directly.
