//
//  Ders.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 19.12.2020.
//  


import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

let sinavGunu = "2022-06-22" /// SINAV GÜNÜ

class Motor{
    //MARK:-VARIABLES

    let defaults = UserDefaults.standard


    //MARK:-FUNCTIONS

    //SINAVA KALAN ZAMAN ---GÜN
    func programbitişiHafta() -> Double{

        let calendar = Calendar.current

        let firstDate = Date()
        let end = "2022-08-31"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"


        let secondDate = dateFormatter.date(from: end)!

        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)

        let components = calendar.dateComponents([Calendar.Component.weekday], from: date1, to: date2)
        let kalan = Double(components.weekday!)

        return kalan
    }

    //UYGULAMAYA İLK GİRDİĞİ HAFTANIN PROGRAMI İÇİN HAFTANIN KALAN GÜNLERİ
    func HaftanınKalanGunleri()->[String]{
        let weekdays = ["Pazartesi","Salı","Çarşamba","Perşembe","Cuma","Cumartesi","Pazar"]

        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "tr_TR")
        let components = calendar.component(.weekday, from: Date())
        var bugun = components-2
        if bugun == -1{
            bugun = 6
        }
        var kalanGunler = [String]()
        for i in 0...6{
            if i < bugun{
                
            }else if i >= bugun{
                kalanGunler.append(weekdays[i])
            }
        }
        return kalanGunler
    }

    var günler = ["Cumartesi","Pazar"]


    func A(konular:[Konu]) -> [String:[Konu]]{
        var final = [String : [Konu]]()

        var replaceArr = [Int]() ///  [0,0]
        let kalanGunler = ["Cuma","Cumartesi","Pazar"]
        var toplamDeger = 0
        for i in konular{
            toplamDeger = toplamDeger + i.konuDegeri
        }
        let üstSınır = Double(Double(toplamDeger)/Double(kalanGunler.count)).rounded(.up)

        

        for _ in 0...kalanGunler.count-1{
            replaceArr.append(0)
        }

        var guncel = 0

        var ayıklananPlus = [[Konu]]() // Ayrı Bir gün olarak verilecek zaten
        var ayıklananNegative = [Konu]()



        for konu in konular{
            if konu.konuDegeri >= Int(üstSınır){
                ayıklananPlus.append([konu])
            }else{
                ayıklananNegative.append(konu)
            }

        }


        let reducedArray = ayıklananNegative.reduce(into: [[Konu]]()) { result, current in
            guard var last = result.last else { result.append([current]); return }
            if last.reduce(0, { $0 + $1.konuDegeri }) < Int(üstSınır) {
                print("üstSınır:",üstSınır)
                last.append(current)

                result[result.count - 1] = last



            } else{
                result.append([current])
            }
        }

        let newArr = konular.sorted(by: { $0.konuDegeri > $1.konuDegeri })


        let reducedddArr = newArr.reduce(into: [[Konu]]()) { result, current in
            guard var last = result.last else { result.append([current]); return }
            if last.reduce(0, { $0 + $1.konuDegeri }) < Int(üstSınır) {
                print("üstSınır:",üstSınır)
                last.append(current)

                result[result.count - 1] = last



            } else{
                result.append([current])
            }
        }

        for i in 0..<min(kalanGunler.count, reducedddArr.count){
            final[kalanGunler[i]] = reducedddArr[i]

        }


        for i in final{
            print(i.key, i.value)

        }


        return final
    }






    //MARK:- DERSLERİ HAFTAYA DAĞIT
    func dersleriHaftayaDağıt(konular:[Konu]) -> [String:[Konu]]{
        let kalanGunler = ["1","2"]
        var toplamDeger = 0
        var gunIcınDegerler = [Int]() // Günlere dağıtırken

        for _ in 1...kalanGunler.count{
            gunIcınDegerler.append(0)
        }


        for t in konular{
            toplamDeger = toplamDeger + t.konuDegeri
        }

        var üstSınır = Double(Double(toplamDeger)/Double(kalanGunler.count)).rounded(.up)

        var newDict = [String:[Konu]]()

        var gunicinsayılan = Int()

        let reducedArray = konular.reduce(into: [[Konu]]()) { result, current in
            guard var last = result.last else { result.append([current]); return }
            if last.reduce(0, { $0 + $1.konuDegeri }) < Int(üstSınır) {
                print("üstSınır:",üstSınır)
                last.append(current)

                result[result.count - 1] = last



            } else{
                result.append([current])
            }
        }

        let reducedArr = konular.reduce(into: [[Konu]]()) { (res, current) in
            var counter = 0
            guard var first = res.first else { res.append([current]); return }
            if first.reduce(0, { $0 + $1.konuDegeri }) < Int(üstSınır){

                first.append(current)

                res[res.count - 1] = first
            }else{
                res.append([current])
            }
        }
        var replacingTotal = [Int]()

        for i in 0...reducedArray.count-1{
            replacingTotal.append(0)
        }
        var toplam = 0
        for (i,element) in reducedArray.enumerated(){
            for k in element{
                toplam = toplam + k.konuDegeri
                replacingTotal[i] = toplam
                toplam = 0
            }
        }




        var final: [(String, [Konu])] = []


        if kalanGunler.count >= reducedArr.count{
            for i in 0...min(kalanGunler.count, reducedArr.count)-1 { //If the count aren't equal, what to do with the left values?
                print(min(kalanGunler.count, reducedArray.count))
                print(i)
                final.append((kalanGunler[i], reducedArr[i]))
            }
        }else{
            //Kalan gün az, konu çok.
            for i in 0...kalanGunler.count-1 {

                final.append((kalanGunler[i], reducedArr[i]))



            }


        }







//        for gun in (0...kalanGunler.count-1){
//            /// GÜNÜ ELE ALDIK
//            gunicinsayılan = gunIcınDegerler[gun]
//
//            for konu in konular{  /// KONUYU ELE ALDIK 4 konu, 4 kere dönecekk
//                if gunicinsayılan == 0 {
//
//
//                    if konu.konuDegeri >= Int(üstSınır){
//                        newDict["\(kalanGunler[gun])"] = [konu]
//                        gunicinsayılan = gunicinsayılan + konu.konuDegeri
//
//                        gunIcınDegerler[gun] = gunicinsayılan
//                        gunicinsayılan = 0
//
//                    }else if konu.konuDegeri < Int(üstSınır){
//                        newDict["\(kalanGunler[gun])"] = [konu]
//                        gunicinsayılan = gunicinsayılan + konu.konuDegeri
//                        gunIcınDegerler[gun] = gunicinsayılan
//                        gunicinsayılan = 0
//
//                    }
//                }else{
//                    if konu.konuDegeri >= Int(üstSınır){
//                        newDict["\(kalanGunler[gun])"] = [konu]
//
//                    }else if konu.konuDegeri < Int(üstSınır){
//                        newDict["\(kalanGunler[gun])"] = [konu]
//
//                    }
//
//                }
//            }
//
//
//
//
//
//        }



        let deadline = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            print(replacingTotal)
            print("Final: \(final)")
            for i in final{
                for k in i.1{
                    print(k.konuAdi,"--->>",k.konuDegeri)
                    
                }
            }

        }



        return newDict


    }

    //MARK:- GUN SAYISINA GÖRE PROGRAM OLUŞTURMA
    func gunSayisinaGoreProgramOlustur(olusturulacakGun:Int=7,ders:Ders,haftalikDers:Double)->[Konu]{
        ///DATE SOKULACAK eğer date == monday ise haftalık else ise gün sayısı kadar alınacak...

        var total = 0.0

        var haftalikKonular = [Konu]()
        var haftalikDerss = haftalikDers/Double(olusturulacakGun)


        let sorted = ders.konular.sorted(by: {$0.0 < $1.0 } )
        for konu in sorted{
            for t in konu.value{
                if (total<=haftalikDers) && (Double(t.konuDegeri) <= haftalikDers*1.5){
                    ///Örnek haftalık:5, total 3, yeni:3 ->6

                    print("11")
                    if total > haftalikDers*1.3{
                        //HaftalıkDerstenFazlaAldiniz
                        if total > haftalikDers*1.7{



                        }else if total <= haftalikDers*1.7{
                            haftalikKonular.append(t)
                            total = total + Double(t.konuDegeri)


                        }

                    }else if total <= haftalikDers*1.3{

                        haftalikKonular.append(t)
                        total = total + Double(t.konuDegeri)


                    }


                }else if (Double(t.konuDegeri)>(haftalikDers*1.3)) && (haftalikKonular.count==0){
                    haftalikKonular.append(t)
                    total = total + Double(t.konuDegeri)
                    print("3.")
                }
            }
        }
        print("*************************")
        print("haftalıkKonuSayisi",ders.ad,haftalikKonular.count)
        print("*************************")
        total = 0

        return haftalikKonular
    }

    //MARK:-DERSLERİN VE ALTKONULARIN TOPLAM DEĞERİ

    func kalanDersDegeriniAl(ders:Ders) -> Double{
        var mTotal = Double()
        for i in ders.konular.values{
            for j in i{
                mTotal += Double(j.konuDegeri)
            }
        }
        return mTotal
    }

    func BölümDegeriAl(ders: Ders) -> Double{
        var kalanGun = Takvim().sinavaKalanGun()
        
        var kalanDersDegeri = kalanDersDegeriniAl(ders: ders)
        var t = Double(kalanDersDegeri/kalanGun)
        return t
    }


    
    //MARK:-MOTORCALİSTİR

    func motorCalistir(){

        let matBolum = BölümDegeriAl(ders: tytMatematik)
        let geoBolum = BölümDegeriAl(ders: geometri)
        let paragrafBolum = BölümDegeriAl(ders: paragraf)
        let türkBölüm = BölümDegeriAl(ders: Türkçe)

        var kalanGun = Takvim().sinavaKalanGun()
        print("KalanGün->>",kalanGun)
        let haftaninKalanGunleri = HaftanınKalanGunleri()

        if haftaninKalanGunleri.count == 7{
            kalanGun=(kalanGun/7)
        }else {
            kalanGun=(kalanGun/Double(haftaninKalanGunleri.count))
        }
        var geo = gunSayisinaGoreProgramOlustur(olusturulacakGun: 7, ders: geometri, haftalikDers: geoBolum)
        var mat = gunSayisinaGoreProgramOlustur(olusturulacakGun: 7, ders: tytMatematik, haftalikDers: matBolum)

        var tr = gunSayisinaGoreProgramOlustur(olusturulacakGun: 7, ders: Türkçe, haftalikDers: türkBölüm)
        var pr = gunSayisinaGoreProgramOlustur(olusturulacakGun: 7, ders: paragraf, haftalikDers: paragrafBolum)

        
        var newArr = [Konu]()

        var array = [geo,mat,tr,pr]
        for i in array{
            for t in i{
                DispatchQueue.main.async {
                    newArr.append(t)
                }
            }
        }


        DispatchQueue.main.async {
            print(self.A(konular: newArr))

        }


    }





}
//MARK:-DERS CLASSI
class Ders{

