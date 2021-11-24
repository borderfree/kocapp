//
//  BilgiKartlari.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 19.12.2020.
//

import Foundation
import UIKit
import FirebaseDatabase
class DersKartları{

    enum arkaPlan {
        case mor, pembe, yesil, ocean, expresso, water, dusk, mavi

        func donusum()->[UIColor]{
            switch self {
                case .mor:
                    return [UIColor(hex: "#654ea3") ,UIColor(hex: "#eaafc8")]
                case .pembe:
                    return [UIColor(hex: "#ddd6f3") ,UIColor(hex: "#faaca8")]
                case .yesil:
                    return [UIColor(hex: "#00C9FF") ,UIColor(hex: "#92FE9D")]
                case .ocean:
                    return [UIColor(hex: "#373B44") ,UIColor(hex: "#4286f4")]
                case .expresso:
                    return [UIColor(hex: "#ad5389") ,UIColor(hex: "#3c1053")]
                case .water:
                    return [UIColor(hex: "#74ebd5") ,UIColor(hex: "#ACB6E5")]
                case .dusk:
                    return [UIColor(hex: "#2C3E50") ,UIColor(hex: "#FD746C")]
                case .mavi:
                    return [UIColor(hex: "#6190E8") ,UIColor(hex: "#A7BFE8")]
            }
        }
    }


    var bg:String
    var ders:String
    var konu:String
    var baslik:String?
    var bilgi:String?
    var imageUrl: String?
    var r: [UIColor]?

    init?(snapshot:DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:Any]

        guard let baslik = snapshotValue["baslik"] as? String, let bilgi = snapshotValue["bilgi"] as? String, let url = snapshotValue["imageUrl"] as? String else {
            return nil
        }
        self.bg = snapshotValue["renk"] as! String
        switch bg {
            case "0":
                self.r = arkaPlan.mor.donusum()
            case "1":
                self.r = arkaPlan.pembe.donusum()
            case "2":
                self.r = arkaPlan.yesil.donusum()
            case "3":
                self.r = arkaPlan.ocean.donusum()
            case "4":
                self.r = arkaPlan.expresso.donusum()
            case "5":
                self.r = arkaPlan.water.donusum()
            case "6":
                self.r = arkaPlan.dusk.donusum()
            case "7":
                self.r = arkaPlan.mavi.donusum()
            default:
                self.r = [UIColor.white,UIColor.white]
        }
        self.baslik = baslik
        self.bilgi = bilgi
        self.imageUrl = url
        self.ders = snapshotValue["ders"] as! String
        self.konu = snapshotValue["konu"] as! String
    }
}

struct TT {
    let A:DersKartları
    let t:String
    let b:String
    init() {
        if let a = A.baslik {
            self.t = a
        }else{
            self.t = ""
        }

        if let a = A.baslik {
            self.t = a
        }else{
            self.t = ""
        }

        if let a = A.baslik {
            self.t = a
        }else{
            self.t = ""
        }
        
    }




}





public struct Kartlar: Codable{
    let konu:String
    let baslik:String?
    let bilgi:String
    let resim:String?
}




