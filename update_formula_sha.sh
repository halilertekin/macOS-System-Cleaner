#!/usr/bin/env bash

# Homebrew Formula SHA256 Otomatik Güncelleme Scripti
# GitHub'da yeni bir tag oluşturulduğunda, ilgili tarball'ın SHA256 hash'ini hesaplar
# ve Homebrew formula dosyasını otomatik olarak günceller

set -e  # Hatalarda çık

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Renksiz

# Renkli çıktı fonksiyonları
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Yardım menüsü
show_help() {
    echo "Homebrew Formula SHA256 Otomatik Güncelleme Scripti"
    echo "GitHub'da yeni tag'e göre SHA256 hash hesaplar ve formula dosyasını günceller"
    echo
    echo "Kullanım: $0 [seçenek] [tag]"
    echo
    echo "Seçenekler:"
    echo "  --update <tag>      Belirtilen tag için SHA256 hash hesapla ve güncelle"
    echo "  --dry-run <tag>     Sadece hesapla, güncelleme yapma (test modu)"
    echo "  --latest            GitHub'dan son tag'ı al ve güncelle"
    echo "  --show-current      Mevcut formula versiyonunu göster"
    echo "  --help              Bu yardım menüsünü gösterir"
    echo
    echo "Örnekler:"
    echo "  $0 --update v1.1.0"
    echo "  $0 --latest"
    echo "  $0 --dry-run v1.1.0"
    echo "  $0 --show-current"
}

# SHA256 hash hesapla
calculate_sha256() {
    local tag=$1
    local repo_url="https://github.com/halilertekin/macOS-System-Cleaner/archive/refs/tags/${tag}.tar.gz"

    print_status "Tarball indiriliyor: $repo_url"

    # Geçici dosya oluştur
    local temp_tarball=$(mktemp)

    # Tarball'ı indir
    if ! curl -L -o "$temp_tarball" "$repo_url"; then
        print_error "Tarball indirilemedi: $repo_url"
        rm -f "$temp_tarball"
        return 1
    fi

    # SHA256 hash hesapla
    local sha256_hash=$(shasum -a 256 "$temp_tarball" | cut -d ' ' -f 1)

    # Geçici dosyayı sil
    rm -f "$temp_tarball"

    echo "$sha256_hash"
}

