🚨 Kritik ve Sistemsel Hatalar (Bug'lar)
1. iOS Dinamik Klasör (Sandbox) Hatası — En Büyük Tehlike

Sorun: 

download_service.dart
 dosyasında indirilen müzikleri Hive veritabanına kaydederken dosyanın "mutlak tam yolunu" (Absolute Path) kaydediyoruz (Örn: /var/mobile/Containers/Data/Application/123X-456Y/Documents/download/sarki.m4a).
Neden Patlar: Apple iOS işletim sisteminde güvenlik (Sandbox) gereği uygulama her güncellendiğinde veya cihaz baştan başlatıldığında 123X-456Y kısmı rastgele değişir.
Sonuç: Ertesi gün kullanıcı uygulamaya girdiğinde File(song.localPath!).exists() komutu False dönecek, uygulama dosyanın silindiğini sanıp şarkıyı açmayacaktır. Bunu çözmek için veritabanına sadece sarki.m4a şeklindeki dosya adını (relative path) kaydetmeli ve uygulama ne zaman açılırsa o anki getApplicationDocumentsDirectory() dizini ile çalışma zamanında (runtime) birleştirmeliyiz.
2. Arama & Kütüphane Ekranlarındaki "İşlevsiz" Butonlar

Sorun: 

search_screen.dart
 ve 

library_screen.dart
 ekranlarını harika listeledik ama şarkıların yanındaki trailing: Icon(Icons.more_vert) (üç nokta) ya da ikonların hiçbir fonksiyonu yok.
Sonuç: Kullanıcı arama kısmında şarkının yanındaki üç noktaya basıp şarkıyı "Beğenemez", "İndiremez" veya "Oynatma Listesine Ekleyemez". Sadece ana ListTile'a tıklayıp şarkıyı çalabilir. O üç noktayı bir IconButton veya PopupMenuButton içine sarıp fonksiyonlarını BottomModalSheet ile yazmalıyız.
⚠️ Eksik Özellikler ve Tamamlanmamış Akışlar
3. "Playlist" (Oynatma Listesi) Akışının İçi Boş

Klasör ve Oynatma listesi butonunu başarıyla oluşturduk ama Şarkı Ekleme mekaniğimiz ortada yok!
Tıkladığınızda şu mesajı alıyorsunuz: "Playlist açılıyor, detay sayfası yakında!"
Bir kullanıcı herhangi bir yerde şarkının yanındaki 3 noktaya basıp "Bu playlist'e ekle" (addToPlaylist) diyebilmeli ve Playlistlerin üzerine tıkladığında o listeye ait bir Liste Ekranı (Playlist Details Screen) açılmalı. Şu an böyle bir ekranımız (screens/playlist_detail_screen.dart) bulunmuyor. Kısacası playlistler gösteriş olarak var.
4. Kütüphane İçerisindeki Liked / Offline Şarkı Yönetimi

Library kısmında bir şarkı Beğenilenler listesine düşüyor ama kullanıcı "Yanlışlıkla beğendim, listeden çıkartayım" diyemiyor. Bir Un-like (Beğenmekten Vazgeçme) ve şarkıyı fiziksel diskten tamamen Silme mantığına ait UI kontrollerimiz şu anda yok.
5. Sonsuz Kaydırma (Pagination/Infinite Scroll) Eksikliği


youtube_service.dart
 sadece tek bir sayfalık arama (search.search(query)) gerçekleştirip bırakıyor.
Eğer dinleyici bir kategoriyi filtreleyip aşağı kaydırırsa (scroll yaparsa), listenin sonuna geldiğinde yeni şarkıları veya sonraki sayfayı (load more) yükleyemez. Oysa her müzik platformunda aşağı kaydırdıkça yeni şarkılar gelmeye devam eder.
6. Ayarlar Sayfası Hâlâ İşlevsiz

UI olarak harika bir 

settings_screen.dart
 sayfamız var ama tıkladığımızda hiçbir ayarı fiilen değiştirmiyor, sadece bir uyarı (SnackBar) çıkartıyoruz: "Languages ayarları yakında eklenecek."
🛠️ Performans ve UX Optimizasyonları
7. Offline Şarkılarda "İndiriliyor..." Göstergesi Eksikliği

Bir şarkıya "İndir" dediğimizde indirme servisi (Background) üzerinden şarkıyı çekmeye başlıyor ama kullanıcı arayüzünde şarkının o an % kaç indiğini, veya indiriliyor olduğuna dair dönen bir progress bar animasyonumuz (CircularProgressIndicator) yok. Kullanıcı şarkının inip inmediğini o an anlamıyor