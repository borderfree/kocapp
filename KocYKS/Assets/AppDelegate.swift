//
//  AppDelegate.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 19.12.2020.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth
import UIFontComplete
import AnimatedTabBar
import CoreData

let main = UIStoryboard(name: "Main", bundle: nil)


var iitemev = AnimatedTabBarItem(icon: UIImage(named: "capitol")!.withTintColor(UIColor.mor), title: "EV", controller: UINavigationController(rootViewController: main.instantiateViewController(withIdentifier: "EvViewController") as! EvViewController))
var iitemsahne = AnimatedTabBarItem(icon: UIImage(named: "lounge")!.withTintColor(.mor), title: "LOUNGE", controller: UINavigationController(rootViewController: main.instantiateViewController(withIdentifier: "SahneViewController") as! SahneViewController))
var iitemtakvim = AnimatedTabBarItem(icon: UIImage(named: "calendar")!.withTintColor(.mor), title: "TAKVİM", controller: UINavigationController(rootViewController: main.instantiateViewController(withIdentifier: "TakvimViewController") as! TakvimViewController))
var iitemprofil = AnimatedTabBarItem(icon: UIImage(named: "fingerprint")!.withTintColor(.mor), title: "PROFİL", controller: UINavigationController(rootViewController: main.instantiateViewController(withIdentifier: "ProfilViewController") as! ProfilViewController))

var iitemAi = AnimatedTabBarItem(icon: UIImage(named: "ai")!.withTintColor(.mor), title: "PROFİL", controller: UINavigationController(rootViewController: main.instantiateViewController(withIdentifier: "ProfilViewController") as! ProfilViewController))


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard


    var d = [iitemev,iitemsahne,iitemtakvim,iitemprofil,iitemAi]




    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        getCoreDataDBPath()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        UINavigationBar.appearance().barTintColor = UIColor.pembe
        UINavigationBar.appearance().tintColor = .pembe
        UIBarButtonItem.appearance().tintColor = .mor

        let dispatchGroup = DispatchGroup()

        

        if Auth.auth().currentUser != nil {
            dispatchGroup.enter()
            let cont = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext



            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Profilim")

            do {

                let result = try cont.fetch(request)

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
            }catch {
                print("err")
            }
            

            self.goTabbar()






//            let vcData: [(UIViewController, UIImage, String)] = [
//                (vc1, UIImage(named: "home")!, "Home"),
//                (vc2, UIImage(named: "home")!, "Spot"),
//                (vc3, UIImage(named: "home")!, "Profile"),
//                (vc4, UIImage(named: "home")!, "Pomodoro")
//            ]
//
//            let vcs = vcData.map { (vc, image, title) -> UINavigationController in
//                let nav = UINavigationController(rootViewController: vc)
//
//                nav.title = title
//                return nav
//            }





        }else{
            ///User yoksa
            print("Kullanici Yokkkk")
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Profilim")
            fetchRequest.returnsObjectsAsFaults = false

            do {
                let arrUsrObj = try managedContext.fetch(fetchRequest)
                for usrObj in arrUsrObj as! [NSManagedObject] {
                    managedContext.delete(usrObj)
                }
               try managedContext.save() //don't forget
                } catch let error as NSError {
                print("delete fail--",error)
              }
            let vc = main.instantiateViewController(withIdentifier: "GirisViewController") as! GirisViewController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()

        }
        if defaults.bool(forKey: "FirstLaunch") == true{
            
            //Motor().motorCalistir()
            defaults.setValue(true, forKey: "FirstLaunch")
        }else{
            print("Uygulamayı ilk kez açtı.")
            //let kalanGun = Motor().programbitişiHafta()
            //defaults.setValue(kalanGun, forKey: "kalanGun")
            defaults.setValue(true, forKey: "FirstLaunch")
        }




        // Thread will wait here until async task closure is complete

        return true
    }


    func goTabbar() {
        let controller = TabViewController()
        controller.delegate = self
        AnimatedTabBarAppearance.shared.textFont = UIFont(name: "eurofurence", size: 20)!
        

        AnimatedTabBarAppearance.shared.textColor = .mor
        AnimatedTabBarAppearance.shared.dotColor = .mor

        AnimatedTabBarAppearance.shared.backgroundColor = UIColor.pembe



        self.window?.backgroundColor = .white
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
    }


    lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            let container = NSPersistentContainer(name: "Model")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    //MARK: -Save
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
extension AppDelegate : AnimatedTabBarDelegate {
    func initialIndex(_ tabBar: AnimatedTabBar) -> Int? {
        return 1
    }

    var numberOfItems: Int {
        return d.count
    }

    func tabBar(_ tabBar: AnimatedTabBar, itemFor index: Int) -> AnimatedTabBarItem {
        return d[index]
    }

    func getCoreDataDBPath() {
            let path = FileManager
                .default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .last?
                .absoluteString
                .replacingOccurrences(of: "file://", with: "")
                .removingPercentEncoding

            print("Core Data DB Path :: \(path ?? "Not found")")
        }

}
