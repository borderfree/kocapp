//
//  Colors.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 2.05.2021.
//
import SwiftEntryKit
import Foundation
import UIKit
import UIFontComplete

extension UIColor{

    static var koyuMavi: UIColor  { return UIColor(hex: "#420690") }

    static var koyuMor: UIColor { return UIColor(hex: "#640c96") }

    static var morII: UIColor { return UIColor(hex: "#ce7fce") }
    static var cingenePembesi: UIColor { return UIColor(hex: "#ff2e9f") }

    static var mor: UIColor  { return UIColor(hex: "#6F1C57") }

    static var AAcikPembe: UIColor { return UIColor(hex: "FFC2C0")}

    static var pembe: UIColor { return UIColor(hex: "#FFF5FF") }

    static var anaMavi: UIColor { return UIColor(red: 180, green: 196, blue: 250, alpha: 1)}

    static var anaPembe: UIColor { return UIColor(red: 215, green: 154, blue: 217, alpha: 1)}



}

@IBDesignable extension UIView {
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: CGFloat {
        get { return CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    @IBInspectable var cornerRadius: CGFloat{
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
}

enum FontBook:String, FontRepresentable{
    case euro35 = "eurof35"
    case euro55 = "eurof55"
    case euro75 = "eurof75"
    case comfortaa_bold = "Comfortaa-Bold"
    case comfortaa_light = "Comfortaa-Light"
    case comfortaa_Regular = "Comfortaa-Regular"
    case caviar_Bold = "CaviarDreams_Bold"
    case caviar_BoldItalic = "CaviarDreams_BoldItalic"
    case caviar_Italic = "CaviarDreams_Italic"
    case caviar = "CaviarDreams"
}

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat = 15){


        let shadowSize : CGFloat = cornerRadious
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.frame.size.width + shadowSize,
                                                   height: self.frame.size.height + shadowSize))
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.cgPath
        self.layer.cornerRadius = cornerRadious

    }
}


extension UIButton {
    func buttonRoundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
    }
}

extension UIView{

    func neuromorphic(bgColor:UIColor, cornerRadius:CGFloat = 15, shadowRadius:CGFloat = 3){
        self.layer.masksToBounds = false

        let darkShadow = CALayer()
        darkShadow.frame = bounds
        darkShadow.backgroundColor = bgColor.cgColor
        darkShadow.shadowColor = UIColor(red: 0.87, green: 0.89, blue: 0.93, alpha: 1.0).cgColor
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = shadowRadius
        self.layer.insertSublayer(darkShadow, at: 0)

        let lightShadow = CALayer()
        lightShadow.frame = bounds
        lightShadow.backgroundColor = bgColor.cgColor
        lightShadow.shadowColor = UIColor.white.cgColor
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = shadowRadius
        self.layer.insertSublayer(lightShadow, at: 0)



    }
}

extension UIViewController{
    func setBackground(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "anaP")
        backgroundImage.alpha = 0.3
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
}