# GitHub'dan son tag'ı al
get_latest_tag() {
    print_status "GitHub'dan son tag alınıyor..."

    # GitHub API kullanarak son tag'ı al
    local latest_tag=$(curl -s "https://api.github.com/repos/halilertekin/macOS-System-Cleaner/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

    if [ -z "$latest_tag" ]; then
        print_warning "GitHub API'den tag alınamadı, yerel repodan tag aranıyor..."
        # Yerel repoda tag varsa onu kullan
        if git rev-parse --verify --quiet "$(git tag --list | tail -n 1)" >/dev/null 2>&1; then
            latest_tag=$(git tag --list | tail -n 1)
        fi
    fi

    echo "$latest_tag"
}

# Tag formatını kontrol et
validate_tag() {
    local tag=$1

    if [[ ! "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_warning "Tag formatı önerilen formatta değil (örn: v1.2.3): $tag"
        read -p "Yine de kullanmak istiyor musunuz? (e/H): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ee]$ ]]; then
            print_error "İşlem iptal edildi."
            return 1
        fi
    fi
}

# Formula dosyasını yedekle
backup_formula() {
    local formula_file="macos-system-cleaner.rb"
    local backup_file="${formula_file}.backup.$(date +%Y%m%d_%H%M%S)"

    if [ -f "$formula_file" ]; then
        cp "$formula_file" "$backup_file"
        print_status "Formula dosyası yedeklendi: $backup_file"
    else
        print_error "Formula dosyası bulunamadı: $formula_file"
        return 1
    fi
}

# Formula dosyasını güncelle
update_formula() {
    local tag=$1
    local new_sha256=$2
    local formula_file="macos-system-cleaner.rb"

    if [ ! -f "$formula_file" ]; then
        print_error "Formula dosyası bulunamadı: $formula_file"
        return 1
    fi

    print_status "Formula dosyası güncelleniyor: $formula_file"
    print_status "Yeni tag: $tag"
    print_status "Yeni SHA256: $new_sha256"

    # Formula dosyasını yedekle
    backup_formula

    # Eski tag ve SHA256 değerlerini bul ve değiştir
    # URL satırını güncelle
    sed -i.bak "s|https://github.com/halilertekin/macOS-System-Cleaner/archive/refs/tags/v[0-9.]*\.tar\.gz|https://github.com/halilertekin/macOS-System-Cleaner/archive/refs/tags/${tag}.tar.gz|g" "$formula_file"

    # SHA256 satırını güncelle
    sed -i.bak "s|sha256 \"[a-f0-9]*\"|sha256 \"${new_sha256}\"|g" "$formula_file"

    # Versiyon bilgisini de güncelle (eğer varsa)
    sed -i.bak "s|version \"v[0-9.]*\"|version \"${tag}\"|g" "$formula_file" 2>/dev/null || true

    # Yedek dosyayı sil
    rm -f "$formula_file.bak"

    print_success "Formula dosyası başarıyla güncellendi!"
}

# Mevcut versiyonu göster
show_current_version() {
    local formula_file="macos-system-cleaner.rb"

    if [ -f "$formula_file" ]; then
        local current_version=$(grep -o 'url "https://github.com/halilertekin/macOS-System-Cleaner/archive/refs/tags/[^"]*"' "$formula_file" | grep -o 'v[0-9.]*' | head -1)
        local current_sha256=$(grep -o 'sha256 "[^"]*"' "$formula_file" | cut -d '"' -f 2)

        echo "Mevcut versiyon: ${current_version:-Bilinmiyor}"
        echo "Mevcut SHA256: ${current_sha256:-Bilinmiyor}"
    else
        echo "Formula dosyası bulunamadı"
    fi
}

# Ana fonksiyon
main() {
    case "${1:-help}" in
        "--update")
            if [ -z "$2" ]; then
                print_error "Lütfen bir tag belirtin: $0 --update <tag>"
                exit 1
            fi

            local tag="$2"
            validate_tag "$tag"
            if [ $? -ne 0 ]; then
                exit 1
            fi

            print_status "SHA256 hash hesaplanıyor: $tag"

            local sha256_hash=$(calculate_sha256 "$tag")
            if [ $? -ne 0 ]; then
                print_error "SHA256 hash hesaplanamadı"
                exit 1
            fi

            print_status "Hesaplanan SHA256: $sha256_hash"

            update_formula "$tag" "$sha256_hash"
            ;;
        "--dry-run")
            if [ -z "$2" ]; then
                print_error "Lütfen bir tag belirtin: $0 --dry-run <tag>"
                exit 1
            fi

            local tag="$2"
            validate_tag "$tag"
            if [ $? -ne 0 ]; then
                exit 1
            fi

            print_status "SHA256 hash hesaplanıyor (test modu): $tag"

            local sha256_hash=$(calculate_sha256 "$tag")
            if [ $? -ne 0 ]; then
                print_error "SHA256 hash hesaplanamadı"
                exit 1
            fi

            print_status "Hesaplanan SHA256: $sha256_hash"
            print_warning "Bu sadece test modudur. Formula dosyası güncellenmedi."
            ;;
        "--latest")
            print_status "GitHub'dan son tag alınıyor..."
            local latest_tag=$(get_latest_tag)
            if [ -z "$latest_tag" ]; then
                print_error "GitHub'dan tag alınamadı"
                exit 1
            fi

            print_status "Bulunan son tag: $latest_tag"
            validate_tag "$latest_tag"
            if [ $? -ne 0 ]; then
                exit 1
            fi

            print_status "SHA256 hash hesaplanıyor: $latest_tag"

            local sha256_hash=$(calculate_sha256 "$latest_tag")
            if [ $? -ne 0 ]; then
                print_error "SHA256 hash hesaplanamadı"
                exit 1
            fi

            print_status "Hesaplanan SHA256: $sha256_hash"

            update_formula "$latest_tag" "$sha256_hash"
            ;;
        "--show-current")
            print_status "Mevcut formula versiyonu:"
            show_current_version
            ;;
        "--help"|"-h"|*)
            show_help
            ;;
    esac
}

# Ana fonksiyonu çalıştır
main "$@"

# Script sonu