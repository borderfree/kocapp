//
//  Sahne.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 30.04.2021.
//

import Foundation
import Firebase

class Spotlight{
    var postId:String
    var owner: String
    var image: String?
    var likers = [String]()
    var timestamp: Int
    var topic: String
    var subtopic:String
    var statement:String
    var race: Int
    var toImg: UIImage?

    var storage = Storage.storage()

    init(document: QueryDocumentSnapshot, completionHandler: @escaping (Spotlight) -> Void) {

        self.postId = document.documentID
        let data = document.data()
        self.owner = data["owner"] as! String
        self.image = data["image"] as? String
        self.timestamp = data["timestamp"] as! Int
        self.topic = data["topic"] as! String
        self.subtopic = data["subtopic"] as! String
        self.statement = data["statement"] as! String
        self.race = data["race"] as! Int

//        _ = storage.reference(forURL: image!).getData(maxSize: 1*1000*1000) { data, err in
//            if let err = err{
//                print(err)
//            }else{
//
//            }
//        }
        _ = storage.reference(forURL: image!).downloadURL(completion: { url, err in
            if let err = err{
                print(err)
            }else{
                let data = try! Data(contentsOf: url!)
                self.toImg = UIImage(data: data)

            }

        })
        
    }


}



