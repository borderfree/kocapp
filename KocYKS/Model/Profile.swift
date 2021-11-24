//
//  Profil.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 19.12.2020.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import UIKit



public class Profil:Codable{

    var ad:String
    var soyad:String
    var mail:String
    var pass:String
    var username:String
    var dersSaati:String
    var sevdigiDers:String
    var alan:String
    var ogrenim:String
    var istedigiBolum:String
    var premium:Bool


    init(ad:String,soyad:String,mail:String,pass:String,username:String,dersSaati:String,sevdigiDers:String,alan:String,ogrenim:String,istedigiBolum:String,premium:Bool) {
        

        self.ad=ad
        self.soyad=soyad
        self.mail=mail
        self.pass=pass
        self.username=username
        self.dersSaati=dersSaati
        self.sevdigiDers=sevdigiDers
        self.alan = alan
        self.ogrenim = ogrenim
        self.istedigiBolum = istedigiBolum
        self.premium = premium
    }

}




public var profilim: Profil!






class FirstLog{
    var baslik:String
    var yazi:String
    var img:String
    init(baslik:String,yazi:String,img:String) {
        self.baslik = baslik
        self.yazi = yazi
        self.img = img
    }
}


var g1 = FirstLog(baslik: "1.syf", yazi: "1.yazı", img: "1.img")
var g2 = FirstLog(baslik: "2.sy", yazi: "2.yazı", img: "2.img")
var g3 = FirstLog(baslik: "3.sy", yazi: "3.yz", img: "3.img")
var g4 = FirstLog(baslik: "4.sy", yazi: "3.yz", img: "3.img")
var g5 = FirstLog(baslik: "5.sy", yazi: "3.yz", img: "3.img")
var g6 = FirstLog(baslik: "6z.sy", yazi: "3.yz", img: "3.img")
var girisArray:[FirstLog] = [g1,g2,g3,g4,g5,g6]




var derslerArray = ["Türkçe","Tarih","Coğrafya","Felsefe","Din Kültürü","Matematik","Geometri","Fizik","Kimya","Biyoloji","İngilizce","Arapça"]


public var iller = ["Adana", "Adıyaman", "Afyon", "Ağrı", "Amasya", "Ankara", "Antalya", "Artvin",
"Aydın", "Balıkesir", "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale",
"Çankırı", "Çorum", "Denizli", "Diyarbakır", "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir",
"Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Isparta", "Mersin", "İstanbul", "İzmir",
"Kars", "Kastamonu", "Kayseri", "Kırklareli", "Kırşehir", "Kocaeli", "Konya", "Kütahya", "Malatya",
"Manisa", "Kahramanmaraş", "Mardin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Rize", "Sakarya",
"Samsun", "Siirt", "Sinop", "Sivas", "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Şanlıurfa", "Uşak",
"Van", "Yozgat", "Zonguldak", "Aksaray", "Bayburt", "Karaman", "Kırıkkale", "Batman", "Şırnak",
"Bartın", "Ardahan", "Iğdır", "Yalova", "Karabük", "Kilis", "Osmaniye", "Düzce"]



extension UserDefaults: ObjectSavable{
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }

    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }


}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}
enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"

    var errorDescription: String? {
        rawValue
    }
}
import CoreData

