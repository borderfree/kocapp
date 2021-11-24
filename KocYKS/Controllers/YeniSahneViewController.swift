//
//  YeniSahneViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 30.04.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseDatabase
import FirebaseStorage
import SwiftEntryKit
import Spring

class YeniSahneViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    //MARK: -IBOUTLETS

    //Boş değer gönderirken oluşan bug var,


    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var gonderButton: UIButton!
    @IBOutlet weak var soruImg: UIImageView!
    @IBOutlet weak var switchtür: UISegmentedControl!
    @IBOutlet weak var DersButton: UIButton!
    @IBOutlet weak var aciklama: SpringTextView!
    @IBOutlet weak var konubutton: SpringButton!
    
    //MARK: -VARIABLES

    var store = Firestore.firestore()
    var ref:DatabaseReference!
    var yOffSet:CGFloat = 0
    var newArr = [String]()

    let imagePickerController = UIImagePickerController()
    var imageUrl = ""
    var finalAciklama = ""
    var ders = ""
    var konu = ""
    var değer = "Soru"
    var secilenDers = Int()
    let dispatch = DispatchGroup()

    let newpickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
    let konuPickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))

    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundImage("anaP")

        tabImage()
        ref = Database.database().reference()
        print(profilim.username)
        konubutton.isHidden = true

        
        shadowConfigure()



    }

    func kayit(){
        dispatch.enter()
        let tarih = Date().nowTimeStamp

        var newAciklama = String()

        newAciklama = (self.aciklama.text ?? "")
        let collection = store.collection("Spotlight")


        guard let imageData: Data = self.soruImg.image!.jpegData(compressionQuality: 0.05) else {
            return
        }

        let metaDataConfig = StorageMetadata()
        metaDataConfig.contentType = "image/jpg"
        let uid = UUID()
        let storageRef = Storage.storage().reference().child("Spotlight").child(uid.uuidString)

        storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
            if let error = error {
                print(error.localizedDescription)

                return
            }

            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in

                if let error = error{
                    print(error)
                }else{
                    DispatchQueue.main.async {
                        collection.document(uid.uuidString).setData([
                            "uid" : uid.uuidString,
                            "owner": profilim.username,
                            "image": (url?.absoluteString)!,
                            "timestamp": tarih,
                            "topic": self.ders,
                            "subtopic": self.konu,
                            "statement":newAciklama,
                            "race": self.switchtür.selectedSegmentIndex
                        ])

                        self.store.collection("kullanicilar").document(profilim.username).updateData([
                            "myPosts": FieldValue.arrayUnion([uid.uuidString])
                        ])

                    }

                }
                self.dispatch.leave()
            })
        }





        dispatch.notify(queue: DispatchQueue.main) {
            //*****  PROCESS ÇUBUĞU EKLENECEK    :::::::::::


            self.navigationController?.popViewController(animated: false)
        }



    }


    // MARK: -IBACTIONS

    @IBAction func gonderAct(_ sender: UIButton) {
        kayit()
    }



    @IBAction func segmentAct(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
            case 0:
                değer = "Soru"
            case 1:
                değer = "Bilgisel"

            default:
                değer = "Soru"
        }
    }

    @IBAction func DersSecAct(_ sender: UIButton) {
        pickerSeç(baslik: "Ders Seç",picker: newpickerView)
    }

    @IBAction func konuSecAct(_ sender: UIButton) {
        pickerSeç(baslik: "Konu seç", picker: konuPickerView)

    }



    // MARK: -FUNCTIONS


    //MARK: UI OPERATIONS
    

    func shadowConfigure(){
        soruImg.applyshadowWithCorner(containerView: imgContainerView, cornerRadious: 5)
        //gonderButton.buttonRoundCorners(corners: [.topLeft,.topRight], radius: 20)
        konubutton.buttonRoundCorners(corners: [.bottomRight,.bottomLeft], radius: 20)
        DersButton.buttonRoundCorners(corners: [.topLeft,.topRight], radius: 20)
        gonderButton.backgroundColor = .pembe
        
        gonderButton.neuromorphic(bgColor: .pembe,cornerRadius: 0)
        gonderButton.buttonRoundCorners(corners: [.bottomRight,.bottomLeft], radius: 15)
        gonderButton.tintColor = .mor
        gonderButton.neuromorphic(bgColor: .pembe)

        switchtür.backgroundColor = UIColor.pembe
        switchtür.layer.masksToBounds = true
        switchtür.selectedSegmentTintColor = .mor
        let att = [NSAttributedString.Key.foregroundColor: UIColor.pembe, NSAttributedString.Key.backgroundColor: UIColor.clear]
        switchtür.setTitleTextAttributes(att, for: .selected)
        let att2 = [NSAttributedString.Key.foregroundColor: UIColor.mor, NSAttributedString.Key.backgroundColor: UIColor.clear]
        switchtür.setTitleTextAttributes(att2, for: .normal)
        switchtür.addShadowAndRadius()

    }

    //MARK: IMAGE OPERATIONS
    func uploadImagePic(image: UIImage) {

    }



    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        let tappedImageView = gestureRecognizer.view!
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        let alert = UIAlertController(title: "Görüntüyü nereden almak istersiniz?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Galeri", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "İptal", style: .cancel, handler: nil))

        imagePickerController.sourceType = .photoLibrary

        present(alert, animated: true, completion: nil)
    }

    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Hata", message: "Kameranız kullanılamıyor.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.allowsEditing = true
           imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
           self.present(imagePicker, animated: true, completion: nil)
       }else{
           let alert  = UIAlertController(title: "Hata", message: "Cihaz ayarlarınızdan galeri erişimine izin verin.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
   }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage{
            soruImg.image = img
            var size = img.size


        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }

    func tabImage(){
        soruImg.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gestureRecognizer:)))
        soruImg.addGestureRecognizer(tapRecognizer)
        soruImg.contentMode = .scaleToFill
    }

    //MARK: -PICKER OPERATIONS


    func pickerSeç(baslik:String, picker: UIPickerView){

        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        picker.delegate = self
        picker.dataSource = self

        vc.view.addSubview(picker)

        let editRadiusAlert = UIAlertController(title: baslik, message: "", preferredStyle: UIAlertController.Style.alert)

        editRadiusAlert.setValue(vc, forKey: "contentViewController")

        editRadiusAlert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { (UIAlertAction) in

            if self.ders == ""{
                self.ders = TümDersler[0].ad
                self.secilenDers = 0
                self.ders = TümDersler[0].ad
                self.DersButton.setTitle(TümDersler[0].ad, for: .normal)
                self.newArr.append(contentsOf: TümDersler[self.secilenDers].konular.map({ $0.key }))

                self.konubutton.animation = "fadeIn"
                self.konubutton.delay = 0.2
                self.konubutton.duration = 2
                self.konubutton.damping = 2
                self.konubutton.animate()
                self.konubutton.isHidden = false
            }
            if self.konu == ""{
                self.konu = TümDersler[self.secilenDers].konular.keys.first as! String
                self.konubutton.setTitle(self.konu, for: .normal)
            }


        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil))

        self.present(editRadiusAlert, animated: true)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var delege = String()

        if pickerView == newpickerView {
            delege = TümDersler[row].ad

        }else if pickerView == konuPickerView{
            delege = newArr[row] //TümDersler[secilenDers].konular.keys
        }
        return delege
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == newpickerView {

            if ders == ""{
                secilenDers = 0
                ders = TümDersler[0].ad
                DersButton.setTitle(TümDersler[0].ad, for: .normal)

            }
            self.konubutton.animation = "fadeIn"
            self.konubutton.delay = 0.2
            self.konubutton.duration = 2
            self.konubutton.damping = 2
            self.konubutton.animate()
            self.konubutton.isHidden = false
            DersButton.setTitle(TümDersler[row].ad, for: .normal)
            ders = TümDersler[row].ad
            newArr.removeAll()

            secilenDers = row
            for i in TümDersler[secilenDers].konular.keys{
                newArr.append(i)
            }
            _ = newArr.sorted(by: { $0 < $1 })

        }else if pickerView == konuPickerView{
            konu = newArr[row]
            konubutton.setTitle(newArr[row], for: .normal)
        }


    }

}

