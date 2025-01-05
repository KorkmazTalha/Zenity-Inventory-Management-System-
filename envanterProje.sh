#!/bin/bash

# CSV dosyalarının yolları
depoFile="depo.csv"
kullaniciFile="kullanici.csv"
logFile="log.csv"

# Varsayılan ürün numarası
productId=1

# Kullanıcı Rolleri
roleAdmin="admin"
roleUser="user"

# CSV dosyalarını kontrol et, yoksa oluştur
createCsvFiles() {
    echo "Dosya kontrol ediliyor..."
    if [ ! -f "$depoFile" ]; then
        echo "ID,Ad,Stok,Fiyat,Kategori" > "$depoFile"
        zenity --info --text="Depo dosyası oluşturuldu."
    fi
    if [ ! -f "$kullaniciFile" ]; then
        echo "ID,Adı,Soyadı,Rol,Parola,Durum" > "$kullaniciFile"
        # Admin kullanıcısını dosyaya ekleyelim
        echo "1,Admin,Admin,admin,admin,aktif" >> "$kullaniciFile"
        zenity --info --text="Admin kullanıcısı oluşturuldu. İlk şifre 'admin' olarak ayarlandı."
    fi
    if [ ! -f "$logFile" ]; then
        echo "Hata No,Zaman,Kullanıcı,Ürün,Açıklama" > "$logFile"
        zenity --info --text="Log dosyası oluşturuldu."
    fi
}

userLogin() {
    # Dosyanın varlığı kontrol edilsin
    if [ ! -f "$kullaniciFile" ]; then
        zenity --error --text="Kullanıcı dosyası bulunamadı!"
        exit 1
    fi

    username=$(zenity --entry --title="Giriş Yap" --text="Kullanıcı Adınızı girin:")
    password=$(zenity --password --title="Giriş Yap" --text="Parolanızı girin:")

    # Kullanıcıyı kontrol et
    userInfo=$(awk -F',' -v user="$username" '$2 == user {print $0}' "$kullaniciFile")
    if [[ -z "$userInfo" ]]; then
        zenity --error --text="Kullanıcı bulunamadı!"
        exit 1
    fi

    userPassword=$(echo "$userInfo" | cut -d',' -f5)
    userStatus=$(echo "$userInfo" | cut -d',' -f6)

    # Kullanıcı durumu kilitli mi kontrol et
    if [ "$userStatus" == "kilitli" ]; then
        zenity --error --text="Hesabınız kilitlenmiş. Lütfen yöneticinizle iletişime geçin."
        exit 1
    fi

    # Parola doğrulama
    if [ "$password" != "$userPassword" ]; then
        zenity --error --text="Yanlış parola!"
        exit 1
    fi
    
    zenity --info --text="Giriş başarılı!"
}


# Admin kullanıcı kontrolü
initializeAdminUser() {
    adminUser=$(awk -F',' -v role="admin" '$4 == role {print $0}' "$kullaniciFile")
    if [[ -z "$adminUser" ]]; then
        echo "1,Admin,Admin,admin,admin,aktif" >> "$kullaniciFile"
        zenity --info --text="Admin kullanıcısı oluşturuldu. İlk şifre 'admin' olarak ayarlandı."
    fi
}

# Log kaydı ekle
logError() {
    echo "$(date),$1,$2,$3" >> "$logFile"
}

# Şifre sıfırlama fonksiyonu (Yönetici yetkisiyle)
resetPassword() {
    adminUsername=$(zenity --entry --title="Yönetici Girişi" --text="Yönetici kullanıcı adınızı girin:")
    adminPassword=$(zenity --password --title="Yönetici Girişi" --text="Yönetici parolanızı girin:")

    # Yönetici bilgilerini kontrol et
    adminInfo=$(awk -F',' -v user="$adminUsername" '$2 == user && $4 == "admin" {print $0}' "$kullaniciFile")
    if [[ -z "$adminInfo" ]]; then
        zenity --error --text="Yönetici bulunamadı veya geçersiz kullanıcı adı!"
        exit 1
    fi

    adminPasswordCheck=$(echo "$adminInfo" | cut -d',' -f5)
    if [[ "$adminPassword" != "$adminPasswordCheck" ]]; then
        zenity --error --text="Yanlış yönetici parolası!"
        exit 1
    fi

    # Kullanıcıyı seçme
    userToReset=$(zenity --entry --title="Şifre Sıfırlama" --text="Şifresini sıfırlamak istediğiniz kullanıcı adını girin:")

    # Kullanıcı bilgilerini kontrol et
    userInfo=$(awk -F',' -v user="$userToReset" '$2 == user {print $0}' "$kullaniciFile")
    if [[ -z "$userInfo" ]]; then
        zenity --error --text="Kullanıcı bulunamadı!"
        return 1
    fi

    # Yeni şifreyi alma
    newPassword=$(zenity --entry --title="Yeni Şifre" --text="Yeni şifrenizi girin:" --hide-text)
    confirmPassword=$(zenity --entry --title="Şifreyi Doğrula" --text="Yeni şifrenizi tekrar girin:" --hide-text)

    # Şifrelerin eşleşip eşleşmediğini kontrol et
    if [[ "$newPassword" != "$confirmPassword" ]]; then
        zenity --error --text="Şifreler uyuşmuyor! Lütfen tekrar deneyin."
        return 1
    fi

    # Şifreyi güncelle
    userId=$(echo "$userInfo" | cut -d',' -f1)
    userName=$(echo "$userInfo" | cut -d',' -f2)
    userSurname=$(echo "$userInfo" | cut -d',' -f3)
    userRole=$(echo "$userInfo" | cut -d',' -f4)
    userStatus=$(echo "$userInfo" | cut -d',' -f6)

    # Yeni şifreyi dosyaya kaydet
    sed -i "s/^$userId,$userName,$userSurname,$userRole,$userPassword,$userStatus/$userId,$userName,$userSurname,$userRole,$newPassword,$userStatus/" "$kullaniciFile"

    zenity --info --text="Şifre başarıyla sıfırlandı."
}

