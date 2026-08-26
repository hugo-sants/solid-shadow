# Solid Shadow

Personal Fedora GNOME dotfiles focused on desktop customization, shell configuration, development tools, themes, and GNOME extension settings.
## Theme


| | |
|---|---|
| ![Desktop 01](asserts/screenshots/desktop/desktop-01.png) | ![Desktop 02](asserts/screenshots/desktop/desktop-02.png) |
| ![Desktop 03](asserts/screenshots/desktop/desktop-03.png) | ![Desktop 04](asserts/screenshots/desktop/desktop-04.png) |
| ![Desktop 05](asserts/screenshots/desktop/desktop-05.png) | ![Desktop 06](asserts/screenshots/desktop/desktop-06.png) |

### Applications

| | |
|---|---|
| ![Application 01](asserts/screenshots/application/application-01.png) | ![Application 02](asserts/screenshots/application/application-02.png) |
| ![Application 03](asserts/screenshots/application/application-03.png) | ![Application 04](asserts/screenshots/application/application-04.png) |

### Extensions

| | |
|---|---|
| ![Extension 01](asserts/screenshots/extensions/extensions-01.png) | ![Extension 02](asserts/screenshots/extensions/extensions-02.png) |
| ![Extension 03](asserts/screenshots/extensions/extensions-03.png) | ![Extension 04](asserts/screenshots/extensions/extensions-04.png) |

## Documentation

- [Theme](theme/THEME.md)
- [GNOME Extensions](gnome/EXTENSIONS.md)
- [Wallpapers](wallpapers/WALLPAPERS.md)

> [!WARNING]
> **Experimental Project**
>
> This repository is experimental and intended for personal use. The included scripts may modify system and user configuration, install packages, alter GNOME settings, and change the desktop environment.
>
> Use these dotfiles at your own risk. **I take no responsibility for data loss, system damage, configuration issues, broken packages, or any other consequences resulting from the use of this repository.**
>
> Make sure you understand what each script does before executing it and keep a backup of any important data and configuration.

## Installation

The default installation creates a backup and applies the tracked GNOME extension settings:

```bash
make install
```

Create a manual backup:

```bash
make backup
```

Install the GNOME extensions:

```bash
make install-extensions
```

Apply the extension settings directly:

```bash
make dconf
```

Install the packages listed in `packages.txt`:

```bash
make packages
```

Install the Flatpak applications listed in `flatpak.txt`:

```bash
make flatpak
```


Run the uninstall routine:

```bash
make uninstall
```

> [!WARNING]
> It is recommended to end the session after any operation.