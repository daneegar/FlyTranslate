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
    func translate(someText text: String, isFromEngToRus isEng: Bool) {
        let makeTheMessage = MessageAsSomeTranslate(text: text, isFromEngToRus: isEng)
        let api = translateWithYandex()
        api.translate(it: text, inDirection: isEng) { (answer, urlResponse, error) in
            guard let answer = answer else {return}
            makeTheMessage.compliteTheMessage(withAnswer: answer)
            self.collectionOfMessages.insert(makeTheMessage, at: 0)
            self.messageWasTranslated()
        }
    }
    
    //MARK: - command to add come message to a view
    func messageWasTranslated () {
        self.askForShowTranslatedMessageToView(message: collectionOfMessages.first!)
    }
    
    func countMessages() -> Int {
        return self.collectionOfMessages.count
    }
    
    func askForShowTranslatedMessageToView(message: MessageAsSomeTranslate) -> IndexPath {
        let indexPath = IndexPath(row: 0, section: 0)
        view?.showTranslatedMessage(message: indexPath)
        return indexPath
    }
    
    func cellPerfomer(by indexPath: IndexPath, inTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! messageCell
        cell.prepareCell(withSome: self.collectionOfMessages[indexPath.row])
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }

    
}
