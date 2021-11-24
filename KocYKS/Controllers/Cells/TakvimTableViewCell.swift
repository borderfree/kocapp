//
//  TakvimTableViewCell.swift
//  KocYKS
//
//  Created by Fetih Tunay Yetişir on 7.06.2021.
//

import UIKit
import FoldingCell
class TakvimTableViewCell: FoldingCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var dersAdi: UILabel!
    @IBOutlet weak var konuAdi: UILabel!
    @IBOutlet weak var dersImage: UIImageView!
    @IBOutlet weak var dersImage2: UIImageView!

    @IBOutlet weak var kazanimLbl: UILabel!
    @IBOutlet weak var tahminiSoruLbl: UILabel!
    @IBOutlet weak var tahminiDersLbl: UILabel!
    @IBOutlet weak var dersKonuLbl: UILabel!




    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2, 0.2, 0.2]
        return durations[itemIndex]
    }
}
