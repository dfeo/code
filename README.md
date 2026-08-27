# Code

![screenshot](https://raw.githubusercontent.com/dfeo/code/master/docs/screenshot.png)

A minimalist, distraction-free code editor. Fork of [Lite XL](https://github.com/lite-xl/lite-xl) with a Left-style (Hundred Rabbits) interface — monochrome typography, paper-like background, no internal chrome.

Designed for developers who want to focus on code, not on the editor.

## What is Code

Code is a fork of [Lite XL v2.1.7](https://github.com/lite-xl/lite-xl) that ships with a distraction-free, paper-like look and feel inspired by [Left](https://github.com/hundredrabbits/Left), plus a few quality-of-life tweaks.

## Design choices

- **Borderless window** — no native macOS title bar; the title bar is drawn by the editor itself
- **Custom traffic-light buttons** — round `●` glyphs in the Left palette (red `#a8493b`, green `#4f7d52`, amber `#a87b3a`); the close/maximize/minimize glyphs (−, +, ×) appear in white on hover, just like macOS
- **Native macOS rounded corners** — `NSWindow setCornerRadius:` via the Objective-C runtime
- **No internal dividers** — borders around tabs and between sidebar/editor are removed
- **Fira Code** (default, configurable in `data/core/style.lua`) — modern, OFL-licensed, with ligatures
- **Pure grayscale syntax highlighting** (`data/colors/left-mono.lua`, default) — keywords bold black, function names bold, strings italic gray, comments light gray italic. No color, pure typographic distinction.
- **Soft wrap on, no minimap, no status bar** — by default
- **Sidebar auto-shown** — folder tree opens on launch
- **Drag-onto-Dock support** — `NSApplicationDelegate` buffers URLs and opens them as projects

## Bundled plugins

Bundled at build time via `scripts/fetch-plugins.sh` (which calls `lpm`):

| Plugin | Purpose |
|---|---|
| `bracketmatch` | Highlights matching `()`, `{}`, `[]` |
| `language_php` | PHP syntax |
| `language_psql` | PostgreSQL SQL syntax |
| `language_json` | JSON syntax |
| `language_yaml` | YAML syntax |
| `language_ts` | TypeScript syntax |
| `language_tsx` | TSX / React syntax |
| `language_dart` | Dart syntax |
| `language_sh` | Bash / shell syntax |

To add or remove plugins, edit `data/plugins.txt` and run `./scripts/build.sh`.

## Quick Build

You need [Homebrew](https://brew.sh) and the following dependencies:

```sh
brew install sdl2 meson ninja pkg-config librsvg
```

Clone and build:

```sh
git clone https://github.com/dfeo/code.git
cd code
./scripts/build.sh --bundle --addons welcome
```

The resulting `.app` is at `build-aarch64-darwin/Code.app`. Copy it to your Applications folder:

```sh
cp -R build-aarch64-darwin/Code.app ~/Applications/
xattr -cr ~/Applications/Code.app
```

If you prefer installing it manually from a build directory, you can use:

```sh
DESTDIR="$(pwd)/Code.app" meson install --skip-subprojects -C build-aarch64-darwin
```

## Configuration

User configuration lives at `~/.config/code/init.lua`. The fork ships with sensible Left-style defaults, so you only need to override what you want to change.

Key bindings on macOS follow the standard conventions:

- `Cmd+S` save
- `Cmd+O` open file
- `Cmd+Shift+P` command palette
- `Cmd+F` find
- `Cmd+P` open file from project
- `Cmd+W` close tab
- `Cmd+T` new tab
- `Cmd+Q` quit

The full macOS keymap is in `data/core/keymap-macos.lua`.

## Customization

- **Theme**: edit `data/colors/left-mono.lua` (default) or create a new file and load it from `data/core/init.lua` with `local style = require "colors.<your-theme>"`.
- **Font**: change `data/core/style.lua` (look for `renderer.font.load(...)`).
- **Plugins**: edit `data/plugins.txt`, then rebuild.
- **Window behavior**: see `data/core/config.lua`.

## License

The source code inherits the MIT license from Lite XL. The bundled fonts retain their original licenses; see `licenses/licenses.md`.

Bundled binary `lpm.aarch64-darwin` is part of [lite-xl-plugin-manager](https://github.com/lite-xl/lite-xl-plugin-manager) (MIT).

## Credits

- [Lite XL](https://github.com/lite-xl/lite-xl) — the editor this fork is based on
- [Hundred Rabbits / Left](https://github.com/hundredrabbits/Left) — design inspiration
- [Fira Code](https://github.com/tonsky/FiraCode) — default font
- [Input Mono](https://input.djr.com/) — the font Left uses, bundled for reference