//
//  Presenter.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 29/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import Foundation
import UIKit

class Presenter: PresenterProtocol {
    var collectionOfMessages: [MessageAsSomeTranslate]
    var view: ViewProtocol?
    func showGreeting() {
        
    }
    
    static let instance: Presenter = Presenter()
    
    //MARK: - initilizer
    private init(){
        self.collectionOfMessages = []
    }
    
    
    //MARK: - request for translate
    func translate(text text: String, isFromEngToRus isEng: Bool) {
        let makeTheMessage = MessageAsSomeTranslate(text: text, isFromEngToRus: isEng)
        let api = translateWithYandex()
        api.translate(it: text, inDirection: isEng) { (answer, urlResponse, error) in
            guard let answer = answer else {return}
            makeTheMessage.compliteTheMessage(withAnswer: answer)
            self.collectionOfMessages.append(makeTheMessage)
            self.messageWasTranslated()
        }
    }
    
    //MARK: - command to add come message to a view
    func messageWasTranslated () {
        view?.pickTranslated(message: collectionOfMessages.last!)
    }
    
}
