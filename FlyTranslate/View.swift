//
//  ViewController.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 29/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import UIKit

class View: UIViewController, ViewProtocol {

    
    func setGreeting(greeting: String) {
        
    }
    
    
    let presenter = Presenter.instance.self
    
    
    override func viewDidLoad() {
        presenter.view = self
        super.viewDidLoad()
        let ApiEntity = translateWithYandex()
        self.presenter.translate(text: "Hello World", isFromEngToRus: true)
        // Do any additional setup after loading the view, typically from a nib.
    }


    
    
    func pickTranslated(message: MessageAsSomeTranslate) {
        print(message.translatedText!)
    }
}

