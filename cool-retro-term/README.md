# cool-retro-term stow package

Links the Cool-Retro-Term settings database into
`~/.local/share/cool-retro-term/cool-retro-term/QML/OfflineStorage/Databases/`.

Cool-Retro-Term stores its configuration in a QML `LocalStorage` SQLite
database, not in a text file under `~/.config`. The database name is
`coolretroterm2`, which Qt maps to the file
`a55f2c6526126b3c7148ad10f51eef95.sqlite` (the name is the MD5 of the
database identifier, so it is stable across machines). The adjacent `.ini`
is the LocalStorage metadata file and is needed alongside the database.

## What is tracked

The `settings` table has three rows:

| Key                | Contents                                              |
|--------------------|-------------------------------------------------------|
| `_CURRENT_SETTINGS`| General settings: window scaling, font scaling, bloom/burn-in quality, menubar, custom command |
| `_CURRENT_PROFILE` | The active CRT look: colors, effects, font, frame, curvature |
| `_CUSTOM_PROFILES` | Saved profiles, including **Frameless Ghost Terminal** (the `#0b1014`/`#a6b3c0` JetBrains Mono look) and the other frameless presets |

The built-in profiles (Default Amber, Green Terminal, etc.) are compiled
into the application and do not need to be tracked.

## Updating

Because the file is stowed directly from this repo, changing settings in
Cool-Retro-Term and closing the window writes the updated database in
place. Commit the change as usual:

```bash
cool-retro-term               # change settings, then close the window
git add cool-retro-term
git commit -m "cool-retro-term: update settings"
```

`git diff` will report the database as a binary file. To inspect or edit
individual values as text:

```bash
sqlite3 ~/.local/share/cool-retro-term/cool-retro-term/QML/OfflineStorage/Databases/a55f2c6526126b3c7148ad10f51eef95.sqlite \
    'select setting, value from settings;'
```

To start from the application defaults without deleting the tracked file:

```bash
cool-retro-term --default-settings
```

Profiles can also be exported/imported as JSON from
**Settings → Profile → Export/Import** (the *Frameless Ghost Terminal*
profile was originally imported this way). Importing a JSON profile adds it
to the saved profiles list; it does not replace the active profile, which
is why the database is the tracked config.

## Install

```bash
./install.pl --package cool-retro-term
```

SQLite may create `-journal`, `-wal`, or `-shm` files next to the database;
these are transient and ignored by Git.
