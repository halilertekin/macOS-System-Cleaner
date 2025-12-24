# macOS System Cleaner

A comprehensive collection of scripts to clean RAM, cache and IDEs for improved macOS system performance.

## 🚀 Features

- **RAM Cleaning**: Optimizes system memory and increases performance
- **Cache Cleaning**: Analyzes and cleans user and system caches
- **IDE Cleaning**: Manages caches for Xcode, Android Studio, IntelliJ IDEA, PyCharm and other JetBrains IDEs
- **Brew Integration**: Works integrated with Homebrew updates
- **User Friendly**: Colorful outputs and clear instructions
- **Safe Cleaning**: Doesn't touch critical system files

## 📦 Contents

The project includes the following scripts:

### Main Scripts

- **`cache_cleaner.sh`**: Analyzes and cleans user and system caches
- **`ram_cleaner.sh`**: Performs RAM cleaning and increases system performance
- **`ide_cleaner.sh`**: Analyzes and cleans caches for Xcode and other IDEs
- **`main_cleaner.sh`**: Performs all cleaning operations with a single command
- **`brew_update_with_cache.sh`**: Wrapper that performs automatic cache analysis after Brew updates

### cache_cleaner.sh

Features:
- Analyzes user caches
- Lists top 10 largest caches
- Checks npm, Yarn, Homebrew caches
- Shows temporary folder sizes
- Provides safe cleaning options

Commands:
```
./scripts/cache_cleaner.sh analyze    # Analyzes caches
./scripts/cache_cleaner.sh clean     # Cleans caches
./scripts/cache_cleaner.sh help      # Shows help menu
```

### ram_cleaner.sh

Features:
- Shows RAM status (free, active, inactive, wired memory)
- Cleans disk cache
- Cleans system cache
- Cleans background processes

Commands:
```
./scripts/ram_cleaner.sh status      # Shows RAM status
./scripts/ram_cleaner.sh clear       # Performs RAM cleaning
./scripts/ram_cleaner.sh deep        # Deep RAM cleaning (with background processes)
```

### ide_cleaner.sh

Features:
- Detects Xcode, Android Studio, IntelliJ IDEA, PyCharm and other JetBrains IDEs
- Shows IDE cache folder sizes
- Safely cleans IDE caches
- Xcode-specific cleaning operations (DerivedData, Archive, iOS simulator data)

Commands:
```
./scripts/ide_cleaner.sh find        # Finds IDE folders and shows sizes
./scripts/ide_cleaner.sh clean       # Cleans IDE caches
./scripts/ide_cleaner.sh xcode       # Xcode-specific cleaning operations
./scripts/ide_cleaner.sh all         # Cleans all IDEs and Xcode
```

### main_cleaner.sh

Features:
- Runs all cleaning scripts with a single command
- User-friendly menu system
- Individual approval system

Commands:
```
./main_cleaner.sh full               # Full system cleaning (RAM + caches + IDE)
./main_cleaner.sh cache              # Cache cleaning only
./main_cleaner.sh ram                # RAM cleaning only
./main_cleaner.sh ide                # IDE cleaning only
./main_cleaner.sh analyze            # Analysis only (no cleaning)
```

## 🛠️ Installation

### 1. Clone the Project

```bash
git clone https://github.com/username/macOS-System-Cleaner.git
cd macOS-System-Cleaner
```

### 2. Set Script Permissions

```bash
chmod +x scripts/*.sh
chmod +x main_cleaner.sh
```

### 3. Installation via npm (Global)

```bash
npm install -g @halilertekin/macos-system-cleaner
```

After this installation, you can directly use the `msc` command:

```bash
msc analyze      # Performs system analysis
msc full         # Performs full system cleaning
msc cache        # Cache cleaning only
msc ram          # RAM cleaning only
msc ide          # IDE cleaning only
```

### 4. Bash Alias Usage

Also, you can create an alias to use the scripts like terminal commands:

```bash
# Add to ~/.bashrc or ~/.zshrc file:
alias msc='/path/to/macOS-System-Cleaner/main_cleaner.sh'

# To apply changes:
source ~/.bashrc  # or source ~/.zshrc
```

Then you can directly use these commands:

```bash
msc analyze      # System analysis
msc full         # Full cleaning
msc cache        # Cache cleaning
msc ram          # RAM cleaning
msc ide          # IDE cleaning
```

Or use the convenience aliases that are installed with the install.sh script:

```bash
msc-analyze      # System analysis
msc-cache        # Cache cleaning
msc-ram          # RAM cleaning
msc-ide          # IDE cleaning
```

## 📖 Usage

### Cache Cleaning

