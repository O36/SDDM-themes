# minimalO36

A minimal SDDM theme for Wayland compositors, designed for Hyprland but compatible with any SDDM setup.

## Preview

A clean dark login screen with a gradient pill input field. No clutter, no bloat.

- Single animated input field - username and password share one pill
- Gradient border (cyan → green)
- Animated feedback: pulsing cyan while authenticating, red flash on failure
- Optional backdrop image support
- DE/session selector
- Fully resolution-independent

## Dependencies

- SDDM (Qt6)
- `qt6-declarative` (usually installed with SDDM)

No AUR packages required.

## Installation

```bash
git clone https://github.com/O36/sddm-themes.git
sudo cp -r sddm-themes/minimalO36 /usr/share/sddm/themes/
```

Create or edit `/etc/sddm.conf.d/theme.conf`:

```ini
[Theme]
Current=minimalO36
```

## Optional Backdrop

Place a `backdrop.png` in the theme directory for a background image:

```bash
sudo cp your-wallpaper.png /usr/share/sddm/themes/minimalO36/backdrop.png
```

If absent, the theme falls back to a solid dark background (`#1e1b2e`).  
Recommended: match your screen resolution for best results.

## Customization

All colors are defined directly in `Main.qml`:

| Variable | Default | Description |
|---|---|---|
| Background | `#1e1b2e` | Backdrop solid color |
| Field background | `#2d2b42` | Input pill color |
| Text | `#e2e0ef` | Input text color |
| Border start | `#33ccff` | Gradient start (cyan) |
| Border end | `#00ff99` | Gradient end (green) |
| Fail color | `#ff0000` | Wrong password flash |
| Wait color | `#7dcfff` | Authenticating pulse |

## Behavior

- On load: username field is focused
- Type username → `Enter` to transition to password field
- Type password → `Enter` to authenticate
- `Escape` in password field: clear password, return to username field
- Session selector: click `<` / `>` to cycle available desktop sessions

## License

MIT
