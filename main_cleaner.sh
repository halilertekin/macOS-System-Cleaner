#!/bin/bash

# macOS Sistem Temizleyici Ana Script
# Tüm temizlik script'lerini tek bir yerden yönetir

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

# Script dizinini belirle
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Yardım menüsü
show_help() {
    echo "macOS Sistem Temizleyici"
    echo "Tüm sistem temizlik işlemlerini tek bir komutla yapar"
    echo
    echo "Kullanım: $0 [komut]"
    echo
    echo "Komutlar:"
    echo "  full     - Tüm sistem temizliği (RAM + önbellekler + IDE)"
    echo "  cache    - Sadece önbellek temizliği"
    echo "  ram      - Sadece RAM temizliği"
    echo "  ide      - Sadece IDE temizliği"
    echo "  analyze  - Sadece analiz (temizleme yapmaz)"
    echo "  help     - Bu yardım menüsünü göster"
    echo
    echo "Not: Her komut için ayrı ayrı onay istenecektir."
}

# Önbellek analizi
analyze_caches() {
    print_status "Önbellek analizi yapılıyor..."
    "$PROJECT_ROOT/scripts/cache_cleaner.sh" analyze
}

# RAM analizi
analyze_ram() {
    print_status "RAM analizi yapılıyor..."
    "$PROJECT_ROOT/scripts/ram_cleaner.sh" status
}

# IDE analizi
analyze_ide() {
    print_status "IDE analizi yapılıyor..."
    "$PROJECT_ROOT/scripts/ide_cleaner.sh" find
}

# Tam temizlik
full_clean() {
    print_warning "Tam sistem temizliği başlatılıyor..."
    print_warning "Bu işlem tüm önbellekleri, RAM'i ve IDE önbelleklerini temizleyecektir."
    
    read -p "Devam etmek istiyor musunuz? (e/H): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ee]$ ]]; then
        print_warning "İşlem iptal edildi."
        return 0
    fi
    
    print_status "RAM temizliği yapılıyor..."
    "$PROJECT_ROOT/scripts/ram_cleaner.sh" clear
    
    echo
    print_status "Önbellek temizliği yapılıyor..."
    "$PROJECT_ROOT/scripts/cache_cleaner.sh" clean
    
    echo
    print_status "IDE temizliği yapılıyor..."
    "$PROJECT_ROOT/scripts/ide_cleaner.sh" all
}

# Ana fonksiyon
main() {
    case "${1:-help}" in
        "full")
            full_clean
            ;;
        "cache")
            print_status "Önbellek temizliği başlatılıyor..."
            "$PROJECT_ROOT/scripts/cache_cleaner.sh" clean
            ;;
        "ram")
            print_status "RAM temizliği başlatılıyor..."
            "$PROJECT_ROOT/scripts/ram_cleaner.sh" deep
            ;;
        "ide")
            print_status "IDE temizliği başlatılıyor..."
            "$PROJECT_ROOT/scripts/ide_cleaner.sh" all
            ;;
        "analyze")
            print_status "Sistem analizi başlatılıyor..."
            analyze_ram
            echo
            analyze_caches
            echo
            analyze_ide
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Ana fonksiyonu çalıştır
main "$@"