```bash
# Analyze caches
./scripts/cache_cleaner.sh analyze

# Clean caches (confirmation required)
./scripts/cache_cleaner.sh clean

# Help menu
./scripts/cache_cleaner.sh help
```

### RAM Cleaning

```bash
# Show RAM status
./scripts/ram_cleaner.sh status

# Perform RAM cleaning
./scripts/ram_cleaner.sh clear

# Deep RAM cleaning (with background processes)
./scripts/ram_cleaner.sh deep
```

### IDE Cleaning

```bash
# Find IDE folders and show sizes
./scripts/ide_cleaner.sh find

# Clean IDE caches
./scripts/ide_cleaner.sh clean

# Xcode-specific cleaning operations
./scripts/ide_cleaner.sh xcode

# Clean all IDEs and Xcode
./scripts/ide_cleaner.sh all
```

### All Cleanings Together

```bash
# Full system cleaning (RAM + caches + IDE)
./main_cleaner.sh full

# Analysis only (no cleaning)
./main_cleaner.sh analyze
```

After full cleaning operations, you'll see a visual summary screen like:

```
 ┌─────────────────────────────────────────┐
 │            CLEANING SUMMARY             │
 ├─────────────────────────────────────────┤
 │ • RAM cleaning: ✓                      │
 │ • Cache cleaning: ✓                    │
 │ • IDE cleaning: ✓                      │
 │ • System stability: ✓                  │
 └─────────────────────────────────────────┘
```

### Brew Update Integration

```bash
# Brew update + automatic cache analysis
./scripts/brew_update_with_cache.sh
```

## 🧪 Tested IDEs

- **Xcode**: DerivedData, Archive, iOS simulator data
- **Android Studio**: All versions (4.2, 2020.3, 2021.2, 2022.3, 2023.1)
- **IntelliJ IDEA**: All versions
- **PyCharm**: All versions
- **JetBrains IDEs**: GoLand, WebStorm, CLion, PhpStorm, Rider, AppCode, DataGrip, RubyMine
- **Visual Studio Code**: Application data

## ⚠️ Warnings

### General Warnings
- Scripts are designed to increase system performance
- It's good practice to backup important data before cleaning operations
- After IDE cleaning, IDEs may need to be restarted
- Cleaning Xcode DerivedData and Archive folders may affect build times

### RAM Cleaning Warnings
- During RAM cleaning, running applications may slow down temporarily
- RAM cleaning is generally only necessary when memory usage is very high
- RAM cleaning is not recommended if system memory is very low

### IDE Cleaning Warnings
- Cleaning IDE caches may take longer on first startup
- Project indexes may need to be recreated
- Some settings may be reset with cache cleaning

## 🤝 Contributing

If you want to contribute, please submit a pull request. Contributions in the following areas are welcome:

- New IDE supports
- Performance improvements
- Bug fixes
- New features
- Documentation improvements

### Contributing Steps

1. Fork the project
2. Create a new branch (`git checkout -b feature/new-feature`)
3. Make your changes
4. Commit your changes (`git commit -m 'New feature: Description'`)
5. Push to your branch (`git push origin feature/new-feature`)
6. Create a new Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🐛 Issue Reporting

You can report bugs and suggestions in the GitHub Issues section.

## ⚠️ Disclaimer

These scripts are developed purely for system cleaning and performance improvement purposes. The developer is not responsible for any data loss, system instability or other possible issues that may occur while using the scripts. It's recommended to take system backups before using the scripts.

### Sensitive Data Content Disclaimer

This script collection:
- Does not contain any personal data
- Does not contain user passwords, API keys or other sensitive information
- Only performs operations on system cache and temporary files
- Does not access user data or private files

## 🔧 Homebrew Formula Otomatikleştirme

Bu proje, Homebrew formula dosyasındaki SHA256 hash değerlerini otomatik olarak güncellemek için bir script içerir:

```bash
# Yeni bir tag için SHA256 hash hesapla ve formula dosyasını güncelle
./update_formula_sha.sh --update v1.1.0

# GitHub'dan son tag'ı al ve güncelle
./update_formula_sha.sh --latest

# Sadece hesapla, güncelleme yapma (test modu)
./update_formula_sha.sh --dry-run v1.1.0

# Mevcut formula versiyonunu göster
./update_formula_sha.sh --show-current

# Yardım menüsü
./update_formula_sha.sh --help
```

Bu script, GitHub'da yeni bir tag oluşturulduğunda, ilgili tarball'ın SHA256 hash'ini hesaplar ve Homebrew formula dosyasını otomatik olarak günceller.

## 🙏 Acknowledgments

- To all open source communities that provide information about macOS system management
- To all users who provide testing and feedback