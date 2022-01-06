# Neorg GTD <--> Things3

## Summary

This is an extension of Neorg module `neorg.gtd.base` that uses your Things3 application to display your tasks in neovim !

## Showcase

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

