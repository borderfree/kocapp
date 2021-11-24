//
//  EvViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 21.12.2020.
//

import UIKit
import GravitySliderFlowLayout
import Spring
import LTMorphingLabel


class EvViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {



    @IBOutlet weak var quo: LTMorphingLabel!



    @IBOutlet weak var sayaçLabel: UILabel!
    @IBOutlet weak var kategoriCollection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var homeScrollView: UIScrollView!


    var quoTimer: Timer?
    var currentPage = 0

    var quotesArray = ["Eğer hayal edebiliyorsanız*yapabilirsiniz.","Saati seyretme* saat gibi yap.*İlerlemeye devam et.","Gelecek, hayallerinin güzelliğine* inananlarındır.","Engeller olacak.* Şüphe edenler olacak.* Hatalar olacak.* Ama çok çalışırsan* limitler ortadan kalkacak.","Gözlerini yıldızlara dik* ayakların yere bassın.","Sürekliliği sağlamanın bir yolu* hep daha büyük hedefler koymaktır.","Hayatını bugün değiştir* Geleceğin üzerine kumar oynama* Şimdi harekete geç* hemen."," Yenemeyeceğiniz tek kişi* asla pes etmeyen birisidir.","Sınırım: Hayallerim","Kendinizi itin* çünkü hiç kimse*sizin için bunu yapmayacak.","Neredeyseniz orada başlayın.* Neyiniz varsa onu kullanın.* Ne yapabiliyorsanız onu yapın.","Başarı seni bulmaz.* Sen çıkıp onu yakalamalısın.","Bir şey için ne kadar çok çalışırsanız,* başardığınızda o kadar* harika hissedersiniz."]



    // YKS SAYACINA shape eklenecek. eklenen shapeler dolma animasyonu gibi olacak

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        startTimer()
        setKategoriler()

        quotes()

        setBackgroundImage("anaP")
        navigationController?.hidesBarsOnSwipe = true


//        self.navigationController!.navigationBar.isHidden = false
        
//        self.navigationController!.navigationItem.title = "EV"
//        self.navigationController!.navigationBar.barTintColor = .mor
//        self.navigationItem.titleView = UIImageView(image: UIImage(named: "home"))
//        self.navigationController?.hidesBarsOnSwipe = true
//        let image = UIImage(named: "home")
        self.pageControl.numberOfPages = liste.count
        
    }

    var guncel = 0
    func quotes(){
        var seperatedArr = [[String]]()

        for i in quotesArray{
            var t = i.components(separatedBy: "*")
            seperatedArr.append(t)
        }
        let randomNumber = Int.random(in: 0...seperatedArr.count-1) // rand=4
        let max = seperatedArr[randomNumber].count // 4 ün maxı 3

        // seperatedArr[rand] = [String]
        var t = seperatedArr[randomNumber]



        Timer.scheduledTimer(withTimeInterval: 2.2, repeats: true) { timer in

            var siralananArr = t

            var total = 0
            for i in 0...seperatedArr.count-1{
                total = total + seperatedArr[i].count
                for j in seperatedArr[i]{
                    siralananArr.append(j)
                }
            }
            let effectRand = Int.random(in: 0...2)
            if let effect = LTMorphingEffect(rawValue: effectRand){
                self.quo.morphingEffect = effect
            }

            self.quo.text = siralananArr[self.guncel]
            self.guncel = self.guncel+1
            if self.guncel == total{
                self.guncel = 0
            }




        }




    }

    func setKategoriler(){
        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: kategoriCollection.frame.width/2, height: kategoriCollection.frame.height/2))

        kategoriCollection.collectionViewLayout = gravitySliderLayout
    }


    

    let liste = [UIImage(named: "puanHesap"),UIImage(named: "pomodoro"),UIImage(named: "konuBahcem"),UIImage(named: "rehberlik"),UIImage(named: "basariSiralamalari")]

    var releaseDate: NSDate?
    var countdownTimer = Timer()
}


extension EvViewController{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {




    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {

        if let collectionview = kategoriCollection{
            let visibleRect = CGRect(origin: collectionview.contentOffset, size: collectionview.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = collectionview.indexPathForItem(at: visiblePoint) {
                self.pageControl.currentPage = visibleIndexPath.row
            }
        }
    }



    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liste.count
    }






    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EvKategoriCollectionViewCell", for: indexPath as IndexPath) as! EvKategoriCollectionViewCell
        cell.image.image = self.liste[indexPath.row]
        cell.roundCorners(corners: .allCorners, radius: 20)

        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let navCont = UINavigationController(rootViewController: EvViewController())
        if indexPath.row == 0{
            let vc = storyboard?.instantiateViewController(identifier: "ProfilViewController") as! ProfilViewController

            self.navigationController!.pushViewController(vc, animated: true)
            print("aaa")
        }else if indexPath.row == 1{


        }else if indexPath.row == 2{


        }else if indexPath.row == 3{


        }else if indexPath.row == 4{


        }else{
            print("yok öyle bir şey")
        }
    }


    //SINAVA KALAN ZAMAN ---HAFTA
    func startTimer() {

        let releaseDateString = "2022-06-25 08:00:00"
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        releaseDate = releaseDateFormatter.date(from: releaseDateString)! as NSDate

        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)


    }

    @objc func updateTime() {

        let currentDate = Date()
        let calendar = Calendar.current

        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)

        let countdown = "\(diffDateComponents.day ?? 0) gün  \(diffDateComponents.hour ?? 0) saat \(diffDateComponents.minute ?? 0) dakika \(diffDateComponents.second ?? 0) saniye"

        self.sayaçLabel.text = "\(countdown)"
    }
}




extension UIView {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color

        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }

        layer.addSublayer(border)
    }
}

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
