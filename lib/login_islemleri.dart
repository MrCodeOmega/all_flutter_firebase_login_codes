import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginIslemleri extends StatefulWidget {
  const LoginIslemleri({Key? key}) : super(key: key);

  @override
  _LoginIslemleriState createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('Oturumu Kapattı!');
      } else {
        print('Oturum Açtı!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login İşlemleri"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: _emailSifreKullaniciOlustur,
                child: Text("Create a New user"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent, onPrimary: Colors.white)),
            ElevatedButton(
              onPressed: _emailSifreKullaniciGirisYap,
              child: Text("Login"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent, onPrimary: Colors.white),
            ),

            ElevatedButton(
                onPressed: signInWithGoogle,
                child: Text("Google İle Giriş!"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue, onPrimary: Colors.white)),

            ElevatedButton(
                onPressed: _telNoileGiris,
                child: Text("Telefon No ile Giriş"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.lime, onPrimary: Colors.white)),

            ElevatedButton(
                onPressed: _cikisYap,
                child: Text("Logout"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, onPrimary: Colors.white)),
            //Şifre İşlemleri

            ElevatedButton(
                onPressed: _sifreGuncelle,
                child: Text("Şifre güncelle!"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, onPrimary: Colors.white)),

            ElevatedButton(
                onPressed: _sifremiUnuttum,
                child: Text("Şifremi unuttum!"),
                style: ElevatedButton.styleFrom(
                    primary: Colors.black, onPrimary: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _emailSifreKullaniciOlustur() async {
    String _email = "byhsynakar@gmail.com";
    String _password = "deneme123";

    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      User _yeniUser = _credential.user;
      await _yeniUser.sendEmailVerification();
      if (_auth.currentUser != null) {
        debugPrint("Onay maili gönderildi");
        await _auth.signOut();
        debugPrint("Kullanıcı Oturumunuzu Onaydan sonra açınız");
      }
      debugPrint(_yeniUser.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _emailSifreKullaniciGirisYap() async {
    String _email = "byhsynakar@gmail.com";
    String _password = "deneme123";

    try {
      if (_auth.currentUser == null) {
        User _oturumAcanUser = (await _auth.signInWithEmailAndPassword(
                email: _email, password: _password))
            .user;

        if (_oturumAcanUser.emailVerified) {
          debugPrint("Mail Onaylı yönlendiriliyor...");
        } else {
          debugPrint("Lütfen Maili Onaylayın");
          await _auth.signOut();
        }
      } else {
        debugPrint("Zaten giriş yapıldı.");
      }
    } catch (e) {
      debugPrint("Hata Oluştu********** " + e.toString());
    }
  }

  void _cikisYap() async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
    } else {
      debugPrint("Oturum Açmış kullanıcı Yok");
    }
  }

  void _sifremiUnuttum() async {
    String _email = "byhsynakar@gmail.com";

    try {
      await _auth.sendPasswordResetEmail(email: _email);
      debugPrint("Şifre Maile gönderildi");
    } catch (e) {
      debugPrint("Hata Oluştu*****" + e.toString());
    }
  }

  void _sifreGuncelle() async {
    try {
      await _auth.currentUser.updatePassword("password2");
      debugPrint("Şifre Guncellendi !!");
    } catch (e) {
      try {
        String email = 'byhsynakar@gmail.com';
        String password = 'deneme123';

// Create a credential
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(credential);
        await _auth.currentUser.updatePassword("password2");
      } catch (e) {
        debugPrint("Hata Çıktı *****" + e.toString());
      }
      debugPrint("Hata oluştu******" + e.toString());
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("Hata olustu google ***" + e.toString());
    }
  }

  void _telNoileGiris() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+90 545 449 09 71',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        debugPrint("kod yollandı");
        try {
          String smsCode = '123654';

          // Create a PhoneAuthCredential with the code
          AuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await _auth.signInWithCredential(credential);
        } catch (e) {
          debugPrint("Hata oluştu sms gonderme *****" + e.toString());
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
