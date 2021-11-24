//
//  PuanHesaplamaViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 26.04.2021.
//

import UIKit
import WebKit
import SwiftSoup


class PuanHesaplamaViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var hesaplaBtn: UIButton!

    @IBOutlet weak var wkWebView: WKWebView!

    var link = URL(string: "https://www.basarisiralamalari.com/tyt-yks-puan-hesaplama/")



    override func viewDidLoad() {
        super.viewDidLoad()

        wkWebView.navigationDelegate = self

        let urlreq = URLRequest(url: link!)
        wkWebView.load(urlreq)

        // Do any additional setup after loading the view.
    }



    @IBAction func setYKS(_ sender: UITextField) {
        if sender.text == "" || sender.text == " " { return sender.text = "0"}
        guard let text = sender.text else {return}


        if sender.tag == 0{
            setValueWK(id: "tytdiploma", veri: text)
        }else if sender.tag == 1 {
            setValueWK(id: "tytsosd", veri: text)
        }else if sender.tag == 2{
            setValueWK(id: "tytmatd", veri: text)
        }else if sender.tag == 3{
            setValueWK(id: "tytfend", veri: text)
        }else if sender.tag == 4{
            setValueWK(id: "tyttry", veri: text)
        }else if sender.tag == 5{
            setValueWK(id: "tytsosy", veri: text)
        }else if sender.tag == 6{
            setValueWK(id: "tytmaty", veri: text)
        }else if sender.tag == 7{
            setValueWK(id: "tytfeny", veri: text)
        }

    }

    

    
    @IBAction func hesaplaAct(_ sender: UIButton) {
        let str = "document.getElementsByName('ykshesapla')[0].click()"

        wkWebView.evaluateJavaScript(str) { (val, err) in
            if err != nil {
                print(err!)
            }



            let deadline = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: deadline) {
                self.getValueWK(name: "hampuan")


            }
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("tamamammm")

    }


}

extension PuanHesaplamaViewController{
    private func setValueWK(id: String, veri: String){

        wkWebView.evaluateJavaScript("document.getElementsByName('\(id)')[0].value = '\(veri)';") { (res, err) in
        }
    }

    private func getValueWK(name: String){
        wkWebView.evaluateJavaScript("document.getElementsByName('\(name)')[0].value;") { (res, err) in
            print(res as? String)
        }
    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
