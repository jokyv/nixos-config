# Noctalia Configuration TODO

Compare: `home/programs/noctalia.nix` (current) vs `home/programs/noctali_sample.nix` (reference)

---

## 🔴 Critical — Missing core functionality

### 1. `notifications`
No notification system configured. No alerts, sounds, toasts, or history save rules.
- `enabled`, `enableMarkdown`, `density`, `monitors`, `location`
- `saveToHistory` (low/normal/critical)
- `sounds` (enabled, volume, separate files, excluded apps)
- `respectExpireTimeout`, urgency durations
- Battery & keyboard layout toast toggles

### 2. `osd`
No on-screen-display for volume/brightness changes.
- `enabled`, `location`, `autoHideMs`, `overlayLayer`
- `enabledTypes`, `monitors`, `backgroundOpacity`

### 3. `idle`
No screen-off, lock, or suspend timeouts configured.
- `enabled`, `screenOffTimeout`, `lockTimeout`, `suspendTimeout`
- `fadeDuration`, `screenOffCommand`, `lockCommand`, etc.

### 4. `appLauncher`
No clipboard history, search modes, or terminal integration.
- `enableClipboardHistory`, `autoPasteClipboard`, clipboard watch commands
- `terminalCommand`, `pinnedApps`, `sortByMostUsed`
- `enableSettingsSearch`, `enableWindowsSearch`, `enableSessionSearch`
- `position`, `density`, `viewMode`, `showCategories`, `iconMode`
- `screenshotAnnotationTool`

### 5. `location` (partial)
Only `name` and `monthBeforeDay` set. Missing weather, calendar events, first day of week.
- `weatherEnabled`, `weatherShowEffects`, `weatherTaliaMascotAlways`
- `showWeekNumberInCalendar`, `showCalendarEvents`, `showCalendarWeather`
- `analogClockInCalendar`, `firstDayOfWeek`, `autoLocate`
- `hideWeatherTimezone`, `hideWeatherCityName`, `useFahrenheit`, `use12hourFormat`

---

## 🟡 Important — Missing features with real impact

### 6. `controlCenter`
No card layout or shortcut panel configuration.
- `position`, `diskPath`
- `cards[]` (profile, shortcuts, audio, brightness, weather, media-sysmon)

### 7. `general` (large section missing)
Only `avatarImage`, `radiusRatio`, `scaleRatio` set.
- `enableShadows`, `enableBlurBehind`
- `shadowDirection`, `shadowOffsetX`, `shadowOffsetY`
- `animationSpeed`, `animationDisabled`
- `lockScreen*` (blur, tint, monitors, countdown, buttons, hibernate, media controls)
- `compactLockScreen`, `lockScreenAnimations`, `lockOnSuspend`
- `showChangelogOnStartup`, `telemetryEnabled`
- `clockStyle`, `clockFormat`, `passwordChars`
- `dimmerOpacity`, `showScreenCorners`, `forceBlackScreenCorners`
- `iRadiusRatio`, `boxRadiusRatio`, `screenRadiusRatio`
- `language`, `allowPanelsOnScreenWithoutBar`
- `autoStartAuth`, `allowPasswordWithFprintd`
- `keybinds` (Up/Down/Left/Right/Enter/Esc/Remove)
- `smoothScrollEnabled`, `reverseScroll`

### 8. `systemMonitor` (full section missing)
No thresholds or custom colors for monitoring.
- CPU, temp, GPU, mem, swap, disk, battery thresholds
- `enableDgpuMonitoring`, `useCustomColors`
- `warningColor`, `criticalColor`, `externalMonitor`

### 9. `network` (partial)
- `bluetoothRssiPollingEnabled`, `bluetoothRssiPollIntervalMs`
- `networkPanelView`, `wifiDetailsViewMode`, `bluetoothDetailsViewMode`
- `bluetoothHideUnnamedDevices`, `disableDiscoverability`, `bluetoothAutoConnect`

### 10. `desktopWidgets`
Clock widget may not appear in overview.
- `enabled`, `overviewEnabled`, `gridSnap`, `gridSnapScale`
- `monitorWidgets[]`

