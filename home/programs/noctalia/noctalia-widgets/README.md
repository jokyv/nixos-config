# Noctilia Clock Widget

A simple, elegant digital clock widget for Noctilia desktop with date display.

## Features

- Real-time clock with hours, minutes, seconds
- Localized date display with weekday
- Smooth scaling support (drag to resize)
- Automatic theme adaptation (light/dark mode)
- Optimized performance during scaling
- Clean, minimal design

## Installation

1. Copy the entire `noctilia-widgets` folder to your Noctilia plugins directory:
   ```bash
   # Typically located at:
   ~/.local/share/noctilia/plugins/
   # or
   ~/.config/noctilia/plugins/
   ```

2. Restart Noctilia or reload plugins from Settings → Plugins

3. Add the widget to your desktop:
   - Open Settings panel
   - Navigate to Desktop Widgets
   - Find "Clock Widget" in the picker
   - Enable edit mode to position and resize
   - Exit edit mode

## Files

- `manifest.json` - Plugin metadata
- `clock.qml` - Widget implementation

## Customization

You can modify the widget by editing `clock.qml`:

- Change initial size: adjust `implicitWidth` and `implicitHeight`
- Font sizes: modify `Style.fontSizeXL` and `Style.fontSizeM` multipliers
- Colors: the widget automatically uses `Color.text` and `Color.textSecondary`
- Format: edit `formatTime()` and `formatDate()` functions

## Requirements

- Noctilia 1.0.0+
- QtQuick modules (qs.Commons, qs.Modules.DesktopWidgets, qs.Widgets)
