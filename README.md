# p_ox_inventory_addon

An in-house magazine inventory addon for [ox_inventory](https://github.com/overextended/ox_inventory) for FiveM, developed by PineappleHead.

## Features
- Magazine item management and metadata
- Client-side magazine attachment, packing, and usage
- Server-side magazine metadata handling
- Keybinds for reloading and magazine actions

## Requirements
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_lib](https://github.com/overextended/ox_lib)

## Installation
1. Clone or download this repository into your server's resources folder.
2. Ensure `ox_inventory` and `ox_lib` are installed and started before this resource.
3. Add `ensure p_ox_inventory_addon` to your server.cfg after ox_inventory and ox_lib.

## Configuration
- Look at the data folder and add the Magazine Item to your ox_inventory item.lua
- Then update your shops with the ammunation example, to have multiple different types of magazines. 
- Update your weapons, and set the ammoname to the magType you declared in shops.

## Usage
- Magazines are managed via ox_inventory and can be attached, packed, and used with weapons.
- Keybind: Press `R` to reload or interact with magazines (customizable in code).
- Magazine durability and ammo are tracked and updated automatically.

## File Structure
```
fxmanifest.lua         # Resource manifest
magazine/
  client.lua           # Client-side logic (magazine handling, keybinds)
  server.lua           # Server-side logic (magazine updates)
  config/
    data/
      magazine.lua     # Magazine item definitions/config
README.md              # This file
```

## Credits
- ARPCity Dev Team
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_lib](https://github.com/overextended/ox_lib)

## License

Copyright (c) ARPCity. This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See the LICENSE file for details.
