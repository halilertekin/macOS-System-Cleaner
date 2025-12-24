#!/usr/bin/env bash

# macOS System Cleaner Kurulum Scripti

set -e  # Hatalarda çık

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Renksiz

# Renkli çıktı fonksiyonları
print_status() {
    echo -e "${BLUE}[BİLGİ]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[BAŞARILI]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[UYARI]${NC} $1"
}

print_error() {
    echo -e "${RED}[HATA]${NC} $1"
}

# Yardım menüsü
show_help() {
    echo "macOS System Cleaner Kurulum Scripti"
    echo "Script'leri kurar ve gerekli ayarlamaları yapar"
    echo
    echo "Kullanım: $0 [seçenek]"
    echo
    echo "Seçenekler:"
    echo "  --bash-alias    Bash alias kurulumu yapar"
    echo "  --zsh-alias     Zsh alias kurulumu yapar"
    echo "  --npm-install   npm ile global kurulum yapar (npm gerekli)"
    echo "  --help          Bu yardım menüsünü gösterir"
    echo
    echo "Not: Script'ler zaten çalıştırma iznine sahip olarak gelmektedir."
}

# Bash alias kurulumu
install_bash_alias() {
    print_status "Bash alias kurulumu yapılıyor..."

    # Bashrc dosyasını kontrol et
    BASHRC_FILE="$HOME/.bashrc"
    if [ ! -f "$BASHRC_FILE" ]; then
        BASHRC_FILE="$HOME/.bash_profile"
        if [ ! -f "$BASHRC_FILE" ]; then
            print_error "Ne .bashrc ne de .bash_profile dosyası bulunamadı."
            return 1
        fi
    fi

    # Alias zaten var mı kontrol et
    if grep -q "alias msc=" "$BASHRC_FILE"; then
        print_warning "msc alias zaten mevcut, güncelleniyor..."
        sed -i.bak '/alias msc=/d' "$BASHRC_FILE"
    fi

    # Script dizinini bul
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Yeni alias ekle
    echo "alias msc='$SCRIPT_DIR/main_cleaner.sh'" >> "$BASHRC_FILE"

    # Ek kısayollar
    echo "alias msc-analyze='$SCRIPT_DIR/main_cleaner.sh analyze'" >> "$BASHRC_FILE"
    echo "alias msc-cache='$SCRIPT_DIR/scripts/cache_cleaner.sh clean'" >> "$BASHRC_FILE"
    echo "alias msc-ram='$SCRIPT_DIR/scripts/ram_cleaner.sh clear'" >> "$BASHRC_FILE"
    echo "alias msc-ide='$SCRIPT_DIR/scripts/ide_cleaner.sh all'" >> "$BASHRC_FILE"

    print_success "Bash alias'ları kuruldu. Yeni terminal oturumunda aktif olacak."
    print_status "Eğer hemen kullanmak istiyorsanız: source $BASHRC_FILE"
}

# Zsh alias kurulumu
install_zsh_alias() {
    print_status "Zsh alias kurulumu yapılıyor..."

    # Zshrc dosyasını kontrol et
    ZSHRC_FILE="$HOME/.zshrc"
    if [ ! -f "$ZSHRC_FILE" ]; then
        print_error ".zshrc dosyası bulunamadı."
        return 1
    fi

    # Alias zaten var mı kontrol et
    if grep -q "alias msc=" "$ZSHRC_FILE"; then
        print_warning "msc alias zaten mevcut, güncelleniyor..."
        sed -i.bak '/alias msc=/d' "$ZSHRC_FILE"
    fi

    # Script dizinini bul
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Yeni alias ekle
    echo "alias msc='$SCRIPT_DIR/main_cleaner.sh'" >> "$ZSHRC_FILE"

    # Ek kısayollar
    echo "alias msc-analyze='$SCRIPT_DIR/main_cleaner.sh analyze'" >> "$ZSHRC_FILE"
    echo "alias msc-cache='$SCRIPT_DIR/scripts/cache_cleaner.sh clean'" >> "$ZSHRC_FILE"
    echo "alias msc-ram='$SCRIPT_DIR/scripts/ram_cleaner.sh clear'" >> "$ZSHRC_FILE"
    echo "alias msc-ide='$SCRIPT_DIR/scripts/ide_cleaner.sh all'" >> "$ZSHRC_FILE"

    print_success "Zsh alias'ları kuruldu. Yeni terminal oturumunda aktif olacak."
    print_status "Eğer hemen kullanmak istiyorsanız: source $ZSHRC_FILE"
}

# Npm kurulumu
install_npm() {
    print_status "npm ile global kurulum yapılıyor..."
    
    # npm yüklü mü kontrol et
    if ! command -v npm &> /dev/null; then
        print_error "npm bulunamadı. npm yüklü olduğundan emin olun."
        return 1
    fi
    
    # Proje dizinine git
    PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$PROJECT_DIR"
    
    # npm paketini global olarak yükle
    npm install -g .
    
    print_success "npm ile global kurulum tamamlandı. Artık 'msc' komutunu doğrudan kullanabilirsiniz."
}

# Ana fonksiyon
main() {
    case "${1:-help}" in
        "--bash-alias")
            install_bash_alias
            ;;
        "--zsh-alias")
            install_zsh_alias
            ;;
        "--npm-install")
            install_npm
            ;;
        "--help"|"-h"|*)
            show_help
            ;;
    esac
}

# Ana fonksiyonu çalıştır
main "$@"