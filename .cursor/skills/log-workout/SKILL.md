---
name: log-workout
description: Log a workout or fitness entry. Use when the user wants to record exercise, add a workout, or log fitness activities.
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

2. **Add content** to the post. Wrap **all** workout numbers in `{% w %}` tags — not just sets/reps/weight combos, but also standalone rep counts:
   ```
   - Squat: {% w 5x5@145lb %}      # 5 sets of 5 reps at 145lb
   - Pullups: {% w 3x8 %}          # 3 sets of 8 reps
   - Deadlift: {% w 1x5@205lb %}   # 1 set of 5 reps at 205lb
   - Turkish getups: {% w 3x35lb %} # 3 reps at 35lb
   - KB swings: {% w 35lb %}       # just weight
   - {% w 8 %} ring pushups        # standalone rep count
   ```

   Format: `SETSxREPS@WEIGHT` - omit parts as needed (e.g., `3x35lb` for reps x weight, `35lb` for just weight, `8` for just reps).

   **Structuring workouts:**
   - When stating rounds at the top (e.g., "3 rounds superset:"), list only **per-round** reps for each exercise — don't repeat the round count on individual lines
   - Use "Then:" to separate distinct sections of a workout
   - Supersets: group exercises under a header like "3 rounds superset:"
   - Tabatas: format as "Xmin Tabata description"

   **Example post body:**
   ```
   3 rounds superset:

   - {% w 6@50lb %} rear leg elevated split squats
   - {% w 8 %} ring pushups
   - {% w 8 %} ring rows

   Then:

   - 3min Tabata alternating side Copenhagen plank
   ```

   **Whitespace:** Never leave trailing whitespace on blank lines. Empty lines should be truly empty (no spaces or tabs).

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
