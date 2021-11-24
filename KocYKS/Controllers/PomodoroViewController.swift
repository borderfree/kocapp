//
//  PomodoroViewController.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 28.04.2021.
//

import UIKit
import Spring
class PomodoroViewController: UIViewController {

    @IBOutlet weak var kalanTurLbl: UILabel!

    @IBOutlet weak var pBaslaBtn: SpringButton!

    @IBOutlet weak var saatPomoLbl: SpringLabel!

    @IBOutlet weak var pDurBtn: SpringButton!


    var timer = Timer()
    var pomodoro = 25*60
    var isRunning = false
    var tatil = 5*60

    override func viewDidLoad() {
        super.viewDidLoad()
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

            if let error = error {
                // Handle the error here.
            }

            // Enable or disable features based on the authorization.
        }


        // Do any additional setup after loading the view.
    }

    @IBAction func baslaAct(_ sender: SpringButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(keepTimer), userInfo: nil, repeats: true)


    }


    @IBAction func durAct(_ sender: SpringButton) {


    }


    @objc func keepTimer(){
        pomodoro -= 1
        isRunning = true
        if pomodoro == 0{
            timer.invalidate()
            isRunning = false
            

        }
        saatPomoLbl.text = timeString(time: TimeInterval(pomodoro))


//        if (dakika>0) || (saniye>0){
//
//            saniye -= 1
//            if saniye == 0 {
//                saniye = 60
//                dakika -= 1
//            }
//            if (dakika == 0) && (saniye == 0){
//                print("süre doldu")
//            }
//        }


    }
    func timeString(time:TimeInterval) -> String {

    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i", minutes, seconds)

    }

}
