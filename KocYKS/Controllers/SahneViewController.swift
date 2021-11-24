//
//  SahneViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 30.04.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import NVActivityIndicatorView

class SahneViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: -IBOUTLETS
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var nvActivity: NVActivityIndicatorView!



    //MARK: -VARIABLES

    var lastDocumentSnapshot:DocumentSnapshot!
    var fetching = false
    var posts = [Spotlight]()
    var paylasım = [(String,String,String)]()
    var owners = [String]()
    let dGroup = DispatchGroup()
    let size = UIScreen.main.bounds

    @IBOutlet weak var segmentCont: UISegmentedControl!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        UIConfig()

        fetching = true
        nvActivity.startAnimating()
        paginateData { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.nvActivity.stopAnimating()
            self.tableView.reloadData()
            self.fetching = false
        }


    }


    //MARK: -FUNCTIONS
    func rightButton(){
        navContIcon()
        let plusImg = UIImage(named: "plus")?.withTintColor(.mor).imageWith(newSize: 25)

        let right = UIBarButtonItem(image: plusImg, style: .plain, target: self, action: #selector(yeniSoruyaGonder))
        self.navigationItem.rightBarButtonItems = [right]
    }

    @objc func yeniSoruyaGonder(){
        let vc = storyboard?.instantiateViewController(identifier: "YeniSahneViewController") as! YeniSahneViewController
        self.navigationController?.pushViewController(vc, animated: true)


    }


    func getLikedPostId() {

        let d = Firestore.firestore().collection("Spotlight").order(by: "timestamp").limit(to: 5)

        d.addSnapshotListener { snapshot, err in
            if let err = err{
                print(err)
            }else{


            }
        }
    }

    func getLikedPosts(){

        let postRef = Firestore.firestore().collection("kullanicilar").document(profilim.username)

        postRef.getDocument { (snapShot, err) in
            if let snapshot = snapShot{
                _ = snapshot.value(forKey: "likers")
            }

        }



        let lastPost = self.posts.last
        let _: DatabaseQuery!

        if lastPost == nil{
            //queryRef = postRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 4)
        }else{
            //queryRef = postRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastPost!.timestamp).queryLimited(toLast: 4)

        }

    }

    func paginateData(completion: @escaping(_ posts:[Spotlight])->()){
        var tempPosts = [Spotlight]()
        let lastPost = posts.last
        dGroup.enter()


        var query: Query!
        print("spot sayısı: ---" , self.posts.count)
        if self.posts
            .last == nil {
            query = Firestore.firestore().collection("Spotlight").order(by: "timestamp", descending: true).limit(to: 2)
        }else{
            query = Firestore.firestore().collection("Spotlight").order(by: "timestamp", descending: true).start(afterDocument: lastDocumentSnapshot).limit(to: 1)
        }

        query.getDocuments { snap, err in
            if let err = err{
                print(err)
            }else if snap!.isEmpty{
                return
            }else{
                print("aaaa")
                if let t = snap?.documents{
                    for i in t{

                        let new = Spotlight(document: i) { Spotlight in
                        }
                        if new.postId == lastPost?.postId{
                            break
                            print("son soru")
                        }else{

                            tempPosts.insert(new, at: 0)

                        }


                    }

                }


            }
            self.dGroup.leave()
            self.dGroup.notify(queue: .main) {
                self.lastDocumentSnapshot = snap!.documents.last
                self.tableView.reloadData()
                completion(tempPosts)
            }
        }
    }






//    func observePosts(completion: @escaping(_ posts:[Spotlight])->()){
//
//        let postRef = Database.database().reference().child("Spotlight")
//        let lastPost = self.posts.last
//        let queryRef: DatabaseQuery!
//        self.dGroup.enter()
//        if lastPost == nil{
//            queryRef = postRef.queryOrdered(byChild: "timestamp").queryLimited(toLast: 4)
//        }else{
//            queryRef = postRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastPost!.timestamp).queryLimited(toLast: 4)
//        }
//
//        queryRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            var tempPosts = [Spotlight]()
//
//            for child in snapshot.children {
//
//                let new = Spotlight(snapShot: child as! DataSnapshot) { (spotlight) in
//
//
//                    Firestore.firestore().collection("kullanicilar").document(spotlight.owner).getDocument { (doc, err) in
//                            if let err = err{
//                                print(err)
//                            }else if let data = doc?.data(){
//                                let ad = data["ad"] as! String
//                                let soyad = data["soyad"] as! String
//                                let t = "\(ad) \(soyad)"
//                                self.owners.append(t)
//                                DispatchQueue.main.async {
//                                    self.tableView.reloadData()
//                                }
//                                print("owner list:",self.owners)
//                            }
//                        }
//
//                    }
//
//                if let imgUrl = new.image{
//
//                    var t = Storage.storage()
//
//                    let a = Storage.storage().reference(forURL: imgUrl)
//                    a.downloadURL { imgUrl, err in
//                        if let err = err{
//                            print(err)
//                        }
//                        DispatchQueue.main.async {
//                            let data = NSData(contentsOf: imgUrl!)
//                            let img = UIImage(data: data! as Data)
//                            new.toImg = img!
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
//
//                        }
//                    }
//                }
//
//                let planSnap = child as! DataSnapshot
//                let planDict = planSnap.value as! [String: Any]
//                let postId = planDict["uid"] as! String
//
//                if postId != lastPost?.postId{
//
//                    tempPosts.insert(new, at: 0)
//                }else{
//                    print("Son Soru")
//                    break
//                }
//            }
//            return completion(tempPosts)
//        })
//
//        self.dGroup.leave()
//
//    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
          navigationController?.setNavigationBarHidden(true, animated: true)

       } else {
          navigationController?.setNavigationBarHidden(false, animated: true)
       }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) && !fetching{
            print("scrolled")
            fetching = true

            paginateData { newPosts in
                self.posts.append(contentsOf: newPosts)
                self.tableView.reloadData()
                self.fetching = false
            }

        }
    }

    @IBAction func segmentAct(_ sender: UISegmentedControl) {

        print(sender.selectedSegmentIndex)


    }


    //MARK: -TABLE VIEW

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return posts.count ?? 0
    }

    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SahneTableViewCell") as! SahneTableViewCell


        cell.postId = self.posts[indexPath.row].postId
        cell.isHighlighted = false
        cell.contentView.backgroundColor = .clear
        //cell.aciklamaLbl.font
        cell.mainView.layer.cornerRadius = 15
        cell.mainView.alpha = 0.9
        cell.mainView.layer.borderWidth = 2
        cell.mainView.layer.borderColor = UIColor.mor.cgColor
        cell.aciklamaLbl.textColor = .mor
        cell.dersAdiLbl.textColor = .mor
        cell.konuAdiLbl.textColor = .mor
        cell.goruntu.layer.cornerRadius = 10
        cell.turu.textColor = .mor
        cell.tarih.textColor = .mor



        cell.aciklamaLbl.text = String(self.posts[indexPath.row].likers.count) ?? "Boş Değer"
        let konu = self.posts[indexPath.row].subtopic.dropFirst(2)
        cell.dersAdiLbl.text = self.posts[indexPath.row].topic
        cell.konuAdiLbl.text = konu.base
        cell.paylasanAdiLbl.text = self.posts[indexPath.row].owner



