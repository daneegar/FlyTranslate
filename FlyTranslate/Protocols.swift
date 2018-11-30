//
//  Protocols.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 30/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

protocol ViewProtocol: class {
    func setGreeting(greeting: String)
}


protocol PresenterProtocol {
    init(view: ViewProtocol)
    func showGreeting()
}