addProduct() {
    productName=$(zenity --entry --title="Ürün Ekle" --text="Ürün Adını girin:")
    stock=$(zenity --entry --title="Ürün Ekle" --text="Stok miktarını girin:")
    price=$(zenity --entry --title="Ürün Ekle" --text="Birim fiyatını girin:")
    category=$(zenity --entry --title="Ürün Ekle" --text="Kategori girin:")

    if [[ -z "$productName" || -z "$stock" || -z "$price" || -z "$category" ]]; then
        zenity --error --text="Tüm alanları doldurun!"
        return 1
    fi

    # Ürün numarasını al
    productId=$(awk -F',' '{print $1}' "$depoFile" | sort -n | tail -n 1)
    productId=$((productId + 1))

    # Ürün ekleme
    echo "$productId,$productName,$stock,$price,$category" >> "$depoFile"

    zenity --info --text="Ürün başarıyla eklendi."
}


listProducts() {
    
    productList=$(tail -n +2 "$depoFile" | awk -F',' '{print "ID: "$1", Adı: "$2", Stok: "$3", Fiyat: "$4", Kategori: "$5}')
    
    if [[ -z "$productList" ]]; then
        zenity --info --text="Hiç ürün bulunmamaktadır."
    else
        zenity --text-info --title="Ürünler" --width=600 --height=400 --text="$productList"
    fi
}


# Ürün güncelle
updateProduct() {
    productName=$(zenity --entry --title="Ürün Güncelle" --text="Güncellemek istediğiniz ürünün adını girin:")

    productInfo=$(grep "$productName" "$depoFile")
    if [[ -z "$productInfo" ]]; then
        zenity --error --text="Ürün bulunamadı."
        return 1
    fi

    productId=$(echo "$productInfo" | cut -d',' -f1)
    newStock=$(zenity --entry --title="Ürün Güncelle" --text="Yeni stok miktarını girin:")
    newPrice=$(zenity --entry --title="Ürün Güncelle" --text="Yeni birim fiyatını girin:")
    category=$(echo "$productInfo" | cut -d',' -f5)

    # Ürün güncelleme
    sed -i "s/^$productId,.*/$productId,$productName,$newStock,$newPrice,$category/" "$depoFile"

    zenity --info --text="Ürün başarıyla güncellendi."
}

# Ürün sil
deleteProduct() {
    productName=$(zenity --entry --title="Ürün Sil" --text="Silmek istediğiniz ürünün adını girin:")

    productInfo=$(grep "$productName" "$depoFile")
    if [[ -z "$productInfo" ]]; then
        zenity --error --text="Ürün bulunamadı."
        return 1
    fi

    # Ürün silme onayı
    if zenity --question --text="Bu ürünü silmek istediğinize emin misiniz?"; then
        sed -i "/$productName/d" "$depoFile"
        zenity --info --text="Ürün başarıyla silindi."
    else
        zenity --info --text="Silme işlemi iptal edildi."
    fi
}

# Stokta Azalan Ürünleri Raporla
reportLowStock() {
    threshold=$(zenity --entry --title="Stokta Azalan Ürünler" --text="Stok eşiğini girin:")
    lowStockProducts=$(awk -F',' -v threshold="$threshold" '{if ($3 < threshold) print $1", "$2", Stok: "$3", Fiyat: "$4", Kategori: "$5}' "$depoFile")

    if [[ -z "$lowStockProducts" ]]; then
        zenity --info --text="Stokta azalan ürün bulunmamaktadır."
    else
        zenity --text-info --title="Stokta Azalan Ürünler" --width=600 --height=400 --text="$lowStockProducts"
    fi
}

