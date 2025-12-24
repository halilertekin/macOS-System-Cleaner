# macOS System Cleaner

macOS sistem performansını artırmak için RAM, önbellek ve IDE temizliği yapan kapsamlı script koleksiyonu.

## 🚀 Özellikler

- **RAM Temizliği**: Sistem belleğini optimize eder ve performansı artırır
- **Önbellek Temizliği**: Kullanıcı ve sistem önbelleklerini analiz eder ve gereksiz olanları temizler
- **IDE Temizliği**: Xcode, Android Studio, IntelliJ IDEA, PyCharm ve diğer JetBrains IDE'lerinin önbelleklerini yönetir
- **Brew Entegrasyonu**: Homebrew güncellemeleriyle entegre çalışır
- **Kullanıcı Dostu**: Renkli çıktılar ve açık talimatlar
- **Güvenli Temizlik**: Kritik sistem dosyalarına dokunmaz

## 📦 İçerik

Proje aşağıdaki script'leri içerir:

### Ana Script'ler

- **`cache_cleaner.sh`**: Kullanıcı ve sistem önbelleklerini analiz eder ve temizler
- **`ram_cleaner.sh`**: RAM temizliği yapar ve sistem performansını artırır
- **`ide_cleaner.sh`**: Xcode ve diğer IDE'lerin önbelleklerini analiz eder ve temizler
- **`main_cleaner.sh`**: Tüm temizlik işlemlerini tek bir komutla yapar
- **`brew_update_with_cache.sh`**: Brew güncellemesi sonrası otomatik önbellek analizi yapan wrapper

### cache_cleaner.sh

Özellikler:
- Kullanıcı önbelleklerini analiz eder
- En büyük 10 önbelleği sıralar
- npm, Yarn, Homebrew önbelleklerini kontrol eder
- Geçici klasör boyutlarını gösterir
- Güvenli temizleme seçenekleri sunar

Komutlar:
```
./scripts/cache_cleaner.sh analyze    # Önbellekleri analiz eder
./scripts/cache_cleaner.sh clean     # Önbellekleri temizler
./scripts/cache_cleaner.sh help      # Yardım menüsünü gösterir
```

### ram_cleaner.sh

Özellikler:
- RAM durumunu gösterir (boş, aktif, pasif, sabitlenmiş bellek)
- Disk önbelleğini temizler
- Sistem önbelleğini temizler
- Arka plan süreçlerini temizler

Komutlar:
```
./scripts/ram_cleaner.sh status      # RAM durumunu gösterir
./scripts/ram_cleaner.sh clear       # RAM temizliği yapar
./scripts/ram_cleaner.sh deep        # Derin RAM temizliği (arka plan süreçleriyle birlikte)
```

### ide_cleaner.sh

Özellikler:
- Xcode, Android Studio, IntelliJ IDEA, PyCharm ve diğer JetBrains IDE'lerini tespit eder
- IDE önbellek klasörlerinin boyutlarını gösterir
- IDE önbelleklerini güvenli bir şekilde temizler
- Xcode'a özel temizlik işlemleri (DerivedData, Archive, iOS simülatör verileri)

Komutlar:
```
./scripts/ide_cleaner.sh find        # IDE klasörlerini bulur ve boyutlarını gösterir
./scripts/ide_cleaner.sh clean       # IDE önbelleklerini temizler
./scripts/ide_cleaner.sh xcode       # Xcode'a özel temizlik işlemleri
./scripts/ide_cleaner.sh all         # Tüm IDE'leri ve Xcode temizliklerini yapar
```

### main_cleaner.sh

Özellikler:
- Tüm temizlik script'lerini tek bir komutla çalıştırır
- Kullanıcı dostu menü sistemi
- Ayrı ayrı onay sistemi

Komutlar:
```
./main_cleaner.sh full               # Tüm sistem temizliği (RAM + önbellekler + IDE)
./main_cleaner.sh cache              # Sadece önbellek temizliği
./main_cleaner.sh ram                # Sadece RAM temizliği
./main_cleaner.sh ide                # Sadece IDE temizliği
./main_cleaner.sh analyze            # Sadece analiz (temizleme yapmaz)
```

## 🛠️ Kurulum

### 1. Projeyi Klonlama

```bash
git clone https://github.com/kullaniciadi/macOS-System-Cleaner.git
cd macOS-System-Cleaner
```

### 2. Script İzinlerini Ayarlama

```bash
chmod +x scripts/*.sh
chmod +x main_cleaner.sh
```

### 3. npm Üzerinden Kurulum (Global)

```bash
npm install -g @halilertekin/macos-system-cleaner
```

Bu kurulum sonrası, doğrudan `msc` komutunu kullanabilirsiniz:

```bash
msc analyze      # Sistem analizi yapar
msc full         # Tam sistem temizliği yapar
msc cache        # Sadece önbellek temizliği
msc ram          # Sadece RAM temizliği
msc ide          # Sadece IDE temizliği
```

### 4. Bash Alias Kullanımı

Ayrıca, script'leri doğrudan terminal komutu gibi kullanmak için bir alias oluşturabilirsiniz:

```bash
# ~/.bashrc veya ~/.zshrc dosyasına ekleyin:
alias msc='/path/to/macOS-System-Cleaner/main_cleaner.sh'

# Değişiklikleri uygulamak için:
source ~/.bashrc  # veya source ~/.zshrc
```

Sonrasında doğrudan şu komutları kullanabilirsiniz:

```bash
msc analyze      # Sistem analizi
msc full         # Tam temizlik
msc cache        # Önbellek temizliği
msc ram          # RAM temizliği
msc ide          # IDE temizliği
```

Veya install.sh scripti ile kurulan kolaylık alias'larını kullanabilirsiniz:

