//
//  TakvimViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 22.12.2020.
//

import UIKit
import GravitySliderFlowLayout
class TakvimViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate,UITableViewDataSource{


    struct Const {
        static let close: CGFloat = 75 // equal or greater foregroundView height
        static let open: CGFloat = 341 // equal or greater containerView height
        static let rowsCount = 5

    }


    var cellHeights = (0..<Const.rowsCount).map { _ in Const.close }

    var secilen = 0
    let Sonuc = Takvim().konularinHaftayaDagitilmasi(konular: Takvim().Run())

    @IBOutlet weak var derslerTV: UITableView!
    
    @IBOutlet weak var collViewHaftalik: UICollectionView!


    override func viewDidLoad() {
        super.viewDidLoad()
        navContIcon()

        setBackgroundImage("anaP")
        derslerTV.estimatedRowHeight = Const.close
        derslerTV.rowHeight = UITableView.automaticDimension
        derslerTV.backgroundColor = .clear
    }


}

extension TakvimViewController{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        secilen = indexPath.row

        derslerTV.reloadData()

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return Sonuc.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TakvimCollectionViewCell", for: indexPath as IndexPath) as! TakvimCollectionViewCell
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        cell.layer.cornerRadius = 5

        if secilen == indexPath.row{
            cell.alpha = 0.8

        }
        cell.gunLabel.text = Array(Sonuc.keys)[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(Sonuc.values)[secilen].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TakvimTableViewCell", for: indexPath) as! TakvimTableViewCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        var a = Array(Sonuc.values)[secilen]

        let map = Array(Sonuc.values)[secilen].map { $0.konuAdi}
        let dersA = Array(Sonuc.values)[secilen].map { $0.konuAdi}
        let t = isContain(aranan: dersA[indexPath.row])
        cell.dersAdi.text = t.0
        cell.dersImage.image = icon(icon: t.0)
        cell.dersImage2.image = icon(icon: t.0)
        cell.dersKonuLbl.text = t.1
        cell.konuAdi.text = t.2
        cell.tahminiDersLbl.text = "Tahmini ders çalışma süresi: \(t.3*30) dakika"
        cell.tahminiSoruLbl.text = "Tahmini soru sayısı: \(t.3*8) soru"

        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let cell as TakvimTableViewCell = tableView.cellForRow(at: indexPath) else {
                  return
                }

        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.close
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.open
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.close
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            self.derslerTV.beginUpdates()
            self.derslerTV.endUpdates()


            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)


    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as TakvimTableViewCell = cell else {
            return
        }
        if cellHeights[indexPath.row] == Const.close {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }

    }
}


extension UIViewController{
    // Ders Adı, Ana Konu, Alt Konu, değer
    func isContain(aranan:String)->(String,String,String,Int){
        for i in [Türkçe,tytMatematik,geometri,paragraf]{
            for t in i.konular{
                for a in t.value{
                    if a.konuAdi == aranan{
                        var g = t.key
                        g.dropFirst(2)

                        return (i.ad,g,a.konuAdi,a.konuDegeri)
                    }
                }


            }
        }

        return ("","","",0)
    }

    func icon(icon:String)->UIImage{
        switch icon {
            case "Geometri":
                return UIImage(named: "mathematics")!
            case "Türkçe":
                return UIImage(named: "diary")!
            case "TYT Matematik":
                return UIImage(named: "calculator")!
            case "Paragraf":
                return UIImage(named: "workbook")!
            default:
                break
        }
        return UIImage(named: "")!
    }

}