# En Yüksek Stok Miktarına Sahip Ürünler
reportHighStock() {
    threshold=$(zenity --entry --title="En Yüksek Stok Miktarına Sahip Ürünler" --text="Stok eşiğini girin:")
    highStockProducts=$(awk -F',' -v threshold="$threshold" '{if ($3 > threshold) print $1", "$2", Stok: "$3", Fiyat: "$4", Kategori: "$5}' "$depoFile")

    if [[ -z "$highStockProducts" ]]; then
        zenity --info --text="Yüksek stoklu ürün bulunmamaktadır."
    else
        zenity --text-info --title="En Yüksek Stok Miktarına Sahip Ürünler" --width=600 --height=400 --text="$highStockProducts"
    fi
}

# Yeni Kullanıcı Ekle
addUser() {
    username=$(zenity --entry --title="Yeni Kullanıcı Ekle" --text="Kullanıcı adını girin:")
    firstName=$(zenity --entry --title="Yeni Kullanıcı Ekle" --text="Adı girin:")
    lastName=$(zenity --entry --title="Yeni Kullanıcı Ekle" --text="Soyadı girin:")
    role=$(zenity --list --title="Yeni Kullanıcı Ekle" --column="Rol" "admin" "user")
    password=$(zenity --password --title="Yeni Kullanıcı Ekle" --text="Parola girin:")

    # Kullanıcı ekleme
    userId=$(awk -F',' '{print $1}' "$kullaniciFile" | sort -n | tail -n 1)
    userId=$((userId + 1))

    echo "$userId,$firstName,$lastName,$role,$password,aktif" >> "$kullaniciFile"
    zenity --info --text="Kullanıcı başarıyla eklendi."
}


# Kullanıcıları Listele
listUsers() {
    
    users=$(tail -n +2 "$kullaniciFile" | awk -F',' '{print "ID: "$1", Adı: "$2", Soyadı: "$3", Rol: "$4}')
    
    if [[ -z "$users" ]]; then
        zenity --info --text="Hiç kullanıcı bulunmamaktadır."
    else
        zenity --text-info --title="Kullanıcılar" --width=600 --height=400 --text="$users"
    fi
}


# Program Yönetimi - Diskteki Alanı Göster
showDiskUsage() {
    diskUsage=$(df -h)
    zenity --text-info --title="Disk Alanı" --width=600 --height=400 --text="$diskUsage"
}

# Program Yönetimi - Hata Kayıtlarını Göster
showLog() {
    logs=$(cat "$logFile")
    zenity --text-info --title="Hata Kayıtları" --width=600 --height=400 --text="$logs"
}

# Ana Menü
mainMenu() {
    createCsvFiles
    userLogin  

    while true; do
        action=$(zenity --list --title="Ana Menü" --column="İşlem" \
            "Ürün Ekle" "Ürün Listele" "Ürün Güncelle" "Ürün Sil" "Rapor Al" "Kullanıcı Yönetimi" "Program Yönetimi" "Çıkış")

        case "$action" in
            "Ürün Ekle") addProduct ;;
            "Ürün Listele") listProducts ;;
            "Ürün Güncelle") updateProduct ;;
            "Ürün Sil") deleteProduct ;;
            "Rapor Al") 
                reportAction=$(zenity --list --title="Rapor Al" --column="Rapor Türü" \
                    "Stokta Azalan Ürünler" "En Yüksek Stok Miktarına Sahip Ürünler")
                case "$reportAction" in
                    "Stokta Azalan Ürünler") reportLowStock ;;
                    "En Yüksek Stok Miktarına Sahip Ürünler") reportHighStock ;;
                esac
                ;;
            "Kullanıcı Yönetimi") 
                userAction=$(zenity --list --title="Kullanıcı Yönetimi" --column="İşlem" \
                    "Yeni Kullanıcı Ekle" "Kullanıcıları Listele")
                case "$userAction" in
                    "Yeni Kullanıcı Ekle") addUser ;;
                    "Kullanıcıları Listele") listUsers ;;
                esac
                ;;
            "Program Yönetimi") 
                programAction=$(zenity --list --title="Program Yönetimi" --column="İşlem" \
                    "Disk Alanı Göster" "Hata Kayıtlarını Göster")
                case "$programAction" in
                    "Disk Alanı Göster") showDiskUsage ;;
                    "Hata Kayıtlarını Göster") showLog ;;
                esac
                ;;
            "Çıkış") exit 0 ;;
            *) zenity --error --text="Geçersiz seçenek!" ;;
        esac
    done
}

# Ana menüyü başlat
mainMenu

