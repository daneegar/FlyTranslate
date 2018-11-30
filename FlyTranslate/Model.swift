//
//  Model.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 29/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import Foundation

class MessageAsTranslate {
    let isFromRussiaToEnglish: Bool
    let text: String
    var translatedText: String?
    init () {
        self.isFromRussiaToEnglish = true
        self.text = ""
        self.translatedText = ""
    }
}
