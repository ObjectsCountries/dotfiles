# Dotfiles, Mods, etc.

## Info

|Component|Using|Package|
|-|-|-|
|Icons|Papirus|`papirus-icon-theme`|
|Color of Folders|Papirus Folders script|`papirus-folders` (AUR)|
|`ls` replacement|`eza`|`eza`|
|`cat` replacement|`bat`|`bat`|
|`git diff` replacement|Delta|`git-delta`|
|Theme for just about everything|Cyberdream|Not on AUR, available as a Neovim package (scottmckendry/cyberdream.nvim)|

`eza` customization:
```
eza -l --color=always --icons=always --hyperlink -a --group-directories-first --git --total-size --no-user --no-time
```

Cyberdream for other apps available under their [extras](https://github.com/scottmckendry/cyberdream.nvim/tree/main/extras)

## Desktop

* Breeze Dark theme for everything except icons
* Dynamic Wallpaper: `plasma5-wallpapers-dynamic`
  * Use [Lakeside](Wallpaper/wallpaper.avif)
* Analog Clock in top left
* Wunderground in bottom left
* Digital Clock to the right of Analog Clock
  * 12-Hour for time, M/d/yyyy for date
* Media player in bottom right
* Battery above media player (align to right)

### Panel

* One panel at the top
* Darwin Menu (extension)
  * `endeavouros` icon
* Global Menu
* Panel Spacer
* Icons-Only Task Manager
  * Chrome, Discord, Steam
* Panel Spacer
* Wunderground (extension)
* System Tray
* Margins Separator
* Total CPU Use
* Memory Usage
* Margins Separator
* Digital Clock
  * M/d beside region defaults time
* Application Menu
  * application-menu icon

## Dotfiles

* [Fastfetch](Config%20Files/fastfetch)
* [Fish](Config%20Files/fish)
* [Hyfetch](Config%20Files/hyfetch.json)
* [Kitty](Config%20Files/kitty)
* [Neovim](Config%20Files/nvim)
* [Neovide](Config%20Files/neovide)
* [Starship](Config%20Files/starship.toml)

## Mods

### Minecraft

* [Craft Presence](https://www.curseforge.com/minecraft/mc-mods/craftpresence) (config [here](craftpresence_redacted.json), using Fabric)
  * Note: replace server IP, Client ID and Discord link manually
* [Vanilla Tweaks](https://vanillatweaks.net/share#YYdT9F) (zip [here](VanillaTweaks.zip))

### Guilty Gear Strive

* [Secretary of Trans Rights Goldlewis](https://gamebanana.com/mods/395711)
* [Purple UI](https://gamebanana.com/mods/330653)
* [Dark/Night Celestial Lobby](https://gamebanana.com/mods/429714)
* [SF6 Frame DATA viewer FIXED (SEASON 4)](https://gamebanana.com/mods/513406)

## Other

* [Lock Screen](sugar-candy)
* [Background](Wallpaper)
* Apps:
  * Discord
  * Steam (Download KTaNE and GGST)
  * Spotify
  * Octopi (updates and downloads for Arch-based distros)
  * PyCharm Professional Edition (for one of my college's CS classes)
  * Mission Center
  * Qalculate! (Qt)
  * Unity 2017.4.22f1 (for KTaNE modding)
