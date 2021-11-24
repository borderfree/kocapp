
import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreData



class Takvim{

    let sinavGunu = "2022-06-22" // SINAV GÜNÜ

    let defaults = UserDefaults.standard // USER DEFAULTS

    // Sınava Kalan günleri al
    func sinavaKalanGun() -> Double{

        let calendar = Calendar.current

        let firstDate = Date()


        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"


        let secondDate = dateFormatter.date(from: sinavGunu)

        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate!)

        let components = calendar.dateComponents([Calendar.Component.day], from: date1, to: date2)
        let kalan = Double(components.day!)

        return kalan
    }
    // Haftanın geri kalan günlerini alır.
    func haftanınKalanGunleri()->[String]{
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


    func kalanDersDegeriniAl(ders:Ders) -> Double{
        var mTotal = Double()
        for i in ders.konular.values{
            for j in i{
                mTotal += Double(j.konuDegeri)
            }
        }
        return mTotal
    }


    //Her hafta çağırılacak, her ders için ayrı çağırılacak.
    func hesap(ders: Ders)->Double{
        let a = sinavaKalanGun() // Sinava kalan gun
        let b = kalanDersDegeriniAl(ders: ders) //Ders değeri
        let c = Double(b/a) ///Günlük çözmesi gereken Değer
        return 7*c /// Çalışması beklenen gün sayısı
    }

    func toplamKonu(olusturulacakGun:Int=7,ders:Ders,haftalikDers:Double)->[Konu]{
        var total = 0.0
        var haftalikKonular = [Konu]()

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

                }
            }
        }
        total = 0

        return haftalikKonular
    }




    func konularinHaftayaDagitilmasi(konular:[Konu])->[String:[Konu]]{
        var final = [String:[Konu]]()

        var kalanGunler = haftanınKalanGunleri()

        let sorted = konular.sorted(by: {$0.konuDegeri < $1.konuDegeri })
        var konuToplam = 0
        for i in 0...sorted.count-1{
            konuToplam = konuToplam + sorted[i].konuDegeri
        }
        var gunDegerlik = [Double]()
        var bolumSonucu = Double(konuToplam/kalanGunler.count).rounded(.down)


        let reducedArray = sorted.reduce(into: [[Konu]]()) { result, current in
            guard var last = result.last else { result.append([current]); return }
            print(bolumSonucu)
            print()
            if last.reduce(0, { $0 + $1.konuDegeri }) <= Int(bolumSonucu)-10 {
                last.append(current)
                result[result.count - 1] = last
            } else {
                result.append([current])
            }
        }

        for i in 0...reducedArray.count-1{ //4 değer
            if final[kalanGunler[i%3]] == nil{
                final.updateValue(reducedArray[i%3], forKey: kalanGunler[i%3])
            }else{
                let first = final[kalanGunler[i%3]]!
                
                var last = first+reducedArray[i]


                final.updateValue(last, forKey: kalanGunler[i%3])

            }

        }

//        for i in 0..<min(kalanGunler.count, reducedArray.count){
//            final.updateValue(reducedArray[i], forKey: kalanGunler[i])
//        }

        enum Weekday: Int {
            case Pazartesi = 0, Salı = 1, Çarşamba = 2, Perşembe = 3, Cuma=4, Cumartesi=5, Pazar=6
        }


        final.sorted { (element0, element1) -> Bool in
            guard let day0 = element0.key as? Weekday, let day1 = element1.key as? Weekday else {
                return false
            }
            return day0.hashValue < day1.hashValue
        }

        


        return final
    }

    func Run()->[Konu]{
        let matBolum = toplamKonu(ders: tytMatematik, haftalikDers: hesap(ders: tytMatematik))
        let trBolum = toplamKonu(ders: paragraf, haftalikDers: hesap(ders: paragraf))
        let geoBolum = toplamKonu(ders: geometri, haftalikDers: hesap(ders: geometri))
        let trrBolum = toplamKonu(ders: Türkçe, haftalikDers: hesap(ders: Türkçe))

        return matBolum+trBolum+geoBolum+trrBolum
    }
    
}