    var ad:String
    var konular:[String:[Konu]]

    init(ad: String, konular: [String:[Konu]]) {
        self.ad = ad
        self.konular = konular
    }

}

class myView: UIView{

    var mview = UIView()


}

//MARK:-KONU CLASSI
class Konu {
    var id:Int
    var konuAdi: String
    var konuDegeri: Int

    init(id:Int,konuAdi:String,konuDegeri:Int) {
        self.id = id
        self.konuAdi = konuAdi
        self.konuDegeri = konuDegeri
    }
}

//MARK: -VARIABLES

//var ders = Ders(ad: "Tarih", konular: ["01Tarih ve Zaman":[Konu(id: 0, konuAdi: "Tarihin Tanımı ve Kapsamı", konuDegeri: 1),Konu(id: 0, konuAdi: "Tarihin Diğer Bilim Dalları ile İlişkisi", konuDegeri: 3)],"02İnsanlığın İlk Dönemleri":[Konu(id: 0, konuAdi: "Yazının İcadı", konuDegeri: 1),Konu(id: 0, konuAdi: "İlk Çağ Medeniyet Havzaları", konuDegeri: 2),Konu(id: 0, konuAdi: "Göçler", konuDegeri: 2)],"03İlk ve Orta Çağ'da Türk Dünyası":[Konu(id: 0, konuAdi: "İslamiyet Öncesi Türkler", konuDegeri: 4),Konu(id: 0, konuAdi: "Kavimler Göçü", konuDegeri: 4),Konu(id: 0, konuAdi: "İslamiyet Öncesi Türk Devletleri", konuDegeri: 3)],"İslam Medeniyetinin Doğuşu":[Konu(id: 0, konuAdi: "İslamın Doğuşu", konuDegeri: 1),Konu(id: 0, konuAdi: "Hz.Muhammed ve Dört Halife", konuDegeri: 3),Konu(id: 0, konuAdi: "Emeviler", konuDegeri: 1), Konu(id: 0, konuAdi: "Abbasiler", konuDegeri: 1),Konu(id: 0, konuAdi: "İslam Alimleri", konuDegeri: 1)],"İlk Türk-İslam Devletleri":[Konu(id: 0, konuAdi: "Türklerin İslamiyete Geçişi ve Kabul Etmelerindeki Etkenler", konuDegeri: 2),Konu(id: 0, konuAdi: "Büyük Selçuklu Devleti", konuDegeri: 3),Konu(id: 0, konuAdi: "Karahanlılar-Gazneliler", konuDegeri: 2),Konu(id: 0, konuAdi: "Diğer Türk-İslam Devletleri", konuDegeri: 4)],"Selçuklular":[Konu(id: 0, konuAdi: "Türklerden Önce Anadolu", konuDegeri: 1),Konu(id: 0, konuAdi: "İlk Türk Beylikleri", konuDegeri: 3),Konu(id: 0, konuAdi: "Anadolu Selçuklu Devleti ve Uygarlığı", konuDegeri: 4), Konu(id: 0, konuAdi: "İkinci Türk Beylikleri Dönemi", konuDegeri: 2)],"Beylikten Devlete Osmanlı":[Konu(id: 0, konuAdi: "Beylikten Devlete Osmanlı Siyaseti", konuDegeri: 1),Konu(id: 0, konuAdi: "Beylikten Devlete Osmanlı Medeniyeti ve Askerler", konuDegeri: 2)],"Dünya Gücü Osmanlı":[Konu(id: 0, konuAdi: "Sultan ve Osmanlı Merkez Teşkilatı", konuDegeri: 1),Konu(id: 0, konuAdi: "Osmanlı Kültür ve Uygarlığı", konuDegeri: 4),Konu(id: 0, konuAdi: "II.Mehmet (Fatih) Dönemi", konuDegeri: 4),Konu(id: 0, konuAdi: "II.Beyazıd Dönemi", konuDegeri: 2), Konu(id: 0, konuAdi: "I.Selim (Yavuz) Dönemi", konuDegeri: 3), Konu(id: 0, konuAdi: "I.Süleyman (Kanuni) Dönemi", konuDegeri: 4), Konu(id: 0, konuAdi: "Kapitülasyonlar, Stratejiler ve İlişkiler", konuDegeri: 2)],"Değişen Dünya Dengeleri":[Konu(id: 0, konuAdi: "Avusturya İlişkileri", konuDegeri: 1),Konu(id: 0, konuAdi: "İran İlişkileri", konuDegeri: 1),Konu(id: 0, konuAdi: "Lehistan ve İran İlişkileri", konuDegeri: 1),Konu(id: 0, konuAdi: "Otuz Yıl Savaşları", konuDegeri: 1),Konu(id: 0, konuAdi: "Osmanlı-Rus İlişkileri", konuDegeri: 2)],"Değişim Çağında Avrupa ve Osmanlı":[Konu(id: 0, konuAdi: "Aydınlanma Düşüncesi", konuDegeri: 2),Konu(id: 0, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>)],"Devrimler Çağı":[Konu(id: 0, konuAdi: "", konuDegeri: 1),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>)],"Denge Siyaseti":[Konu(id: 0, konuAdi: "", konuDegeri: 1),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>)],"20.Yüzyılın Başında Osmanlı":[Konu(id: 0, konuAdi: "", konuDegeri: 1),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>)],"Milli Mücadele":[Konu(id: 0, konuAdi: "", konuDegeri: 1),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>)],"Türk İnkılabı":[Konu(id: 0, konuAdi: "", konuDegeri: 1),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>),Konu(id: <#T##Int#>, konuAdi: <#T##String#>, konuDegeri: <#T##Int#>)]])