### 11. `sessionMenu` (partial)
Missing countdown, layout options.
- `enableCountdown`, `countdownDuration`
- `showHeader`, `showKeybinds`, `largeButtonsStyle`, `largeButtonsLayout`

---

## 🟢 Visual polish / QoL

### 12. `audio`
No volume step, visualizer config, or MPRIS player preference.
- `volumeStep`, `volumeOverdrive`, `volumeFeedback`
- `spectrumFrameRate`, `visualizerType`, `spectrumMirrored`
- `preferredPlayer`, `mprisBlacklist`

### 13. `brightness`
No step size or DDC external monitor support.
- `brightnessStep`, `enforceMinimum`, `enableDdcSupport`
- `backlightDeviceMappings`

### 14. `ui` (full section missing)
No font, tooltip, scrollbar, or panel transparency config.
- `fontDefault`, `fontFixed`, `fontDefaultScale`, `fontFixedScale`
- `tooltipsEnabled`, `scrollbarAlwaysVisible`, `boxBorderEnabled`
- `panelBackgroundOpacity`, `translucentWidgets`, `panelsAttachedToBar`
- `settingsPanelMode`, `settingsPanelSideBarCardStyle`

### 15. `hooks` (full section missing)
No scripts for wallpaper change, dark mode, lock events, startup.
- `enabled`, `wallpaperChange`, `darkModeChange`, `screenLock/Unlock`
- `performanceModeEnabled/Disabled`, `startup`, `session`, `colorGeneration`

### 16. `dock` (partial)
Missing dead opacity, sitting on frame, animation speed, indicator styling.
- `deadOpacity`, `sittingOnFrame`, `animationSpeed`

### 17. `noctaliaPerformance`
No performance mode toggle for disabling wallpaper/widgets under load.
- `disableWallpaper`, `disableDesktopWidgets`

---

## 🔵 Optional / Nice to have

### 18. `templates`
No active templates or user theming.
- `activeTemplates[]`, `enableUserTheming`

### 19. `plugins`
No auto-update or notification of plugin updates.
- `autoUpdate`, `notifyUpdates`

### 20. `colorSchemes` (partial)
Only `predefinedScheme` set. Missing wallpaper-based colors, dark mode scheduling.
- `useWallpaperColors`, `darkMode`, `schedulingMode`
- `manualSunrise`, `manualSunset`, `generationMethod`, `monitorForColors`, `syncGsettings`

### 21. `wallpaper` (partial)
Missing blur/tint for overview, transition effects, favorites, wallhaven.
- `transitionDuration`, `transitionType[]`, `transitionEdgeSmoothness`
- `overviewBlur`, `overviewTint`
- `panelPosition`, `hideWallpaperFilenames`, `useOriginalImages`
- `useSolidColor`, `solidColor`, `fillColor`
- `viewMode`, `setWallpaperOnAllMonitors`, `monitorDirectories[]`
- `enableMultiMonitorDirectories`, `showHiddenFiles`, `linkLightAndDarkWallpapers`
- Wallhaven integration fields
- `favorites[]`

### 22. `calendar` (full section missing)
No card configuration for the calendar panel.
- `cards[]` (calendar-header-card, calendar-month-card, weather-card)

### 23. `bar` (partial — settings already set, but missing many options)
- `showOutline`, `showCapsule` (set), `capsuleOpacity` (set), `capsuleColorKey`
- `contentPadding`, `frameThickness`, `frameRadius`, `outerCorners`
- `enableExclusionZoneInset`, `marginVertical`, `marginHorizontal`
- `displayMode`, `hideOnOverview`, `showOnWorkspaceSwitch`
- Mouse wheel actions, middle/right click actions
- `screenOverrides[]`

---

## Summary

| Priority | Count | Sections |
|---|---|---|
| 🔴 Critical | 5 | notifications, osd, idle, appLauncher, location |
| 🟡 Important | 6 | controlCenter, general, systemMonitor, network, desktopWidgets, sessionMenu |
| 🟢 Visual/QoL | 6 | audio, brightness, ui, hooks, dock, noctaliaPerformance |
| 🔵 Optional | 6 | templates, plugins, colorSchemes, wallpaper, calendar, bar |

**Total: 23 sections to review/add**
