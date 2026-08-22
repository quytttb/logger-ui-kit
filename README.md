# logger-ui-kit

Shared **Material 3** QML UI kit for the Logger apps: **central_logger** (desktop) and **data-logger** (edge/kiosk). Consumed as a **git submodule** and built as **static QML modules**.

## Modules

| URI | Contents |
|-----|----------|
| `LoggerKit.Theme` | `ThemeMode`, `AppColors`, `AppTheme`, `AppTypography`, `QuickControlsConfig` singletons + `ThemeSetup` (C++ `QQuickStyle::setStyle("Material")`) |
| `LoggerKit.Components` | `AppButton`, `UiIcon`, `MaterialIcons`, `ElevatedPane`, `EmptyStatePlaceholder`, `TableContentStack`, `AppScrollBar`, `AppNotifier`, `AppToastHost`, `MessageDetailDialog`, `DateField`, `DatePickerPopup`, `AppTableView`, `TableHeaderCell`, `TableCellBackground`, `ChartGraphsTheme`, `ChartGraphsView`, `ChartLinePointMarker`, `StatusChip`, and the `ClipboardService` C++ singleton |

## Decoupling (no app dependency)

The kit never imports an app's `Core` module. Host-specific state is injected:

- **Theme mode / touch sizing** — `ThemeMode.mode` (`"light"`/`"dark"`) and `ThemeMode.touch` (bool). Bind at startup:
  ```qml
  ThemeMode.mode  = Qt.binding(() => SettingsController.theme)
  ThemeMode.touch = true   // kiosk / finger targets (≥48dp)
  ```
- **Clipboard** — `ClipboardService.copyToClipboard()` / `fileBaseName()` (QClipboard, no app hook).
- **Notifier context** — `AppNotifier`/`MessageDetailDialog` pass an opaque `contextId` (e.g. a logger id) back to the host; hosts that don't need it ignore `-1`.
- **StatusChip** — generic: indicator mode (`label` + dot) or status mode (host feeds `chipText` + fill/border/text colors + optional `statusIconName`). Domain logic (operational status, attach-DI type) stays in the host.
- **Charts timezone** — `ChartGraphsView.timezoneId` (IANA id) set by the host.

## Integration (host CMake)

```cmake
set(LOGGERKIT_QML_MODULE_VERSION ${YOUR_QML_MODULE_VERSION})
add_subdirectory(shared/logger-ui-kit)
# link: LoggerKit::theme_setup + the generated *plugin targets, import LoggerKit.* in QML
```

Requires `find_package(Qt6 6.11 COMPONENTS Quick QuickControls2 Qml Gui Graphs)` beforehand.

## Standalone build (lint / iteration)

```bash
cmake -B build -DCMAKE_PREFIX_PATH=$HOME/Qt/6.11.1/gcc_64 -DCMAKE_CXX_COMPILER=g++-15
cmake --build build --target qmllint
```

## Tests (standalone)

```bash
cmake -B build -DCMAKE_PREFIX_PATH=$HOME/Qt/6.11.1/gcc_64
cmake --build build
ctest --test-dir build --output-on-failure   # Qt Quick Test smoke suite
```

## License

MIT — see [LICENSE](LICENSE).