var geometri = Ders(ad: "Geometri", konular: ["Üçgenler":[Konu(id: 0, konuAdi: "Doğruda Açılar", konuDegeri: 3),Konu(id: 1, konuAdi: "Üçgende Açılar", konuDegeri: 2),Konu(id: 2, konuAdi: "Özel Üçgenler", konuDegeri: 2),Konu(id: 3, konuAdi: "Açıortay", konuDegeri: 2),Konu(id: 4, konuAdi: "Kenarortay", konuDegeri: 2),Konu(id: 5, konuAdi: "Eşlik ve Benzerlik", konuDegeri: 3),Konu(id: 6, konuAdi: "Üçgende Alan", konuDegeri: 3),Konu(id: 7, konuAdi: "Açı Kenar Bağlantıları", konuDegeri: 2),Konu(id: 8, konuAdi: "Üçgende Benzerlik", konuDegeri: 2)],"02Dörtgenler":[Konu(id: 9, konuAdi: "Genel Dörtgenler", konuDegeri: 2),Konu(id: 10, konuAdi: "Paralelkenar", konuDegeri: 2),Konu(id: 11, konuAdi: "Eşkenar", konuDegeri: 2),Konu(id: 12, konuAdi: "Dikdörtgen", konuDegeri: 2),Konu(id: 13, konuAdi: "Kare", konuDegeri: 2),Konu(id: 14, konuAdi: "Deltoid", konuDegeri: 2),Konu(id: 15, konuAdi: "Yamuk", konuDegeri: 3),Konu(id: 16, konuAdi: "Çokgenler", konuDegeri: 3)],"03Çemberler":[Konu(id: 17, konuAdi: "Çemberde Açılar", konuDegeri: 3),Konu(id: 18, konuAdi: "Çemberde uzunluk", konuDegeri: 3),Konu(id: 19, konuAdi: "Çemberin çevresi", konuDegeri: 2),Konu(id: 20, konuAdi: "Dairenin Alanı", konuDegeri: 2)],"04Analitik Geometri":[Konu(id: 21, konuAdi: "Noktanın Analitiği", konuDegeri: 5),Konu(id: 22, konuAdi: "Doğrunun Analitiği", konuDegeri: 4),Konu(id: 23, konuAdi: "Dönüşüm Geometrisi", konuDegeri: 2),Konu(id: 24, konuAdi: "Analitik Geometri", konuDegeri: 4)],"05Katı Cisimler":[Konu(id: 25, konuAdi: "Prizma", konuDegeri: 2),Konu(id: 26, konuAdi: "Silindir", konuDegeri: 4)]])



