# Neorg GTD <--> Things3

## Summary

This is an extension of Neorg module `neorg.gtd.base` that uses your Things3 application to display your tasks in neovim !

## Showcase

<details>
<summary>Today's tasks</summary>

  <img width="419" alt="Capture d’écran 2022-01-06 à 10 40 35" src="https://user-images.githubusercontent.com/5306901/148362520-d4b1885d-e799-4b09-98d1-5901290e0266.png">

  <img width="500" alt="Capture d’écran 2022-01-06 à 10 40 20" src="https://user-images.githubusercontent.com/5306901/148362496-bac54a2e-6249-4821-98d7-b4df0274752f.png">
</details>

<details>
<summary>Projects</summary>

  <img width="170" alt="Capture d’écran 2022-01-06 à 10 42 15" src="https://user-images.githubusercontent.com/5306901/148362737-ca1eff72-4178-448f-9c64-3ff23ad47f46.png">
  <img width="350" alt="image" src="https://user-images.githubusercontent.com/5306901/148362858-1f54a055-2cef-494f-8507-8efc18228cb9.png">
</details>

And much more ...

## Installation

Prerequisite: you need [things-cli](https://github.com/thingsapi/things-cli#install) to be installed.

```lua
-- packer installation
use {'danymat/neorg-gtd-things'}

-- neorg configuration
require('neorg').setup {
  load = {
    ...
    ["external.integrations.neorg-gtd-things"] = {
        config = { -- Mandatory
            things_db_path = "/Users/danielmathiot/Library/Group Containers/JLMPQHK86H.com.culturedcode.ThingsMac.beta/Things Database.thingsdatabase/main.sqlite", -- To find the correct location, go to FAQ
            waiting_for_tag = "En attente" -- The Things3 tag you use for waiting fors
        }
    }
  },
}
```

## FAQ

- How can i find my `things_db_path` ?

It is located inside your user's Library. I recommend you try out this command:

```bash
find /Users/your_name/Library -name main.sqlite 2>/dev/null | grep -v Backups
```

This command will find all main.sqlite files inside your library, and remove all results with `Backups` inside, as we want the original database