//MARK: -EXTENSIONS

extension YeniSahneViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var number = Int()

        if pickerView == newpickerView {
            number = TümDersler.count

        }else if pickerView == konuPickerView{
            number = TümDersler[secilenDers].konular.count
        }
        return number

    }

}
extension Date{
    var nowTimeStamp:Int{
        return Int(NSDate().timeIntervalSince1970)
    }
    func timeCracker(timeStamp:Int)->String{

        let firstdate = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let lastDate = Date(timeIntervalSince1970: TimeInterval(Date().nowTimeStamp))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = .current
        let comp = Calendar.current.dateComponents([.day, .month,.hour,.minute,.second], from: firstdate, to: lastDate)
        var str = ""

        if comp.month! > 0 {
            str = "\(comp.month!) ay"
        }else if comp.month! < 1 && comp.day! >= 1{
            str = "\(comp.day!) gün"
        }else if comp.month! == 0 && comp.day! < 1{
            str = "\(comp.hour!) sa \(comp.minute!) dk"
        }else{
            str = ""
        }
//        if comp.day! > 0 {
//            str="\(comp.day!) gün"
//        }
//        if comp.hour! > 0 {
//            str=str+"\(comp.hour!) saat "
//        }
//        if comp.minute! > 0{
//            str=str+"\(comp.minute!) dk"
//        }
        //let localDate = dateFormatter.string(from: date)
        
        return str
    }


    //Date().timeCracker(timeStamp: Int(self.posts[indexPath.row].timestamp))
}

extension UIView{
    func addShadowAndRadius(radius:CGFloat = 15){
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true

    }
}