var tytMatematik = Ders(ad: "TYT Matematik", konular: ["01Temel Kavramlar":[Konu(id: 0, konuAdi: "Tek, Çift ve Ardışık Sayılar", konuDegeri: 6),Konu(id: 1, konuAdi: "Bölme-Bölünebilme", konuDegeri: 2),Konu(id: 2, konuAdi: "Asal Sayılar", konuDegeri: 1),Konu(id: 3, konuAdi: "Asal Sayılar", konuDegeri: 1),Konu(id: 4, konuAdi: "EBOB-EKOK", konuDegeri: 2),Konu(id: 5, konuAdi: "Rasyonel Sayılar", konuDegeri: 1),Konu(id: 6, konuAdi: "Üçgende Alan", konuDegeri: 3)],"02I.Dereceden Denklemler ve Eşitsizlikler":[Konu(id: 7, konuAdi: "Çözüm Kümeleri", konuDegeri: 2),Konu(id: 8, konuAdi: "Mutlak Değerli Denklemler", konuDegeri: 3),Konu(id: 9, konuAdi: "I. Dereceden 2 Bilinmeyenli Denklemler", konuDegeri: 3),Konu(id: 10, konuAdi: "Denklem ve Eşitsizlikler", konuDegeri: 3)],"03Üslü İfadeler":[Konu(id: 11, konuAdi: "Üslü İfadeler", konuDegeri: 4),Konu(id: 12, konuAdi: "Köklü İfadeler", konuDegeri: 4)],"04Problemler":[Konu(id: 13, konuAdi: "Oran-Orantı", konuDegeri: 2),Konu(id: 14, konuAdi: "Sayı-Kesir Problemleri", konuDegeri: 4),Konu(id: 15, konuAdi: "Yaş Problemleri", konuDegeri: 2),Konu(id: 16, konuAdi: "Yüzde, Kar-Zarar Problemleri", konuDegeri: 3)],"05Mantık ve Kümeler":[Konu(id: 17, konuAdi: "Mantık", konuDegeri: 2),Konu(id: 18, konuAdi: "Kümeler", konuDegeri: 3)],"06Fonksiyonlar":[Konu(id: 19, konuAdi: "Fonksiyon", konuDegeri: 2),Konu(id: 20, konuAdi: "Bileşke ve Ters Fonksiyon", konuDegeri: 4)],"07Polinomlar":[Konu(id: 21, konuAdi: "Polinomlarda işlemler", konuDegeri: 4),Konu(id: 21, konuAdi: "Polinomlarda Çarpanlara Ayırma", konuDegeri: 3)],"08II.Dereceden Denklemler":[Konu(id: 22, konuAdi: "II.Dereceden 1 Bilinmeyenli Denklemler", konuDegeri: 3),Konu(id: 23, konuAdi: "Karmaşık Sayılar", konuDegeri: 4),Konu(id: 23, konuAdi: "Kök-Katsayı ilişkisi", konuDegeri: 3)],"09Sayma ve Olasılık":[Konu(id: 24, konuAdi: "Sayma", konuDegeri: 2),Konu(id: 25, konuAdi: "Permutasyon", konuDegeri: 3),Konu(id: 25, konuAdi: "Kombinasyon", konuDegeri: 3),Konu(id: 26, konuAdi: "Binom", konuDegeri: 2),Konu(id: 27, konuAdi: "Olasılık", konuDegeri: 5)],"10Veri Analizi":[Konu(id: 28, konuAdi: "Merkezi Eğilim ve Yayılım Ölçüleri", konuDegeri: 1),Konu(id: 0, konuAdi: "Grafikler", konuDegeri: 2)]])

