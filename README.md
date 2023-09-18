
Bu takvim uygulaması Flutter framework kullanılarak geliştirilmiştir. Kullanıcıların kayıt olabilecekleri, oturum açabilecekleri ve yönetici erişimine sahip olduklarında özel işlemler gerçekleştirebilecekleri bir uygulamadır. Firebase Firestore ile kullanıcı kimlik doğrulama ve veri depolama işlevselliği sağlanmıştır.

Ana Özellikler
Kullanıcı Kimlik Doğrulaması: Kullanıcıları kimlik doğrulamak için FirebaseAuth kullanılmaktadır. Uygulama hem oturum açma hem de kayıt işlevselliğine sahiptir.

Kullanıcı Kaydı: Yeni kullanıcılar, ad, soyad, kullanıcı adı, şifre, TC kimlik numarası, telefon, e-posta, adres ve kullanıcı türü (Admin veya User) gibi bilgilerini sağlayarak kayıt olabilirler.

Admin Girişi: Eğer bir kullanıcı yönetici erişimine sahipse, özel yönetici işlemleri gerçekleştirebilir.

Navigasyon: Kullanıcılar, uygulama içindeki çeşitli sayfalar arasında gezinebilir.

Sınıflar
-LoginScreen
LoginScreen sınıfı, kullanıcının uygulamaya giriş yapmasına olanak tanır. E-posta ve şifre alanları bulunmaktadır. Yönetici girişi de bu sayfa üzerinden yapılabilmektedir. Kullanıcı başarılı bir şekilde oturum açarsa, ana sayfaya yönlendirilir.

-RegisterScreen
RegisterScreen sınıfı, yeni kullanıcıların kaydolmasını sağlar. Kullanıcının çeşitli bilgilerini girmesi gereken bir form bulunmaktadır. Yeni kayıtlar Firebase Firestore veritabanına kaydedilir. Kullanıcı türü olarak Admin seçilirse, zaten bir yönetici varsa kayıt reddedilir.

-AuthService
AuthService sınıfı, FirebaseAuth ile iletişim kurmak için kullanılan bir servistir. Kullanıcının e-posta ve şifre ile oturum açmasını ve yönetici olarak oturum açmasını sağlar.

-User Model
Bu model, Firestore veritabanındaki bir kullanıcıyı temsil eder. Her kullanıcının ad, soyad, kullanıcı adı, TC kimlik numarası, telefon, e-posta, adres ve kullanıcı türü gibi alanları vardır.

-Diğer Sınıflar
AdminScreen ve MyHomePage sınıfları uygulamanın farklı sayfalarını temsil eder. Bu sınıflar, kullanıcının uygulama içinde gezinmesini sağlar.
