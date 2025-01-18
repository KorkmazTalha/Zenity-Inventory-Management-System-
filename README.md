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
<img width="240" alt="2" src="https://github.com/user-attachments/assets/63508804-a303-4bf2-883a-077cb415a323" />
<img width="249" alt="3" src="https://github.com/user-attachments/assets/c3372f18-4334-41d0-82ff-7f8f836790d7" />
<img width="240" alt="4" src="https://github.com/user-attachments/assets/6d309846-5fd3-4714-9d16-23b4255714b0" />

### Adım 3: Ana Menü Seçenekleri

Ana menüde aşağıdaki işlemler yapılabilir:

1. **Ürün Ekle**: Yeni bir ürün ekleyebilirsiniz.
<img width="244" alt="7" src="https://github.com/user-attachments/assets/9b1d723e-e47a-4ee4-9a50-410008672fe8" />
<img width="244" alt="8" src="https://github.com/user-attachments/assets/ae0db19f-9ce8-4848-b1cd-60aa3aff733e" />
<img width="244" alt="9" src="https://github.com/user-attachments/assets/19a5504c-a37f-4888-b226-5a4e699f1821" />
<img width="244" alt="10" src="https://github.com/user-attachments/assets/a3154718-787a-4c48-b3f3-7a4542226019" />
<img width="244" alt="12" src="https://github.com/user-attachments/assets/b7cac692-7cb7-43dd-a2c0-1483f1d1ffec" />
<img width="244" alt="11" src="https://github.com/user-attachments/assets/fd2c8d2a-91fa-4bdd-a968-a34e86821604" />


2. **Ürün Listele**: Mevcut ürünleri listeleyebilirsiniz.

3. **Ürün Güncelle**: Var olan bir ürünün stok miktarı veya fiyat bilgisini güncelleyebilirsiniz.
<img width="282" alt="13" src="https://github.com/user-attachments/assets/affaac46-04b5-4444-9e7c-695743254c03" />
<img width="237" alt="14" src="https://github.com/user-attachments/assets/342f5ce7-1017-455e-bd7e-23c9283e4b77" />
<img width="241" alt="15" src="https://github.com/user-attachments/assets/9595e268-b4f9-4ed3-972c-286811f6a815" />
<img width="248" alt="16" src="https://github.com/user-attachments/assets/cfdc85cb-a1fc-4b34-beb9-be26e0021118" />

4. **Ürün Sil**: Mevcut bir ürünü silebilirsiniz.

5. **Rapor Al**: 
   - Stokta azalan ürünler raporunu alabilirsiniz.
   - En yüksek stok miktarına sahip ürünler raporunu alabilirsiniz.
<img width="379" alt="17" src="https://github.com/user-attachments/assets/9155c449-8001-4ef2-a24b-51ddca020a39" />
<img width="249" alt="26" src="https://github.com/user-attachments/assets/44043098-9ead-44ef-a828-d6736d1ef400" />
<img width="298" alt="25" src="https://github.com/user-attachments/assets/3b32f0ec-f0e3-4695-a692-6637f5d131a6" />


6. **Kullanıcı Yönetimi**: 
   - Yeni kullanıcı ekleyebilir.
   - Mevcut kullanıcıları listeleyebilirsiniz.
<img width="383" alt="18" src="https://github.com/user-attachments/assets/0486af07-7b33-45f1-bbe9-840ee58b30b7" />

7. **Program Yönetimi**:
   - Disk alanını görüntüleyebilirsiniz.
   - Hata kayıtlarını görüntüleyebilirsiniz.
<img width="383" alt="19" src="https://github.com/user-attachments/assets/390d226b-465d-438f-b643-012d096cb2a6" />

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

**GitHub Link**

https://github.com/KorkmazTalha/Zenity-Inventory-Management-System-