var paragraf = Ders(ad: "Paragraf", konular: ["01Paragraf":[Konu(id: 0, konuAdi: "Paragrafta Konu ve Ana Düşünce", konuDegeri: 2),Konu(id: 0, konuAdi: "Diyalog Tamamlama", konuDegeri: 3),Konu(id: 0, konuAdi: "Metinler Arası İlişki", konuDegeri: 4),Konu(id: 0, konuAdi: "Boşluk Tamamlama", konuDegeri: 2),Konu(id: 0, konuAdi: "Yardımcı Düşünce", konuDegeri: 3),Konu(id: 0, konuAdi: "Anlatım Biçimleri", konuDegeri: 3),Konu(id: 0, konuAdi: "Düşünceyi geliştirme yolları", konuDegeri:   3)],"02Yeni Nesil Sorular":[Konu(id: 0, konuAdi: "Yeni Nesil Paragraf Soruları", konuDegeri: 4),Konu(id: 0, konuAdi: "Felsefi Paragraf Soruları", konuDegeri: 3)]])

var Türkçe = Ders(ad: "Türkçe", konular: ["01Sözcükte Anlam":[Konu(id: 0, konuAdi: "Sözcükte Anlam", konuDegeri: 2),Konu(id: 0, konuAdi: "Sözcükte Anlam İlişkileri", konuDegeri: 2),Konu(id: 0, konuAdi: "Söz Öbeğinde Anlam", konuDegeri: 3),Konu(id: 0, konuAdi: "Deyim ve Atasözleri", konuDegeri: 2)],"02Cümlede Anlam":[Konu(id: 0, konuAdi: "Boşluk Tamamlama", konuDegeri: 2),Konu(id: 0, konuAdi: "Cümlede Anlatım özellikleri", konuDegeri: 3),Konu(id: 0, konuAdi: "Cümlede Keisnlik Yargılar", konuDegeri: 2),Konu(id: 0, konuAdi: "Cümlede Anlam", konuDegeri: 3)],"03Sözcük Türleri":[Konu(id: 0, konuAdi: "Adlar", konuDegeri: 2),Konu(id: 0, konuAdi: "Tamlamalar", konuDegeri: 3),Konu(id: 0, konuAdi: "Sıfatlar", konuDegeri: 2),Konu(id: 0, konuAdi: "Zarflar", konuDegeri: 2),Konu(id: 0, konuAdi: "Zamirler", konuDegeri: 2),Konu(id: 0, konuAdi: "Edat-Bağlaç-Ünlem", konuDegeri: 2)],"04Sözcük Türleri":[Konu(id: 0, konuAdi: "Fiilde Kip-Anlam-İlişki", konuDegeri: 2),Konu(id: 0, konuAdi: "Ek Eylem", konuDegeri: 3),Konu(id: 0, konuAdi: "Fiilimsiler", konuDegeri: 3)],"05Cümle Bilgisi":[Konu(id: 0, konuAdi: "Cümlenin Ögeleri", konuDegeri: 3),Konu(id: 0, konuAdi: "Fiilde Çatı", konuDegeri: 2),Konu(id: 0, konuAdi: "Cümle Türleri", konuDegeri: 2)],"06Ses-Yazım-Noktalama":[Konu(id: 0, konuAdi: "Ses Bilgisi", konuDegeri: 4),Konu(id: 0, konuAdi: "Yazım Kuralları", konuDegeri: 4),Konu(id: 0, konuAdi: "Noktalama İşaretleri", konuDegeri: 2)],"07Anlatım Bozuklukları":[Konu(id: 0, konuAdi: "Anlama Dayalı Anlatım Bozuklukları", konuDegeri: 3),Konu(id: 0, konuAdi: "Ses Bilgisine Dayalı Anlatım Bozuklukları", konuDegeri: 3)]])



