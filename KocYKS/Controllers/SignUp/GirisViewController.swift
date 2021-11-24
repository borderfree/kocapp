//
//  GirisViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 19.12.2020.
//

import CoreData
import UIKit
import DTTextField
import FirebaseAuth
import Spring
import FirebaseFirestoreSwift
import FirebaseFirestore
class GirisViewController: UIViewController {

    // MARK: -VARIABLES
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var adTF: DTTextField!
    @IBOutlet weak var mailTF: DTTextField!
    @IBOutlet weak var sifreTF: DTTextField!
    @IBOutlet weak var usernameTF: DTTextField!
    @IBOutlet weak var devamBtn: UIButton!
    @IBOutlet weak var hesabımVarBtn: UIButton!
    @IBOutlet weak var girisPostaTF: DTTextField!
    @IBOutlet weak var girisSifreTF: DTTextField!
    @IBOutlet weak var girisYapBtn: SpringButton!
    @IBOutlet weak var hesabımView: SpringView!




    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage("anaP")
        hesabımView.isHidden = true
        hesapViewSet()




    }

    //MARK: -FUNCTIONS
    func hesapViewSet(){
        self.hesabımView.backgroundColor = UIColor(patternImage: UIImage(named: "anaP")!)
        self.girisYapBtn.layer.cornerRadius = 5
        if girisSifreTF.text!.count <= 5{
            girisSifreTF.errorMessage = "Şifreniz en az 6 haneli olmalıydı"
        }else if girisSifreTF.text! == ""{
            girisSifreTF.errorMessage = "Şifrenizi yazınız"
        }else if girisPostaTF.text == ""{
            girisSifreTF.errorMessage = "E-Postanızı yazmadınız"
        }
    }
    func validateDatalar() -> Bool{
        guard !adTF.text!.isEmptyStr else {
            adTF.showError(message: "İsminizi yazın.")
            return false
        }
        guard adTF.text!.components(separatedBy: " ").count > 1 else{
            
            adTF.showError(message: "Ad soyad şeklinde yazın.")
            return false
        }
        guard !mailTF.text!.isEmptyStr else {
            mailTF.showError(message: "E-posta adresinizi yazın.")
            return false
        }
        guard !sifreTF.text!.isEmptyStr else {
            sifreTF.showError(message: "Şifrenizi yazın.")
            return false
        }
        guard !usernameTF.text!.isEmptyStr else {
            usernameTF.showError(message: "Kullanıcı adınızı yazın.")
            return false
        }
        guard sifreTF.text!.count >= 6 else{
            sifreTF.showError(message: "Şifreniz 6 haneden fazla olmalı.")
            return false
        }
        guard mailTF.text!.isValidEmail else {
            mailTF.showError(message: "Geçerli bir mail adresi girin.")
            return false
        }

        return true
    }

    func kayitEkrana(){
        if validateDatalar(){

            let vc = storyboard?.instantiateViewController(identifier: "GirisDetayViewController") as! GirisDetayViewController
            vc.modalPresentationStyle = .fullScreen


            vc.ppass = sifreTF.text!
            vc.mmail = mailTF.text!

            let adsoyad = adTF.text!
            let soyad = (adTF.text!.components(separatedBy: " ").last)!
            let ad = adsoyad.replacingOccurrences(of: soyad, with: "")
            vc.aad = ad
            vc.ssoyad = soyad
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)




        }
    }








    //MARK: -ACTIONS

    @IBAction func DevamAct(_ sender: UIButton) {
        kayitEkrana()
    }

    @IBAction func hesabımVar(_ sender: UIButton) {
        hesabımView.isHidden = false
    }
    @IBAction func girisAct(_ sender: UIButton) {


        guard let mail = girisPostaTF.text, let pass = girisSifreTF.text else{
            return
        }

        if mail.isValidEmail{
            let group = DispatchGroup()
            group.enter()
            //eposta
            Auth.auth().signIn(withEmail: mail, password: pass) { (ress, err) in
                if err != nil{

                    self.girisYapBtn.animation = "shake"
                    self.girisYapBtn.duration = 1
                    self.girisYapBtn.force = 5
                    self.girisYapBtn.animate()


                }else{

                    // *****GİRİŞ YAP*****


                    Firestore.firestore().collection("kullanicilar").document(Auth.auth().currentUser!.uid).getDocument(completion: { (snap, err) in

                        let result = Result {
                            try! snap?.data(as: Profil.self)
                        }

                        switch result{
                            case .success(let profilimm):
                                DispatchQueue.main.async {
                                    if let profilimm = profilimm{

                                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

                                        let manageContent = appDelegate.persistentContainer.viewContext

                                        let userEntity = NSEntityDescription.entity(forEntityName: "Profilim", in: manageContent)!

                                        let users = NSManagedObject(entity: userEntity, insertInto: manageContent)

                                        users.setValue(profilimm.ad, forKeyPath: "ad")
                                        users.setValue(profilimm.alan, forKeyPath: "alan")
                                        users.setValue(profilimm.istedigiBolum, forKeyPath: "istedigiBolum")
                                        users.setValue(profilimm.dersSaati, forKeyPath: "dersSaati")
                                        users.setValue(profilimm.mail, forKeyPath: "mail")
                                        users.setValue(profilimm.ogrenim, forKeyPath: "ogrenim")
                                        users.setValue(profilimm.pass, forKeyPath: "pass")
                                        users.setValue(profilimm.sevdigiDers, forKeyPath: "sevdigiDers")
                                        users.setValue(profilimm.soyad, forKeyPath: "soyad")
                                        users.setValue(profilimm.username, forKeyPath: "username")
                                        users.setValue(profilimm.premium, forKeyPath: "premium")
                                        do{
                                            try manageContent.save()
                                        }catch let error as NSError {

                                            print("could not save . \(error), \(error.userInfo)")
                                        }

                                         let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "Profilim")

                                        do {

                                            let result = try manageContent.fetch(fetchData)

                                            for data in result as! [NSManagedObject]{
                                                profilim.ad = data.value(forKeyPath: "ad") as! String
                                                profilim.alan = data.value(forKeyPath: "alan") as! String

                                                profilim.istedigiBolum = data.value(forKeyPath: "istedigiBolum") as! String

                                                profilim.dersSaati = data.value(forKeyPath: "dersSaati") as! String
                                                profilim.mail = data.value(forKeyPath: "mail") as! String
                                                profilim.ogrenim = data.value(forKeyPath: "ogrenim") as! String
                                                profilim.pass = data.value(forKeyPath: "id") as! String
                                                profilim.sevdigiDers = data.value(forKeyPath: "id") as! String
                                                profilim.soyad = data.value(forKeyPath: "soyad") as! String
                                                profilim.username = data.value(forKeyPath: "username") as! String
                                                profilim.premium = data.value(forKeyPath: "premium") as! Bool
                                                group.leave()

                                            }
                                        }catch {
                                            print("err")
                                        }
                                    }
                                }
                                (UIApplication.shared.delegate! as! AppDelegate).goTabbar()
                            case .failure(let error):
                                print("error occured", error)
                                group.leave()
                        }
                    })






                }
            }

        }

//        guard let mail = varMail.text, let pass = varpass.text else {return}
//
//        Auth.auth().signIn(withEmail: mail, password: pass) { (ress, err) in
//
//            if err != nil{
//                self.varBtnn.animation = "shake"
//                self.varBtnn.duration = 1
//                self.varBtnn.force = 5
//
//
//                self.varBtnn.animate()
//            }else{
//                let vc = self.storyboard?.instantiateViewController(identifier: "anaVC") as! EvViewController
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: false, completion: nil)
//
//
//            }
//
//        }

        

    }
    public func saveProfile(profile:Profil){

        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Profilim", in: managedContext)!



    }




}


extension UIViewController{
    func setBackgroundImage(_ imageName:String){
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.alpha = 0.5
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }

}
extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
