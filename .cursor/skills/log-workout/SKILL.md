---
name: log-workout
description: Log a new workout or fitness entry. Use when the user wants to record exercise, add a workout, or log fitness activities.
---

# Log a New Workout

## When to Use

- User wants to log a workout
- User wants to record exercise or fitness activities
- User mentions adding a new post about working out

## Instructions

1. **Create the post** using the rake task:
   ```bash
   noedit=1 rake new WORKOUT TITLE HERE
   ```
   This creates the post file with proper frontmatter (`_id_`, `date`, `title`) and prints the filename. The `noedit=1` flag prevents opening the editor so you can edit the file directly.

2. **Add content** to the post. Use ONE `{% w %}` Liquid tag per exercise line containing all the sets, reps, and weight together:
   ```
   - Squat: {% w 5x5@145lb %}      # 5 sets of 5 reps at 145lb
   - Pullups: {% w 3x8 %}          # 3 sets of 8 reps
   - Deadlift: {% w 1x5@205lb %}   # 1 set of 5 reps at 205lb
   - Turkish getups: {% w 3x35lb %} # 3 reps at 35lb
   - KB swings: {% w 35lb %}       # just weight
   ```
   
   Format: `SETSxREPS@WEIGHT` - omit parts as needed (e.g., `3x35lb` for reps x weight, `35lb` for just weight).

3. **Add tags** to categorize the workout:
   ```bash
   rake tag ID tagname1 tagname2
   ```
   Run `rake tags` to see existing tags and their frequencies.

## Stronglifts Shortcut

For Stronglifts 5x5 workouts specifically, use:
```bash
rake sl a   # Day A: Squat, Bench, Row
rake sl b   # Day B: Squat, Press, Deadlift
```

## Reference

- Posts are stored in `_posts/` as `YYYY-MM-DD-title-slug.md`
- See `cli.rake` for all rake task implementations
- See `_plugins/workout.rb` for the `{% w %}` tag
- Run `rake ls` to list recent posts
