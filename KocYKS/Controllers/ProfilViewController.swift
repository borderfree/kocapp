//
//  ProfilViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 26.04.2021.
//

import UIKit
import Firebase
import CoreData

class ProfilViewController: UIViewController {


    @IBOutlet weak var btnÇıkış: UIButton!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var pentaView: UIView!

    @IBOutlet weak var lbl2: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        //lbl1.text = "Merhaba, \(profilim.ad)"
        lbl2.text = profilim.username


        setBackgroundImage("anaP")

    }


    @IBAction func çıkışAct(_ sender: UIButton) {

        do {
            try! Auth.auth().signOut()
            resetAllRecords(in: "Profilim")
        }catch{
            
        }
        let vc = storyboard?.instantiateViewController(identifier: "GirisViewController") as! GirisViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }

    func resetAllRecords(in entity : String){
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try context.execute(deleteRequest)
            try context.save()
        }
        catch{
            print("There was an error")
        }
    }


}
