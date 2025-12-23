#!/bin/bash

# RAM Temizleyici Script
# macOS sistemlerde RAM temizliği yapar ve sistem performansını artırır

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

# RAM durumunu göster
show_ram_status() {
    print_status "RAM Durumu:"
    
    # Toplam, kullanılabilir ve kullanılan RAM miktarını göster
    echo "$(system_profiler SPHardwareDataType | grep "Memory:" | head -1)"
    
    # Aktif bellek kullanımı
    memory_info=$(vm_stat)
    pages_free=$(echo "$memory_info" | grep "free" | awk '{ print $3 }' | sed 's/\.//')
    pages_inactive=$(echo "$memory_info" | grep "inactive" | awk '{ print $3 }' | sed 's/\.//')
    pages_speculative=$(echo "$memory_info" | grep "speculative" | awk '{ print $3 }' | sed 's/\.//')
    pages_active=$(echo "$memory_info" | grep "active" | awk '{ print $3 }' | sed 's/\.//')
    pages_wired=$(echo "$memory_info" | grep "wired" | awk '{ print $3 }' | sed 's/\.//')
    
    # Sayfa boyutu genellikle 4KB'dir
    page_size=4096
    free_memory=$((pages_free * page_size / 1024 / 1024))
    inactive_memory=$((pages_inactive * page_size / 1024 / 1024))
    speculative_memory=$((pages_speculative * page_size / 1024 / 1024))
    active_memory=$((pages_active * page_size / 1024 / 1024))
    wired_memory=$((pages_wired * page_size / 1024 / 1024))
    
    echo "Boş RAM: ${free_memory}MB"
    echo "Pasif RAM: ${inactive_memory}MB"
    echo "Spekülatif RAM: ${speculative_memory}MB"
    echo "Aktif RAM: ${active_memory}MB"
    echo "Sabitlenmiş RAM: ${wired_memory}MB"
    
    # Toplam fiziksel bellek
    total_memory=$(system_profiler SPHardwareDataType | grep "Memory:" | awk '{print $2$3}' | sed 's/GB/GB/' | sed 's/MB/MB/')
    echo "Toplam Fiziksel Bellek: $total_memory"
}

# Disk önbelleğini temizle
clear_disk_cache() {
    print_status "Disk önbelleği temizleniyor..."
    sudo purge
    print_success "Disk önbelleği temizlendi"
}

# RAM temizliği yap
clear_ram() {
    print_status "RAM temizliği yapılıyor..."
    
    # 1. Disk önbelleğini temizle
    clear_disk_cache
    
    # 2. Artalan süreçleri temizle
    print_status "Artalan süreçleri temizleniyor..."
    sudo periodic daily weekly monthly
    
    # 3. Önbelleği temizle
    print_status "Sistem önbelleği temizleniyor..."
    sudo sysctl -w vm.drop_caches=1 2>/dev/null || print_warning "vm.drop_caches komutu bu sistemde desteklenmiyor"
    
    print_success "RAM temizliği tamamlandı"
}

# Artalan süreçleri temizle
kill_background_processes() {
    print_warning "Bu işlem bazı arka plan süreçlerini sonlandırabilir."
    read -p "Devam etmek istiyor musunuz? (e/H): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ee]$ ]]; then
        print_status "Arka plan süreçleri temizleniyor..."
        
        # Kullanılmayan dosya tanımlayıcılarını kapat
        sudo lsof +L1
        
        # Artık kullanılmayan süreçleri sonlandır
        sudo pkill -f "coreduetd" 2>/dev/null || true
        sudo pkill -f "mds_stores" 2>/dev/null || true
        
        print_success "Arka plan süreçleri temizlendi"
    else
        print_warning "İşlem iptal edildi."
    fi
}

# Ana fonksiyon
main() {
    case "${1:-help}" in
        "status")
            show_ram_status
            ;;
        "clear")
            show_ram_status
            echo
            clear_ram
            echo
            show_ram_status
            ;;
        "deep")
            show_ram_status
            echo
            clear_ram
            kill_background_processes
            echo
            show_ram_status
            ;;
        "help"|*)
            echo "Kullanım: $0 [komut]"
            echo
            echo "Komutlar:"
            echo "  status  - RAM durumunu göster"
            echo "  clear   - RAM temizliği yap"
            echo "  deep    - RAM temizliği + arka plan süreçleri temizliği"
            echo "  help    - Bu yardım menüsünü göster"
            ;;
    esac
}

# Ana fonksiyonu çalıştır
main "$@"