```bash
msc-analyze      # Sistem analizi
msc-cache        # Önbellek temizliği
msc-ram          # RAM temizliği
msc-ide          # IDE temizliği
```

## 📖 Kullanım

### Önbellek Temizliği

```bash
# Önbellekleri analiz et
./scripts/cache_cleaner.sh analyze

# Önbellekleri temizle (onay istenir)
./scripts/cache_cleaner.sh clean

# Yardım menüsü
./scripts/cache_cleaner.sh help
```

### RAM Temizliği

```bash
# RAM durumunu göster
./scripts/ram_cleaner.sh status

# RAM temizliği yap
./scripts/ram_cleaner.sh clear

# Derin RAM temizliği (arka plan süreçleriyle birlikte)
./scripts/ram_cleaner.sh deep
```

### IDE Temizliği

```bash
# IDE klasörlerini bul ve boyutlarını göster
./scripts/ide_cleaner.sh find

# IDE önbelleklerini temizle
./scripts/ide_cleaner.sh clean

# Xcode'a özel temizlik işlemleri
./scripts/ide_cleaner.sh xcode

# Tüm IDE'leri ve Xcode temizliklerini yap
./scripts/ide_cleaner.sh all
```

### Tüm Temizlikleri Bir Arada

```bash
# Tüm sistem temizliği (RAM + önbellekler + IDE)
./main_cleaner.sh full

# Sadece analiz yap (temizleme yapmaz)
./main_cleaner.sh analyze
```

Tam temizleme işlemlerinden sonra aşağıdaki gibi görsel bir özet ekranı göreceksiniz:

```
 ┌─────────────────────────────────────────┐
 │           TEMİZLEME ÖZETİ              │
 ├─────────────────────────────────────────┤
 │ • RAM temizliği: ✓                     │
 │ • Önbellek temizliği: ✓                │
 │ • IDE temizliği: ✓                     │
 │ • Sistem kararlılığı: ✓                │
 └─────────────────────────────────────────┘
```

### Brew Update ile Entegrasyon

```bash
# Brew güncellemesi + otomatik önbellek analizi
./scripts/brew_update_with_cache.sh
```

## 🧪 Test Edilmiş IDE'ler

- **Xcode**: DerivedData, Archive, iOS simülatör verileri
- **Android Studio**: Tüm versiyonlar (4.2, 2020.3, 2021.2, 2022.3, 2023.1)
- **IntelliJ IDEA**: Tüm versiyonlar
- **PyCharm**: Tüm versiyonlar
- **JetBrains IDE'leri**: GoLand, WebStorm, CLion, PhpStorm, Rider, AppCode, DataGrip, RubyMine
- **Visual Studio Code**: Uygulama verileri

## ⚠️ Dikkat Edilmesi Gerekenler

### Genel Uyarılar
- Script'ler sistem performansını artırmak için tasarlanmıştır
- Temizlik işlemleri öncesi önemli verilerinizi yedeklemek iyi bir uygulamadır
- IDE temizliği sonrası IDE'lerin yeniden başlatılması gerekebilir
- Xcode DerivedData ve Archive klasörlerinin temizlenmesi derleme sürelerini etkileyebilir

### RAM Temizliği Uyarıları
- RAM temizliği sırasında çalışan uygulamalar kısa süreli yavaşlayabilir
- RAM temizliği genellikle sadece yüksek bellek kullanımı durumunda gereklidir
- Sistem belleği çok düşükse RAM temizliği önerilmez

### IDE Temizliği Uyarıları
- IDE önbelleklerinin temizlenmesi ilk açılışta daha uzun sürebilir
- Proje indekslerinin yeniden oluşturulması gerekebilir
- Bazı ayarlar önbellek temizliğiyle birlikte sıfırlanabilir

## 🤝 Katkıda Bulunma

Katkıda bulunmak isterseniz, lütfen bir pull request gönderin. Aşağıdaki konularda katkılar memnuniyetle karşılanır:

- Yeni IDE destekleri
- Performans iyileştirmeleri
- Hata düzeltmeleri
- Yeni özellikler
- Belgeleme geliştirmeleri

### Katkıda Bulunma Adımları

1. Projeyi fork edin
2. Yeni bir branch oluşturun (`git checkout -b feature/yeni-ozellik`)
3. Değişikliklerinizi yapın
4. Değişikliklerinizi commit edin (`git commit -m 'Yeni özellik: Açıklama'`)
5. Branch'inize push edin (`git push origin feature/yeni-ozellik`)
6. Yeni bir Pull Request oluşturun

## 📄 Lisans

Bu proje MIT Lisansı ile lisanslanmıştır - detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 🐛 Hata Bildirimi

Hataları ve önerileri GitHub Issues bölümünden bildirebilirsiniz.

## ⚠️ Sorumluluk Reddi (Disclaimer)

Bu script'ler tamamen sistem temizliği ve performans artırma amacıyla geliştirilmiştir. Script'leri kullanırken oluşabilecek veri kaybı, sistem kararsızlığı veya diğer olası sorunlardan geliştirici sorumlu değildir. Script'leri kullanmadan önce sistem yedekleri almanız önerilir.

### Hassas Veri İçerik Reddi

Bu script koleksiyonu:
- Herhangi bir kişisel veri içermemektedir
- Kullanıcı şifreleri, API anahtarları veya diğer hassas bilgileri içermez
- Sadece sistem önbelleği ve geçici dosyaları üzerinde işlem yapar
- Kullanıcı verilerine veya özel dosyalara erişim sağlamaz

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

## 🙏 Teşekkürler

- macOS sistem yönetimi konusunda bilgi sağlayan tüm açık kaynak topluluklarına
- Test ve geri bildirim sağlayan tüm kullanıcılara