//        if let count = self.posts[indexPath.row].likeCount{
//            cell.dersAdiLbl.text = String(count)
//        }

        cell.tarih.text = Date().timeCracker(timeStamp: self.posts[indexPath.row].timestamp)
        if self.posts[indexPath.row].race == 0{
            cell.turu.text = "Soru"
        }else{
            cell.turu.text = "Bilgisel"

        }
        Storage.storage().reference(forURL: self.posts[indexPath.row].image!).getData(maxSize: 1*1024*1024) { data, err in
            if let err = err{
                print(err)
            }else{
                cell.goruntu.image = UIImage(data: data!)
            }
        }
        return cell
    }
    let titles = ["Loungelar","Beğendiklerim","Loungelarım"]

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let selectedIndex = self.segmentCont.selectedSegmentIndex

        return titles[selectedIndex]
    }

}

extension UIImage{
    func imageWith(newSize: Int) -> UIImage {
        let cgSize = CGSize(width: newSize, height: newSize)
        let renderer = UIGraphicsImageRenderer(size: cgSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: cgSize))
        }

        return image.withRenderingMode(self.renderingMode)
    }
}


extension SahneViewController{
    func UIConfig(){
        rightButton()
        setBackgroundImage("anaP")
        let leftImg = UIImage(named: "left")?.withTintColor(.mor).imageWith(newSize: 25)
        self.navigationController?.navigationBar.backIndicatorImage = leftImg
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        nvActivity.type = .orbit
        nvActivity.padding = 50
        nvActivity.color = .mor
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
}

extension UIViewController{
    func navContIcon(){
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
        let titleImageView = UIImageView(image: UIImage(named: "beyaz")?.withTintColor(.mor))
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height)
        titleView.addSubview(titleImageView)
        self.navigationItem.titleView = titleView
    }
}
