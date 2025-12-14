# Testing Fnott Configuration

## Test Commands

### Test different urgency levels
```bash
# Low urgency notification (5 second timeout)
notify-send -u low "Low Priority" "This notification will disappear after 5 seconds"

# Normal urgency notification (10 second timeout)
notify-send -u normal "Normal Priority" "This notification will disappear after 10 seconds"

# Critical urgency notification (30 second timeout)
notify-send -u critical "Critical Priority" "This notification will stay for 30 seconds"

# Test with icon
notify-send -u normal "Icon Test" "This should show with an icon" --icon=dialog-information

# Test URL (using action - requires compatible daemon)
notify-send "URL Test" "Visit GitHub" -A "open=Open URL" -h "string:desktop-entry:firefox" -h "string:url:https://github.com"
# Note: URL clicking depends on applications sending proper notification actions
# Most applications need to include URL metadata in their notifications

# Test application-specific timeout (spotify example)
notify-send -u normal "Song Change" "Now playing: Test Song" --app-name=spotify
```

### Monitor Output Configuration
To force notifications to appear on a specific monitor:
1. Uncomment and edit the `output = "DP-1"` line in `/home/jokyv/nixos-config/home/programs/fnott.nix`
2. Replace "DP-1" with your desired output (use `swaymsg -t get_outputs` to list available outputs)
3. Rebuild configuration with `home-manager switch --flake .#jokyv`

### Click Actions
- Left click: Dismiss the clicked notification
- Right click: Should dismiss all notifications (if script is properly bound)

### Apply Changes
```bash
# Apply home-manager changes
home-manager switch --flake .#jokyv

# Restart fnott if needed
systemctl --user restart fnott
```