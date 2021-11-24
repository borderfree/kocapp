//
//  FirestoreManager.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 19.06.2021.
//

import Foundation
import FirebaseFirestore
class FirestoreManager {
    private init(){}


    static let shared = FirestoreManager()

    private let database = Firestore.firestore()
    private lazy var reference = database.collection("Spotlight")

    func save(_ spotlight: Spotlight, completion: @escaping (Result<Bool, NSError>) -> Void){
        reference.addDocument(data: ["image": spotlight.image,
                                     "owner": spotlight.owner,
                                     "postId": spotlight.postId,
                                     "race":spotlight.race,
                                     "statement":spotlight.statement ?? "",
                                     "subtopic":spotlight.subtopic,
                                     "id":reference.document().documentID,
                                     "timestamp":spotlight.timestamp,
                                     "topic":spotlight.topic]) { err in
            if let err = err{
                print(err)
                completion(.failure(err as NSError))
            }else{
                completion(.success(true))
            }
        }
    }

//    func listen(completion: @escaping ([Spotlight]) -> Void){
//        reference.addSnapshotListener { snapshot, err in
//            guard let snap = snapshot else { return }
//            let docs = snap.documents
//            var spot = [Spotlight]()
//            for doc in docs{
//                let data = doc.data()
//                let s = Spotlight(snapShot: <#T##DataSnapshot#>, completionHandler: <#T##(Spotlight) -> Void#>)
//            }
//        }
//    }


}




