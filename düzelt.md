1- Düzeltilmesi gereken kısım şu ki örneğin bölgeyi türkiye yaptım a müziğini seçtim b müziği oynatılıyor seçtiğim şarkı ile çalan şarkının alakası yok sanırım backend ile fronted arasında bir senkronizasyon sorunu var


2- Player ekranında oynat durdur butonunun solunda karıştır butonu var ona tıklandığında karışık çalsın, tekrar tıklandığında çalan şarkıyı tekrar et butonuna dönüşşsün yani o butonu canlandıralım. 

3- Video kısmına görsel de ekledik ya o görsel videonun tam boyut olmasını engelliyor ciddi bir kodları incelersen video açıldığında foto kaybolmuyor videonun arkasına  geçiyor video birazcık küçülüyor incelemen lazım. 

4- Anasayfada veya arama kısmına buray yazıyorum örneğin şarkı videosu geliyor ama ses bambaşka bir şarkıya ait oluyor bu sorunu çözmen lazım. 

5- Trend kısmı, Senin için kısmı veya aşağıdaki tüm müzikler kısmı biraz tuhaf görünüyor font ve yazıda hata var sanırım incelemen lazım. 

6- Bölge ve Dil değiştirdim arama butonundaki kategorilerden birini seçtiğimde full boş dönüyor çok ciddi sorunlar var. 

7- Player teması çok güzel olmuş kesinlikle koru ve bu temayla ilerle sadece Kitaplık kısmını çok daha gelişmiş bir sisteme taşıman lazım. 

düzelt.md v2 – 7 Kritik Sorun Çözüm Planı
1. Şarkı Seçimi / Ses Uyumsuzluğu (Sorun 1 + 4)
Kök Neden: 
StreamResolver
 YouTube video ID'si ile JioSaavn'da title/artist bazlı arama yapıyor. Türkçe şarkılarda JioSaavn'da eşleşme bulamazsa YouTube fallback'e düşüyor, ama 
_cleanString()
 Türkçe karakterleri siliyor → yanlış şarkı eşleşmesi.

[MODIFY] 
stream_resolver.dart
_cleanString()
 → Türkçe karakterleri (ö, ü, ş, ç, ğ, ı) koruyacak şekilde güncelle
JioSaavn araması başarısız olursa, doğrudan YouTube video ID ile audio stream çek (zaten fallback var ama title validation eksik)
YouTube fallback'te video ID'yi doğrudan kullan, title search yapma
[MODIFY] 
audio_handler.dart
Satır 11: Duplicate import kaldır
_load()
 fonksiyonuna _currentLoadingId kontrolünü güçlendir
2. Shuffle → Repeat Döngü Butonu (Sorun 2)
[MODIFY] 
player_screen.dart
Shuffle ikonunu 3 modlu döngüye çevir:
Normal (no icon highlight) → tıkla → Shuffle (shuffle icon yeşil) → tıkla → Repeat One (repeat_one icon yeşil) → tıkla → Normal
shuffleModeProvider ve repeatModeProvider kullan
Her modda farklı ikon ve renk göster
3. Video Thumbnail Video'yu Kapatıyor (Sorun 3)
[MODIFY] 
player_screen.dart
Video sayfasında Stack düzeni:
Thumbnail Visibility widget ile sar → video initialize olunca visible: false
AspectRatio kaldır → SizedBox.expand() + FittedBox(fit: BoxFit.cover) ile video tam boyut
Video ready olduğunda arka plan thumbnail'i tamamen gizle
4. Home Screen Font/String Hatası (Sorun 5)
Kök Neden: Satır 196, 242, 286'da '\\${t.trendingHits}' → backslash escape yüzünden literal ${t.trendingHits} metni görüntüleniyor.

[MODIFY] 
home_screen.dart
'🔥 \\${t.trendingHits}' → '🔥 ${t.trendingHits}'
'🎧 \\${t.madeForYou}' → '🎧 ${t.madeForYou}'
'📋 \\${t.allSongs}' → '📋 ${t.allSongs}'
5. Arama Kategorileri Boş Dönüyor (Sorun 6)
Kök Neden: Kategori tıklamasında her zaman "${cat['title']} music playlist official 2024 hits" ekleniyor. Türkçe kategoride → "Arabesk music playlist official 2024 hits" → sonuç yok.

[MODIFY] 
search_screen.dart
Bölgeye göre arama eki değiştir:
TR: "${cat['title']} şarkıları 2024 liste"
US: "${cat['title']} music 2024 hits"
6. Kitaplık Tasarım İyileştirmesi (Sorun 7)
[MODIFY] 
library_screen.dart
Playlists tab: Grid layout → 2 sütunlu kart tasarımı (kapak fotoğrafı büyük, altta isim + şarkı sayısı)
Liked/Downloads: Şarkı sayısı header'ı, daha iyi boş durum görseli
Playlist silme → onay dialog'u ekle
"Tümünü Çal" butonu ekle (Liked/Downloads tablarında)
Verification
Ana sayfada section başlıkları düzgün görünmeli (emoji + doğru metin)
Şarkı seçilince doğru şarkı çalmalı
Shuffle/repeat butonu 3 modda döngü yapmalı
Video tam ekran açılmalı, thumbnail kaybolmalı
TR bölgesinde arama kategorileri sonuç döndürmeli
Kitaplık modern grid görünümüne sahip olmalı

