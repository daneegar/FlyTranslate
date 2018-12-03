//
//  Model.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 29/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import Foundation

class MessageAsSomeTranslate {
    let isFromEngToRus: Bool
    let text: String
    var translatedText: String?
    init (text: String, isFromEngToRus: Bool) {
        self.isFromEngToRus = isFromEngToRus
        self.text = text
        self.translatedText = ""
    }
    func compliteTheMessage(withAnswer answer: Answer) {
        self.translatedText = answer.text[0]
    }
}
