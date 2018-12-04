//
//  Protocols.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 30/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import UIKit

protocol ViewProtocol: class {
    func showTranslatedMessage (message: IndexPath)
}


protocol PresenterProtocol {
    func countMessages() -> Int
    func askForShowTranslatedMessageToView (message: MessageAsSomeTranslate) -> IndexPath
}
