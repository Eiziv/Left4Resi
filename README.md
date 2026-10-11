# Left4Resi

A World of Warcraft addon that tells your party which dungeons you still need to time for a Resilient Keystone level.

```
/lr 18
```

posts to party chat:

```
Left for Resilient 18 (3/8):
Altar of Fangs (+16)
Kings' Rest
The Blinding Vale (+17)
```

`(3/8)` is how many dungeons of the season pool are left, and `(+16)` is your best timed key in that dungeon this season. A dungeon without a number has not been timed at all.

## Usage

| Command | What it does |
| --- | --- |
| `/lr 18` | Lists the dungeons you have not timed at 18 or higher. |
| `/lr` | Uses your next Resilient level: your lowest timed level + 1, and at least 12. |

`/left4resi` works as a longer alias.

The list goes to party chat. When you are not in a group it is shown only to you, which also works as a preview. The game blocks addons from sending chat during a key or a boss fight, so there it is shown only to you as well.

## Install

Put the folder in your AddOns directory and name it `Left4Resi`:

```
World of Warcraft/_retail_/Interface/AddOns/Left4Resi
```

For example with git:

```
git clone https://github.com/Eiziv/Left4Resi.git
```

## Good to know

- It reads the current character's season bests, so keys timed on other characters are not counted.
- The dungeon list comes from the game, so it follows the pool into new seasons without an update.
- Retail only.
