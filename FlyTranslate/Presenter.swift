//
//  Presenter.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 29/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import Foundation


class Presenter: PresenterProtocol {
    func showGreeting() {
        
    }
    
    
    static let instance: Presenter = Presenter()
    private init(){}
    
}
