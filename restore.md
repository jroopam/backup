# For backing up:
cd ~
dconf dump / > file_name.dconf

# For restoring:
cd ~
dconf load / < file_name.dconf

# Google meet screen sharing issue
Have to change display server.
https://superuser.com/questions/1729457/google-meet-share-screen-black-after-upgrading-to-ubuntu-22-04-lts#:~:text=The%20solution%20is%20pretty%20simple,display%2C%20run%20the%20following%20command.&text=Uncomment%20the%20following%20line.&text=Step%203%3A%20Reboot%20the%20system,system%20to%20apply%20the%20changes.

# Installed Software:
* Plank

# Installed gnome extensions:
* ArcMenu
* Aylur's Widgets
* Bing Wallpaper
* Blur my shell
* Burn My windows
* Coverflow Alt-Tab
* Dash to Panel or Dash to Dock
* Gesture Improvements(Also install utility mentioned in extension homepage)
* GSConnect
* GTK Title Bar
* Media Controls
* Quick Settings Tweaker
* Rounded Window Corners
* Time++
* Tiling Assistant
* Unite (For terminal it seemed only to work with xorg display server for Ubuntu 22.10)
* Useless Gps
* User Themes

# Themes:
Vimix
Dracula
WhiteSur-Dark-solid-red
MonoTheme
Flat remix
Fluent
Graphite-Dark-Nord
Orchis

# Icons:
Reversal-Dark
Papirus

# Fonts:
*Monaco*
Gilroy(Similar to Google's font)
Fira
Cascadia
Comic Mono

# Settings(Gnome Tweaks)
Interface Text: 11
Document Text: 10
Rest all: 11
Scaling Factor 0.79

**Note**: Wayland may be better but neither the screen sharing works nor unite(at least for terminal)

**For Scaling**
- https://askubuntu.com/questions/955038/change-the-display-scaling-on-the-fly
- https://askubuntu.com/questions/875246/xrandr-scaling-and-mouse-issue/875291#875291
- https://askubuntu.com/questions/510457/how-do-i-get-the-value-of-display-scale-for-menu-and-title-bars-from-the-c
- https://askubuntu.com/questions/379123/can-i-zoom-out-windows-or-scale-the-whole-desktop
- https://askubuntu.com/questions/878376/why-is-xrandr-not-letting-me-scale-my-display
