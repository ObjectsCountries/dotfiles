#!/usr/bin/env python3

from datetime import datetime, timedelta, timezone
import re
import signal
import subprocess
import time

import dotenv
import psutil
from pysolar.solar import get_azimuth
import pywal

config = dotenv.dotenv_values(".env")

wallpaper: int = -1
previous_wallpaper: int = -1

while True:
    date: datetime = datetime.now(timezone(-timedelta(hours=8)))
    azimuth: float = get_azimuth(float(config["LATITUDE"]), float(config["LONGITUDE"]), date)
    wallpaper = 1 + int((azimuth // 30) + 1) % 12
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
        dunstrc = re.sub("Loadbearing comment\\n    frame_color = \"#[A-Fa-f0-9]{6}\"", f"Loadbearing comment\n    frame_color = \"{border_color}\"", dunstrc)
        dunstrc = re.sub("\\[urgency_normal]\\n    background = \"#[A-Fa-f0-9]{6}\"", f"[urgency_normal]\n    background = \"{background_color}\"", dunstrc)
        with open("/home/kasra/.config/dunst/dunstrc", "wt") as f:
            f.write(dunstrc)

        if "hyprpaper" not in (p.info["name"] for p in psutil.process_iter(["name"])):
            subprocess.Popen(["hyprpaper"])
            time.sleep(.5)

        subprocess.run(["hyprctl", "hyprpaper", "preload", wallpaper_path])
        subprocess.run(["hyprctl", "hyprpaper", "wallpaper", ","+wallpaper_path])
        subprocess.run(["hyprctl", "hyprpaper", "unload", "unused"])
        subprocess.Popen(["waybar"])
        subprocess.Popen(["dunst"])
    previous_wallpaper = wallpaper
    time.sleep(60)
