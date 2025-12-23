#!/bin/bash

# IDE ve Xcode Önbellek Temizleyici Script
# macOS sistemlerde IDE ve Xcode önbelleklerini analiz ve temizler

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

# IDE klasörlerini bul
find_ides() {
    print_status "IDE klasörleri aranıyor..."
    
    # Android Studio klasörlerini bul
    android_studio_dirs=($(find ~/Library -name "*AndroidStudio*" -type d 2>/dev/null))
    if [ ${#android_studio_dirs[@]} -gt 0 ]; then
        echo "Bulunan Android Studio klasörleri:"
        for dir in "${android_studio_dirs[@]}"; do
            size=$(du -sh "$dir" 2>/dev/null | cut -f1)
            echo "  - $dir ($size)"
        done
    else
        echo "Android Studio klasörü bulunamadı"
    fi
    
    # IntelliJ IDEA klasörlerini bul
    intellij_dirs=($(find ~/Library -name "*IntelliJIdea*" -type d 2>/dev/null))
    if [ ${#intellij_dirs[@]} -gt 0 ]; then
        echo -e "\nBulunan IntelliJ IDEA klasörleri:"
        for dir in "${intellij_dirs[@]}"; do
            size=$(du -sh "$dir" 2>/dev/null | cut -f1)
            echo "  - $dir ($size)"
        done
    else
        echo -e "\nIntelliJ IDEA klasörü bulunamadı"
    fi
    
    # PyCharm klasörlerini bul
    pycharm_dirs=($(find ~/Library -name "*PyCharm*" -type d 2>/dev/null))
    if [ ${#pycharm_dirs[@]} -gt 0 ]; then
        echo -e "\nBulunan PyCharm klasörleri:"
        for dir in "${pycharm_dirs[@]}"; do
            size=$(du -sh "$dir" 2>/dev/null | cut -f1)
            echo "  - $dir ($size)"
        done
    else
        echo -e "\nPyCharm klasörü bulunamadı"
    fi
    
    # GoLand, WebStorm, CLion, PhpStorm, Rider klasörlerini bul
    jetbrains_dirs=($(find ~/Library -name "*GoLand*" -type d 2>/dev/null; find ~/Library -name "*WebStorm*" -type d 2>/dev/null; find ~/Library -name "*CLion*" -type d 2>/dev/null; find ~/Library -name "*PhpStorm*" -type d 2>/dev/null; find ~/Library -name "*Rider*" -type d 2>/dev/null; find ~/Library -name "*AppCode*" -type d 2>/dev/null; find ~/Library -name "*DataGrip*" -type d 2>/dev/null; find ~/Library -name "*RubyMine*" -type d 2>/dev/null))
    if [ ${#jetbrains_dirs[@]} -gt 0 ]; then
        echo -e "\nBulunan diğer JetBrains IDE'leri:"
        for dir in "${jetbrains_dirs[@]}"; do
            size=$(du -sh "$dir" 2>/dev/null | cut -f1)
            echo "  - $dir ($size)"
        done
    else
        echo -e "\nDiğer JetBrains IDE klasörleri bulunamadı"
    fi
    
    # Visual Studio Code klasörlerini bul
    vscode_cache_dirs=()
    if [ -d "~/Library/Application Support/Code" ]; then
        echo -e "\nVS Code klasörleri:"
        size=$(du -sh ~/Library/Application\ Support/Code 2>/dev/null | cut -f1)
        echo "  - ~/Library/Application Support/Code ($size)"
        vscode_cache_dirs+=("~/Library/Application Support/Code")
    fi
    
    # Xcode DerivedData klasörlerini bul
    xcode_derived_data=$(find ~/Library -name "DerivedData" -type d -path "*/Xcode/*" 2>/dev/null | head -1)
    if [ -n "$xcode_derived_data" ]; then
        echo -e "\nXcode DerivedData klasörü:"
        size=$(du -sh "$xcode_derived_data" 2>/dev/null | cut -f1)
        echo "  - $xcode_derived_data ($size)"
    else
        print_warning "Xcode DerivedData klasörü bulunamadı"
    fi
    
    # Xcode Archive klasörlerini bul
    xcode_archives=$(find ~/Library -name "Archives" -type d -path "*/Xcode/*" 2>/dev/null | head -1)
    if [ -n "$xcode_archives" ]; then
        echo -e "\nXcode Archive klasörü:"
        size=$(du -sh "$xcode_archives" 2>/dev/null | cut -f1)
        echo "  - $xcode_archives ($size)"
    else
        print_warning "Xcode Archive klasörü bulunamadı"
    fi
}

# IDE önbelleklerini temizle
clean_ides() {
    print_warning "Bu işlem IDE önbelleklerini silecektir. IDE'lerin yeniden başlatılması gerekebilir."
    read -p "Devam etmek istiyor musunuz? (e/H): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ee]$ ]]; then
        print_status "IDE önbellekleri temizleniyor..."
        
        # Android Studio klasörlerini temizle
        android_studio_dirs=($(find ~/Library -name "*AndroidStudio*" -type d 2>/dev/null))
        for dir in "${android_studio_dirs[@]}"; do
            if [ -d "$dir" ]; then
                size=$(du -sh "$dir" 2>/dev/null | cut -f1)
                print_status "Android Studio klasörü temizleniyor: $dir ($size)..."
                rm -rf "$dir"/*
                print_success "Android Studio klasörü temizlendi: $dir"
            fi
        done
        
        # IntelliJ IDEA klasörlerini temizle
        intellij_dirs=($(find ~/Library -name "*IntelliJIdea*" -type d 2>/dev/null))
        for dir in "${intellij_dirs[@]}"; do
            if [ -d "$dir" ]; then
                size=$(du -sh "$dir" 2>/dev/null | cut -f1)
                print_status "IntelliJ IDEA klasörü temizleniyor: $dir ($size)..."
                rm -rf "$dir"/*
                print_success "IntelliJ IDEA klasörü temizlendi: $dir"
            fi
        done
        
        # PyCharm klasörlerini temizle
        pycharm_dirs=($(find ~/Library -name "*PyCharm*" -type d 2>/dev/null))
        for dir in "${pycharm_dirs[@]}"; do
            if [ -d "$dir" ]; then
                size=$(du -sh "$dir" 2>/dev/null | cut -f1)
                print_status "PyCharm klasörü temizleniyor: $dir ($size)..."
                rm -rf "$dir"/*
                print_success "PyCharm klasörü temizlendi: $dir"
            fi
        done
        
        # Diğer JetBrains IDE'lerini temizle
        jetbrains_dirs=($(find ~/Library -name "*GoLand*" -type d 2>/dev/null; find ~/Library -name "*WebStorm*" -type d 2>/dev/null; find ~/Library -name "*CLion*" -type d 2>/dev/null; find ~/Library -name "*PhpStorm*" -type d 2>/dev/null; find ~/Library -name "*Rider*" -type d 2>/dev/null; find ~/Library -name "*AppCode*" -type d 2>/dev/null; find ~/Library -name "*DataGrip*" -type d 2>/dev/null; find ~/Library -name "*RubyMine*" -type d 2>/dev/null))
        for dir in "${jetbrains_dirs[@]}"; do
            if [ -d "$dir" ]; then
                size=$(du -sh "$dir" 2>/dev/null | cut -f1)
                print_status "JetBrains IDE klasörü temizleniyor: $dir ($size)..."
                rm -rf "$dir"/*
                print_success "JetBrains IDE klasörü temizlendi: $dir"
            fi
        done
        
        # VS Code klasörlerini temizle
        if [ -d "~/Library/Application Support/Code" ]; then
            size=$(du -sh ~/Library/Application\ Support/Code 2>/dev/null | cut -f1)
            print_status "VS Code klasörü temizleniyor: ~/Library/Application Support/Code ($size)..."
            rm -rf ~/Library/Application\ Support/Code/*
            print_success "VS Code klasörü temizlendi"
        fi
        
        # Xcode DerivedData klasörünü temizle
        xcode_derived_data=$(find ~/Library -name "DerivedData" -type d -path "*/Xcode/*" 2>/dev/null | head -1)
        if [ -n "$xcode_derived_data" ]; then
            size=$(du -sh "$xcode_derived_data" 2>/dev/null | cut -f1)
            print_status "Xcode DerivedData klasörü temizleniyor: $xcode_derived_data ($size)..."
            rm -rf "$xcode_derived_data"/*
            print_success "Xcode DerivedData klasörü temizlendi"
        fi
        
        # Xcode Archive klasörünü temizle
        xcode_archives=$(find ~/Library -name "Archives" -type d -path "*/Xcode/*" 2>/dev/null | head -1)
        if [ -n "$xcode_archives" ]; then
            size=$(du -sh "$xcode_archives" 2>/dev/null | cut -f1)
            print_status "Xcode Archive klasörü temizleniyor: $xcode_archives ($size)..."
            rm -rf "$xcode_archives"/*
            print_success "Xcode Archive klasörü temizlendi"
        fi
        
        print_success "Tüm IDE önbellekleri temizlendi"
    else
        print_warning "İşlem iptal edildi."
    fi
}

# Xcode özel temizlik işlemleri
clean_xcode_specific() {
    print_status "Xcode'a özel temizlik işlemleri yapılıyor..."
    
    # iOS cihaz yedekleri
    if [ -d "~/Library/Application Support/MobileSync/Backup" ]; then
        size=$(du -sh ~/Library/Application\ Support/MobileSync/Backup 2>/dev/null | cut -f1)
        print_warning "iOS cihaz yedekleri: ~/Library/Application Support/MobileSync/Backup ($size)"
        print_warning "Bu klasör önemli veriler içerdiği için elle silinmelidir"
    fi
    
    # iOS simülatör verileri
    if [ -d "~/Library/Developer/CoreSimulator" ]; then
        size=$(du -sh ~/Library/Developer/CoreSimulator 2>/dev/null | cut -f1)
        print_status "iOS simülatör verileri: ~/Library/Developer/CoreSimulator ($size)"
        read -p "iOS simülatör verilerini temizlemek ister misiniz? (e/H): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ee]$ ]]; then
            print_status "iOS simülatör verileri temizleniyor..."
            xcrun simctl erase all
            print_success "Tüm iOS simülatörleri silindi"
        fi
    fi
    
    # Xcode cache dosyaları
    if [ -d "~/Library/Caches/com.apple.dt.Xcode" ]; then
        size=$(du -sh ~/Library/Caches/com.apple.dt.Xcode 2>/dev/null | cut -f1)
        print_status "Xcode cache dosyaları: ~/Library/Caches/com.apple.dt.Xcode ($size)"
        read -p "Xcode cache dosyalarını temizlemek ister misiniz? (e/H): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ee]$ ]]; then
            print_status "Xcode cache dosyaları temizleniyor..."
            rm -rf ~/Library/Caches/com.apple.dt.Xcode/*
            print_success "Xcode cache dosyaları temizlendi"
        fi
    fi
}

# Ana fonksiyon
main() {
    case "${1:-help}" in
        "find")
            find_ides
            ;;
        "clean")
            find_ides
            echo
            clean_ides
            ;;
        "xcode")
            find_ides
            echo
            clean_xcode_specific
            ;;
        "all")
            find_ides
            echo
            clean_ides
            echo
            clean_xcode_specific
            ;;
        "help"|*)
            echo "Kullanım: $0 [komut]"
            echo
            echo "Komutlar:"
            echo "  find  - IDE klasörlerini bul ve boyutlarını göster"
            echo "  clean - IDE önbelleklerini temizle"
            echo "  xcode - Xcode'a özel temizlik işlemleri"
            echo "  all   - Tüm IDE'leri ve Xcode özel temizliklerini yap"
            echo "  help  - Bu yardım menüsünü göster"
            ;;
    esac
}

# Ana fonksiyonu çalıştır
main "$@"