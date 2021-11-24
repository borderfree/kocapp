//
//  Gruplar.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 30.04.2021.
//

import Foundation

class Grup{

    var ad: String //grup adı
    var aciklama:String // açıklama
    var grupId: Int // grup id'si
    var users: [Int] // grup üyeleri

    init(ad:String,aciklama:String,grupId:Int,users:[Int]) {
        self.ad = ad
        self.aciklama = aciklama
        self.grupId = grupId
        self.users = users
    }

}







