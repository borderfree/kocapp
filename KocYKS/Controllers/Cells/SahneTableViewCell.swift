//
//  SahneTableViewCell.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 30.04.2021.
//

import UIKit
import Firebase
import Spring
class SahneTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var goruntu: UIImageView!
    @IBOutlet weak var paylasanAdiLbl: UILabel!
    @IBOutlet weak var begenBtn: UIButton!
    @IBOutlet weak var kaydetBtn: UIButton!
    @IBOutlet weak var aciklamaLbl: UILabel!
    @IBOutlet weak var dersAdiLbl: UILabel!
    @IBOutlet weak var konuAdiLbl: UILabel!
    @IBOutlet weak var tarih: UILabel!
    @IBOutlet weak var turu: UILabel!

    var postId:String?


    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    var isLiked = false
    lazy var database = Database.database().reference()
    lazy var firestore = Firestore.firestore()

    @IBAction func likeAction(_ sender: UIButton) {
        if isLiked == true{

            let image = UIImage(named: "love")?.withTintColor(.mor)
            self.database.child("Spotlight").child(self.postId!).child("likers").child(profilim.username).removeValue()


            begenBtn.setImage(image, for: .normal)
            isLiked = false

        }else{
            let image = UIImage(named: "filled_love")?.withTintColor(.mor)
            begenBtn.setImage(image, for: .normal)
            self.database.child("Spotlight").child(self.postId!).child("likers").child(profilim.username).setValue(true)
            
            firestore.collection("kullanicilar").document(profilim.username).setData([ "likes" : [ self.postId : true ] ],merge: false)
            print(isLiked)
            isLiked = true

        }


    }


    @IBAction func downloadAct(_ sender: UIButton) {
    }







    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
