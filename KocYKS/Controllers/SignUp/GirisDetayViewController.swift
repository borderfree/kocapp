//
//  GirisDetayViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 19.12.2020.
//

import UIKit
import Spring
import SearchTextField
import Firebase
import UIFontComplete
import SwiftEntryKit
import FirebaseFirestoreSwift
import CoreData
class GirisDetayViewController: UIViewController {


    //MARK: -VARIABLES
    var db: Firestore!
    @IBOutlet weak var v1: SpringView!
    @IBOutlet weak var v2: SpringView!
    @IBOutlet weak var v3: SpringView!
    @IBOutlet weak var v4: SpringView!
    @IBOutlet weak var v5: SpringView!
    @IBOutlet weak var tamamlaBtn: SpringButton!
    @IBOutlet weak var kacSaatTF: SearchTextField!
    @IBOutlet weak var dersTF: SearchTextField!
    @IBOutlet weak var bolumTF: SearchTextField!


    var alani = ""
    var ogrenim = ""
    var mmail = String()
    var ppass = String()
    var aad = String()
    var ssoyad = String()
    var saatler = ["0-1","1-2","2-3","3-4","4-5","5-6","+7"]


    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        tfAyarlama()
        animationViews()
        
    }


    //MARK: - FUNCTIONS
    
    func kayitTamamla(){
        FirebaseAuthManager.shared.registerUserWith(email: mmail, password: ppass) { (authRes, err) in
            let profil = Profil(ad: self.aad, soyad: self.ssoyad, mail: self.mmail, pass: self.ppass, username: Auth.auth().currentUser!.uid, dersSaati: self.kacSaatTF.text!, sevdigiDers: self.dersTF.text!, alan: self.alani, ogrenim: self.ogrenim,istedigiBolum:self.bolumTF.text!, premium: false)
            self.db.collection("kullanicilar").document(Auth.auth().currentUser!.uid).setData([
                "ad":profil.ad,
                "soyad":profil.soyad,
                "mail": profil.mail,
                "pass": profil.pass,
                "username": profil.username,
                "istedigiBolum": "istedigiBolum",
                "dersSaati": profil.dersSaati,
                "sevdigiDers":profil.sevdigiDers,
                "alan":profil.alan,
                "ogrenim":profil.ogrenim,
                "premium":profil.premium
            ]) { (err) in
                if err != nil{
                    print("oppps!")
                }else{
                    print("success")
                }
            }
            let dispatchGroup = DispatchGroup()

            if let _ = authRes {
                dispatchGroup.enter()
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

                let manageContent = appDelegate.persistentContainer.viewContext

                let userEntity = NSEntityDescription.entity(forEntityName: "Profilim", in: manageContent)!

                let users = NSManagedObject(entity: userEntity, insertInto: manageContent)

                users.setValue(profil.ad, forKeyPath: "ad")
                users.setValue(profil.alan, forKeyPath: "alan")
                users.setValue(profil.istedigiBolum, forKeyPath: "istedigiBolum")
                users.setValue(profil.dersSaati, forKeyPath: "dersSaati")
                users.setValue(profil.mail, forKeyPath: "mail")
                users.setValue(profil.ogrenim, forKeyPath: "ogrenim")
                users.setValue(profil.pass, forKeyPath: "pass")
                users.setValue(profil.sevdigiDers, forKeyPath: "sevdigiDers")
                users.setValue(profil.soyad, forKeyPath: "soyad")
                users.setValue(profil.username, forKeyPath: "username")
                users.setValue(profil.premium, forKeyPath: "premium")


                let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "Profilim")


                do{
                    try manageContent.save()

                    let result = try manageContent.fetch(fetchData)

                    for data in result as! [NSManagedObject]{

                        let a = data.value(forKeyPath: "ad") as! String
                        let b = data.value(forKeyPath: "alan") as! String
                        let c = data.value(forKeyPath: "soyad") as! String
                        let f = data.value(forKeyPath: "username") as! String
                        let g = data.value(forKeyPath: "dersSaati") as! String
                        let h = data.value(forKeyPath: "mail") as! String
                        let k = data.value(forKeyPath: "sevdigiDers") as! String
                        let j = data.value(forKeyPath: "istedigiBolum") as! String
                        let l = data.value(forKeyPath: "ogrenim") as! String
                        let m = data.value(forKeyPath: "premium") as! Bool
                        let q = data.value(forKeyPath: "pass") as! String


                        profilim = Profil(ad: a, soyad: c, mail: h, pass: q, username: f, dersSaati: g, sevdigiDers: k, alan: b, ogrenim: l, istedigiBolum: j, premium: m)


                        dispatchGroup.leave()

                    }
                }catch let error as NSError {

                    print("could not save . \(error), \(error.userInfo)")
                }

            }

                (UIApplication.shared.delegate! as! AppDelegate).goTabbar()


        }
    }

    func tfAyarlama(){
        dersTF.filterStrings(derslerArray)
        kacSaatTF.filterStrings(saatler)
    }
    func animationViews(){

        let views = [v1,v2,v3,v4,v5]
        var delay = 1.0

        for i in views{
            i!.delay = CGFloat(delay + 0.2)
            delay += 0.2
        }
        for a in 0...4{

            if a % 2 == 0{
                views[a]!.animation = "fadeInRight"
            }else{
                views[a]!.animation = "fadeInLeft"
            }
        }

        DispatchQueue.main.async {
            for i in views{
                i!.animate()
            }
        }



    }


    //MARK: - ACTIONS


    @IBAction func kaydiTamamlaAct(_ sender: UIButton) {
        kayitTamamla()
    }





    @IBAction func alanAct(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            alani = "Sayısal"
        case 1:
            alani = "Eşit Ağırlık"
        case 2:
            alani = "Sözel"
        case 3:
            alani = "Dil"
        default:
            alani = ""
        }
    }

    @IBAction func mezunAct(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            ogrenim = "Okuyorum"

        case 1:
            ogrenim = "Mezunum"

        default:
            ogrenim = ""
        }
    }
    


}



// MARK: - EXTENSIONS
extension UIViewController{
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


}

extension UIViewController{
    func kontrol(text:String, array:[String], uyarı:String){
        if array.contains(text){

        }else{
            print("içermiyor.")
        }
    }
}
