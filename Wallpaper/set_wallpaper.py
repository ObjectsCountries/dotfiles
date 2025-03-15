#!/usr/bin/env python3

from datetime import datetime, timedelta, timezone
import re
import signal
import subprocess
import time

import psutil
from pysolar.solar import get_azimuth
import pywal

LATITUDE: float = 33.667764
LONGITUDE: float = -117.690818

wallpaper: int = -1
previous_wallpaper: int = -1

while True:
    date: datetime = datetime.now(timezone(-timedelta(hours=8)))
    azimuth: float = get_azimuth(LATITUDE, LONGITUDE, date)
    if 0 <= azimuth < 30:
        wallpaper = 2
    elif 30 <= azimuth < 60:
        wallpaper = 3
    elif 60 <= azimuth < 90:
        wallpaper = 4
    elif 90 <= azimuth < 120:
        wallpaper = 5
    elif 120 <= azimuth < 150:
        wallpaper = 6
    elif 150 <= azimuth < 180:
        wallpaper = 7
    elif 180 <= azimuth < 210:
        wallpaper = 8
    elif 210 <= azimuth < 240:
        wallpaper = 9
    elif 240 <= azimuth < 270:
        wallpaper = 10
    elif 270 <= azimuth < 300:
        wallpaper = 11
    elif 300 <= azimuth < 330:
        wallpaper = 12
    else:
        wallpaper = 1
    wallpaper_path = f"/home/kasra/Dotfiles/Wallpaper/dear-{wallpaper}.jpg"

    if previous_wallpaper != wallpaper:
        for p in psutil.process_iter(["name"]):
            if p.info["name"] in {"dunst", "waybar"}:
                p.send_signal(signal.SIGTERM)
        image = pywal.image.get(wallpaper_path)
        colors = pywal.colors.get(image)
        pywal.export.color(colors, "waybar", "/home/kasra/.config/waybar/colors.css")
        background_color = colors["colors"]["color1"]
        border_color = colors["colors"]["color2"]

        with open("/home/kasra/.config/hypr/hyprland.conf", "rt") as f:
            hyprland_conf = f.read()
        hyprland_conf = re.sub("col\\.active_border = rgba\\([A-Fa-f0-9]{6}ee\\)", f"col.active_border = rgba({background_color[1:].lower()}ee)", hyprland_conf)
        with open("/home/kasra/.config/hypr/hyprland.conf", "wt") as f:
            f.write(hyprland_conf)

        with open("/home/kasra/.config/dunst/dunstrc", "rt") as f:
            dunstrc = f.read()
        dunstrc = re.sub("window\\.\\n    frame_color = \"#[A-Fa-f0-9]{6}\"", f"window.\n    frame_color = \"{border_color}\"", dunstrc)
        dunstrc = re.sub("\\[urgency_normal]\\n    background = \"#[A-Fa-f0-9]{6}\"", f"[urgency_normal]\n    background = \"{background_color}\"", dunstrc)
        with open("/home/kasra/.config/dunst/dunstrc", "wt") as f:
            f.write(dunstrc)

        if "hyprpaper" not in (p.info["name"] for p in psutil.process_iter(["name"])):
            subprocess.Popen(["hyprpaper"])
            time.sleep(.5)

        subprocess.run(["hyprctl", "hyprpaper", "unload", "unused"])
        subprocess.run(["hyprctl", "hyprpaper", "preload", wallpaper_path])
        subprocess.run(["hyprctl", "hyprpaper", "wallpaper", ","+wallpaper_path])
        subprocess.Popen(["waybar"])
        subprocess.Popen(["dunst"])
    previous_wallpaper = wallpaper
    time.sleep(60)
