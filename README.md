# Envanter Yönetim Sistemi

Envanter yönetim sistemi, kullanıcıların ürünleri ekleyip, güncelleyip, silebileceği ve yönetebileceği basit bir bash tabanlı uygulamadır. Ayrıca, kullanıcı yönetimi, şifre sıfırlama, ürün raporları ve sistem yönetimi gibi çeşitli özelliklere de sahiptir. Bu script, `zenity` aracı kullanarak grafiksel arayüz sunmaktadır.

## Özellikler

- **Ürün Yönetimi**: Ürün ekleme, güncelleme, silme ve listeleme işlemleri.
- **Kullanıcı Yönetimi**: Kullanıcı ekleme, listeleme, giriş yapma ve şifre sıfırlama.
- **Raporlama**: Stokta azalan ürünler ve yüksek stoklu ürünler raporları.
- **Sistem Yönetimi**: Disk alanı görüntüleme ve hata kayıtlarını görüntüleme.
- **Admin Kontrolü**: Yönetici yetkileriyle kullanıcıların şifrelerini sıfırlama.

- ## Gereksinimler

- `bash` betik dili
- `zenity` (grafiksel kullanıcı arayüzü için)

Zenity'nin sisteminizde kurulu olup olmadığını kontrol edebilirsiniz. Eğer kurulu değilse, aşağıdaki komutla kurabilirsiniz:

```bash
sudo apt-get install zenity
```

## Dosya Yapısı

```
.
├── depo.csv        # Ürün veritabanı
├── kullanici.csv   # Kullanıcı veritabanı
├── log.csv         # Hata log dosyası
└── envanterProje.sh # Ana Bash script dosyası
```
- **depo.csv**: Ürünlerin saklandığı dosya. Ürünler ID, ad, stok, fiyat ve kategori bilgilerini içerir.
- **kullanici.csv**: Kullanıcıların saklandığı dosya. Kullanıcılar ID, ad, soyad, rol, parola ve durum bilgilerini içerir.
- **log.csv**: Hata loglarının saklandığı dosya. Hata numarası, zaman, kullanıcı adı, ürün ve açıklama içerir.

- ## Kullanım

### Adım 1: Script'i Başlatın

Bash script'i başlatmak için terminalde aşağıdaki komutu çalıştırın:

```bash
./envanterProje.sh
```

### Adım 2: Giriş Yapın

- Kullanıcı adı ve parola girmeniz istenecektir. İlk girişte, varsayılan olarak bir admin kullanıcısı (kullanıcı adı: `Admin`, parola: `admin`) bulunur. Giriş başarılı olursa, ana menüye yönlendirilirsiniz.

### Adım 3: Ana Menü Seçenekleri

Ana menüde aşağıdaki işlemler yapılabilir:

1. **Ürün Ekle**: Yeni bir ürün ekleyebilirsiniz.
2. **Ürün Listele**: Mevcut ürünleri listeleyebilirsiniz.
3. **Ürün Güncelle**: Var olan bir ürünün stok miktarı veya fiyat bilgisini güncelleyebilirsiniz.
4. **Ürün Sil**: Mevcut bir ürünü silebilirsiniz.
5. **Rapor Al**: 
   - Stokta azalan ürünler raporunu alabilirsiniz.
   - En yüksek stok miktarına sahip ürünler raporunu alabilirsiniz.
6. **Kullanıcı Yönetimi**: 
   - Yeni kullanıcı ekleyebilir.
   - Mevcut kullanıcıları listeleyebilirsiniz.
7. **Program Yönetimi**:
   - Disk alanını görüntüleyebilirsiniz.
   - Hata kayıtlarını görüntüleyebilirsiniz.
8. **Çıkış**: Uygulamadan çıkabilirsiniz.

### Adım 4: Yönetici İşlemleri

Bir yönetici olarak, kullanıcıların şifrelerini sıfırlayabilirsiniz. Bunun için, admin kullanıcısı olarak giriş yaptıktan sonra **Kullanıcı Yönetimi** menüsünden şifre sıfırlama işlemini başlatabilirsiniz.

## Script'teki Fonksiyonlar

**`createCsvFiles()`**

Bu fonksiyon, eğer mevcut değilse depo, kullanıcı ve log dosyalarını oluşturur. Dosyalar CSV formatında olacak şekilde başlık satırlarıyla oluşturulur.

**`userLogin()`**

Kullanıcı adı ve şifre ile giriş yapmayı sağlar. Kullanıcı, `kullanici.csv` dosyasındaki bilgilere göre doğrulanır. Ayrıca, kullanıcı durumu (aktif/kilitli) kontrol edilir.

**`initializeAdminUser()`**

Admin kullanıcısını kontrol eder ve eğer mevcut değilse, yeni bir admin kullanıcısı oluşturur.

**`addProduct()`**

Yeni bir ürün ekler. Ürün adı, stok miktarı, fiyatı ve kategorisi istenir.

**`listProducts()`**

Mevcut ürünleri listelemenizi sağlar.

**`updateProduct()`**

Var olan bir ürünün bilgilerini güncellemeyi sağlar. Ürün adı, yeni stok ve fiyat bilgileri istenir.

**`deleteProduct()`**

Mevcut bir ürünü siler.

**`reportLowStock()`**

Stokta azalan ürünlerin listesini almanızı sağlar.

**`reportHighStock()`**

Yüksek stok miktarına sahip ürünlerin listesini almanızı sağlar.

**`addUser()`**

Yeni bir kullanıcı ekler. Kullanıcı adı, adı, soyadı, rol (admin/user) ve parola bilgileri istenir.

**`listUsers()`**

Mevcut kullanıcıları listelemenizi sağlar.

**`resetPassword()`**

Bir yönetici olarak, kullanıcı şifresini sıfırlamanızı sağlar.

**`showDiskUsage()`**

Sisteminizdeki disk alanı kullanımını gösterir.

**`showLog()`**

Hata loglarını görüntüler.


## Notlar

- Script, dosyaların bulunduğu dizinde çalıştırılmalıdır.
- Kullanıcı girişlerinde Zenity GUI pencereleri kullanılmaktadır.
- Yönetici işlemleri için admin kullanıcısının doğru parola ile giriş yapması gerekmektedir.
- Dosyalar `.csv` formatında saklanmaktadır.
