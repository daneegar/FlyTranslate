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
        self.textForTranslate.text = message.text
        self.translatedText.text = message.translatedText
    }

}