var TümDersler = [geometri,tytMatematik,paragraf,Türkçe]
//var tytTürkçe = Ders(ad: "TYT Türkçe", konular: ["Sözcükte Anlam":["Sözcüktee Anlam","Sözcükte Anlam İlişkileri","Söz Öbeğinde Anlam","Deyim-Atasözleri-İkilemeler"],"Cümlede Anlam":["Paragraf Oluşturma","Boşluk Tamamlama","Cümlede Anlatım Özellikleri","Cümlede Kesinlik Yargıları","Cümle Birleştirme","Cümlede Anlam","Cümlede Anlam İlişkileri"],"Sözcük Türleri (Ad Soylu Sözcükler)":["Adlar","Tamlamalar","Sıfatlar","Zarflar","Zamirler","Edat-Bağlaç-Ünlem"],"Sözcük Türleri(Fiil Soylu Sözcükler)":["Fiilde Kip-Anlam-Kişi","Ek Eylem","Fiilimsiler"],"Biçim Bilgisi":["Kökler","Çekim Ekleri","Yapım Ekleri","Sözcük Yapısı"],"Cümle Bilgisi":["Cümlenin Ögeleri","Fiilde Çatı","Cümle Türleri"],"Ses-Yazım-Noktalama":["Ses Bilgisi","Yazım Kuralları","Noktalama İşaretleri"],"Anlatım Bozuklukları":["Anlama Dayalı Anlatım Bozuklukları","Dil Bilgisine Dayalı Anlatım Bozuklukları"]])


