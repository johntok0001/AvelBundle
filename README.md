# Avel Bundle

**Avel** is a free collection of eight mixing and mastering plugins with one shared look and one way of working. This bundle installs all of them at once on macOS and Windows.

### Download

| | |
|---|---|
| **macOS** — VST3 + Audio Unit, Apple Silicon & Intel | [Avel-Bundle-macOS.pkg](https://github.com/johntok0001/AvelBundle/releases/latest/download/Avel-Bundle-macOS.pkg) |
| **Windows** — VST3, 64-bit | [Avel-Bundle-Windows-Setup.exe](https://github.com/johntok0001/AvelBundle/releases/latest/download/Avel-Bundle-Windows-Setup.exe) |
| Both installers + user guide | [Avel-Bundle.zip](https://github.com/johntok0001/AvelBundle/releases/latest/download/Avel-Bundle.zip) |
| **User guide** (PDF) | [English](docs/Avel-User-Guide-EN.pdf) · [Русский](docs/Avel-User-Guide-RU.pdf) |

All releases: [Releases page](https://github.com/johntok0001/AvelBundle/releases)

## What's inside

| Plugin | Type | Best for |
|---|---|---|
| [Avel Tape](https://github.com/johntok0001/AvelTape.-Public) | Tape echo | Vintage repeats, dub throws, spring reverb |
| [Avel Time](https://github.com/johntok0001/AvelTime) | Stereo delay | Clean to creative delays with filters, pitch and modulation in the loop |
| [Avel Verb](https://github.com/johntok0001/AvelVerb) | Algorithmic reverb | Rooms, halls, plates and ambiences |
| [Avel EQ](https://github.com/johntok0001/AvelEQ) | Parametric equalizer | Surgical and musical EQ, dynamic EQ, matching a reference |
| [Avel Dynamic](https://github.com/johntok0001/AvelDynamic) | Compressor | Vocals, drums, buses, sidechain ducking |
| [Avel Ess](https://github.com/johntok0001/AvelEss) | De-esser | Taming harsh "s" sounds on vocals and bright sources |
| [Avel Ember](https://github.com/johntok0001/AvelEmber) | Multiband saturator | Warmth, drive and distortion per frequency band |
| [Avel Apex](https://github.com/johntok0001/AvelApex) | Mastering limiter | Final loudness and true-peak safety on the master |

The installers also put the user guide (English and Russian PDF) on your computer.

## Installation

### macOS

Requires macOS 10.13 or newer. Works on Apple Silicon and Intel Macs.

1. Download **Avel-Bundle-macOS.pkg** and double-click it.
2. Click **Continue**, then **Install**, and enter your password.
   To install only some plugins, click **Customize** on the *Installation Type* step and untick the ones you don't need.
3. Restart your DAW and rescan plugins. All plugins appear under the manufacturer name **Avel**.

Plugins are installed to `/Library/Audio/Plug-Ins/VST3` and `/Library/Audio/Plug-Ins/Components`.
The user guide is installed to `/Library/Application Support/Avel` (in Finder: **Go → Go to Folder…** and paste the path).

**If macOS says it cannot verify the developer:**
- **macOS 15 and newer:** open the file once and close the warning, then go to **System Settings → Privacy & Security** and click **Open Anyway**.
- **macOS 14 and older:** right-click the file → **Open** → **Open**.

### Windows

Requires 64-bit Windows 10 or 11.

1. Download **Avel-Bundle-Windows-Setup.exe** and run it.
2. Click **Next**. To install only some plugins, choose **Choose plugins** and untick the ones you don't need.
3. Click **Next**, then **Install**, then **Finish**.
4. Restart your DAW and rescan plugins. All plugins appear under the manufacturer name **Avel**.

Plugins are installed to `C:\Program Files\Common Files\VST3`.
The user guide is in the Start menu under **Avel**.

**If you see "Windows protected your PC":** click **More info → Run anyway**.

### Uninstalling

- **macOS:** delete the `Avel …` files from `/Library/Audio/Plug-Ins/VST3` and `/Library/Audio/Plug-Ins/Components`.
- **Windows:** **Settings → Apps → Installed apps → Avel Bundle → Uninstall**.

---

<details>
<summary><b>For maintainers</b> — how the bundle is built</summary>

This repository holds no plugin code. Each build takes the latest code from the plugin repositories listed in `plugins.json`, builds them on GitHub's macOS and Windows machines, packs them into the two installers, test-installs both and publishes them on the Releases page. The download links above always point to the newest build.

A build runs on every push to this repository, every night if any plugin repository has changed, and by hand: **Actions → Build Avel Bundle → Run workflow**.

- New plugin: add a line to `plugins.json`.
- New bundle version: change the number in `VERSION`.
- New user guide: replace the PDFs in `docs/`.

**Apple signing (optional).** Without it, macOS shows the "cannot verify the developer" warning above. With an Apple Developer account, add these in **Settings → Secrets and variables → Actions** and the next build is signed and notarized:

| Secret | Value |
|---|---|
| `MACOS_CERTS_P12` | *Developer ID Application* and *Developer ID Installer* certificates exported to one .p12, base64-encoded |
| `MACOS_CERTS_PASSWORD` | password of that .p12 |
| `APPLE_ID` | Apple ID e-mail |
| `APPLE_TEAM_ID` | Team ID from developer.apple.com |
| `APPLE_APP_PASSWORD` | app-specific password from appleid.apple.com |

</details>
