import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class FireStoreIslemleri extends StatefulWidget {
  const FireStoreIslemleri({Key? key}) : super(key: key);

  @override
  _FireStoreIslemleriState createState() => _FireStoreIslemleriState();
}

class _FireStoreIslemleriState extends State<FireStoreIslemleri> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PickedFile? _secilenResim;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fire Store"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: _veriEkle, child: Text("Veri Ekle")),
            ElevatedButton(
              onPressed: _transactionEkle,
              child: Text("Transaction Ekle"),
              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
            ),
            ElevatedButton(
              onPressed: _veriSil,
              child: Text("İlgili veriyi sil"),
              style: ElevatedButton.styleFrom(primary: Colors.yellow.shade400),
            ),
            ElevatedButton(
              onPressed: _veriOku,
              child: Text("İlgili veriyi Oku"),
              style: ElevatedButton.styleFrom(primary: Colors.purple.shade400),
            ),
            ElevatedButton(
              onPressed: _veriSorgula,
              child: Text("Veriyi Sorgula"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.yellow, onPrimary: Colors.black),
            ),
            ElevatedButton(
              onPressed: _galeridenYukle,
              child: Text("Galeriden Resim Yükle"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.black, onPrimary: Colors.blueGrey),
            ),
            ElevatedButton(
              onPressed: _kameradanYukle,
              child: Text("Kameradan Resim"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple, onPrimary: Colors.yellow.shade700),
            ),
            Expanded(
              child: _secilenResim != null
                  ? Image.file(File(_secilenResim!.path))
                  : CircleAvatar(
                      child: Icon(Icons.person),
                      radius: 50,
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _veriEkle() {
    Map<String, dynamic> hsynEkle = Map();
    hsynEkle["ad"] = "hsyn";
    hsynEkle["lisansMezunu"] = true;
    _firestore
        .collection('users')
        .doc("hsyn_akar")
        .set(hsynEkle)
        .then((value) => debugPrint("EKlendi"));

    _firestore
        .collection("users")
        .doc("aysenur_akar")
        .set({"ad": "ayse", "cinsiyet": "kız"}).then(
            (value) => debugPrint("Eklendi***"));

    String yeniKullaniciID = _firestore.collection("users").doc().id;
    debugPrint(yeniKullaniciID);

    _firestore
        .collection("users")
        .doc(yeniKullaniciID)
        .set({"ad": "yeni", "yas": 30});

    _firestore.doc("users/hsyn_akar").update({
      "okul": "NKU",
      "eklenme tarih": FieldValue.serverTimestamp()
    }).then((value) => debugPrint("Doc güncellendi ****"));

    _firestore.doc("users/hsyn_akar").update({"para": 300});
    _firestore.doc("users/aysenur_akar").update({"para": 400});
  }

  void _transactionEkle() {
    final DocumentReference hsynRef = _firestore.doc("users/hsyn_akar");
    _firestore.runTransaction((Transaction transaction) async {
      DocumentSnapshot hsynData = await hsynRef.get();
      try {
        if (hsynData.exists) {
          var hsynPara = hsynData.data()["para"];

          if (hsynData.data()["para"] > 100) {
            transaction.update(hsynRef, {"para": (hsynPara - 100)});
            transaction.update(_firestore.doc("users/aysenur_akar"),
                {"para": FieldValue.increment(100)});

            debugPrint("işlem gerçekleşti");
          } else {
            debugPrint("Yetersiz value");
          }
        } else {
          debugPrint("Böyle bir veri Yok ****");
        }
      } catch (e) {
        debugPrint("Hata ****" + e.toString());
      }
    });
  }

  void _veriSil() {
    _firestore
        .doc("users/a7iaWFeXczeHicOVNg0G")
        .delete()
        .then((value) => debugPrint("Silme başarılı***"));

    _firestore
        .doc("users/hsyn_akar")
        .update({"eklenme tarih": FieldValue.delete()}).then((value) =>
            debugPrint("İlgili verideki Kısım Silindi // hsyn_akar***"));
  }

  void _veriOku() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.doc("users/hsyn_akar").get();
    debugPrint("Document ID =" + documentSnapshot.id);
    debugPrint("Document is exist ? :" + documentSnapshot.exists.toString());
    debugPrint("MetaData :" + documentSnapshot.metadata.toString());
    documentSnapshot.data().forEach((key, value) {
      debugPrint("ke: $key, value: $value");
    });
    _firestore.collection("users").doc("hsyn_akar").snapshots().listen((event) {
      debugPrint("anlık veri : " + event.data().toString());
    });
  }

  void _veriSorgula() async {
    var dokumanlar = await _firestore
        .collection("users")
        .where("okul", isEqualTo: "NKU")
        .get();

    try {
      for (var dokuman in dokumanlar.docs) {
        debugPrint(dokuman.data()["ad"].toString());
      }
    } catch (e) {
      debugPrint("Hata sorgu alanında****" + e.toString());
    }

    var limitleriGetir = await _firestore.collection("users").limit(2).get();
    try {
      for (var dokuman in limitleriGetir.docs) {
        debugPrint(dokuman.data()["ad"].toString());
      }
    } catch (e) {
      debugPrint("Hata sorgu alanında****" + e.toString());
    }
  }

  void _galeridenYukle() async {
    var _picker = ImagePicker();
    try {
      var resim = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _secilenResim = resim;
      });

      var ref = FirebaseStorage.instance
          .ref()
          .child("user")
          .child("hsyn")
          .child("profil.png");
      var uploadTask = await ref.putFile(File(_secilenResim!.path));

      var url = await (await ref.getDownloadURL());
      debugPrint("url adres : $url");
    } catch (e) {
      debugPrint("Resim Seçmede hata***" + e.toString());
    }
  }

  void _kameradanYukle() async {
    var _picker = ImagePicker();
    try {
      var resim = await _picker.getImage(source: ImageSource.camera);
      setState(() {
        _secilenResim = resim;
      });

      var ref = FirebaseStorage.instance
          .ref()
          .child("user")
          .child("hsyn")
          .child("profil.png");
      var uploadTask = await ref.putFile(File(_secilenResim!.path));

      var url = await (await ref.getDownloadURL());
      debugPrint("url adres : $url");
    } catch (e) {
      debugPrint("Kameradan seçmede hata***" + e.toString());
    }
  }
}