//var paragraf = Ders(ad: "Paragraf", konular: ["Paragraf" : ["Paragrafta Konu ve Ana Düşünce","Diyalog Tamamlama","Metinler Arası İlişki","Boşluk Tamamlama","Yardımcı Düşünce","Anlatım Biçimleri","Düşünceyi Geliştirme Yolları"],"Yeni Nesil Paragraf Soruları":["Yeni Nesil Paragraf Soruları","Felsefi Paragraf Soruları"]])






// var tytMat = Ders(ad: "TYT Matematik", konular: ["Temel Kavramlar":["Tek, Çift ve Ardışık Sayılar","Basamak Kavramı","Bölme ve Bölünebilme","Asal Sayılar","EBOB-EKOK","Rasyonel Sayılar"],"I. Dereceden Denklemler ve Eşitsizlikler":["Çözüm Kümeleri","Mutlak Değerli Denklemler","I. Dereceden 2 Bilinmeyenli Denklemler","Denklem ve Eşitsizlikler"],"Üslü İfadeler":["Üslü İfadeler","Köklü İfadeler"],"Problemler":["Oran ve Orantı","Sayı-Kesir Problemleri","Yaş Problemleri","Yüzde, Kar-Zarar Problemleri","Karışım Problemleri","Hareket Problemleri","Emek Problemleri","Yeni Nesil Problemler"],"Mantık ve Kümeler":["Mantık","Kümeler","Alt Küme ve Eşit Küme","Birleşim, Kesişim, Fark ve Tümlemeler","Kartezyen Çarpım"],"Fonksiyonlar":["Fonksiyon Kavramı","Bileşke ve Ters Fonksiyonlar"],"Polinomlar":["Polinom Kavramı ve Polinomlarla İşlemler","Polinomların Çarpanlara Ayrılması"],"II.Dereceden Denklemler":["II.Dereceden Bir Bilinmeyenli Denklemler","Karmaşık Sayılar","Kök-Katsayı İlişkisi"],"Sayma ve Olasılık":["Sayma","Permütasyon","Kombinasyon","Pascal Üçgeni ve Binom","Olasılık"],"Veri Analizi":["Merkezi Eğilim ve Yayılım Ölçüleri","Grafikler"]])

//var geometri = Ders(ad: "Geometri", konular: ["Üçgenler":["Doğruda Açılar","Üçgende Açılar","Özel Üçgenler","Açıortay","Kenarortay","Eşlik ve Benzerlik","Üçgende alan","Açı Kenar Bağıntıları","Üçgeende Merkezler"],"Dörtgenler":["Genel Dörtgenler","Paralelkenar","Eşkenar Dörtgen","Dikdörtgen","Kara","Deltoid","Yamuk","Çokgenler"],"Çemberler":["Çemberde Açılar","Çemberde Uzunluk","Çemberin Çevresi","Dairenin Alanı"],"Analitik Geomeetri":["Noktanın Analitiği","Doğrunun Analitiği","Dönüşüm Geometrisi","Analitik Geometri"],"Katı Cisimler":["Prizma","Silindir","Piramit","Koni","Küre"],"Çember Analiliği":["Çember Analitiği"]])

//MARK: - EXTENSIONS
extension Date {
    func toDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let myString = formatter.string(from: self)

        return myString
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}
extension Date {
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
        let a = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = Locale.current

        print(dateFormatter.string(from: a))
        return a
    }
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}



