//
//  messageCellTableViewCell.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 04/12/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {
    @IBOutlet weak var bodyOfContent: UIView!
    @IBOutlet weak var textForTranslate: UILabel!
    @IBOutlet weak var translatedText: UILabel!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCell(withSome message: MessageAsSomeTranslate) {
        self.translatedText.textColor = UIColor.UIColorFromHex(rgbValue: 0xFAFAFA, alpha: 1)
        self.textForTranslate.textColor = UIColor.UIColorFromHex(rgbValue: 0xFAFAFA, alpha: 0.8)
        self.textForTranslate.text = message.text
        self.translatedText.text = message.translatedText
        let colour = message.isFromEngToRus ? UIColor.UIColorFromHex(rgbValue: 0x007CE9) : UIColor.UIColorFromHex(rgbValue: 0xED4C5C)
        bodyOfContent.backgroundColor = colour
        bodyOfContent.layer.cornerRadius = CGFloat(integerLiteral: 10)
        if message.isFromEngToRus {
            self.rightConstraint.constant = 139
            self.leftConstraint.constant = 10
        } else {
            self.leftConstraint.constant = 139
            self.rightConstraint.constant = 10
            self.translatedText?.textAlignment = .right
            self.textForTranslate? .textAlignment = .right
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }

    }
    


}
