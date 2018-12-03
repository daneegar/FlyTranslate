//
//  ViewController.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 29/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import UIKit

class View: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ApiEntity = translateWithYandex()
        ApiEntity.translate(it: nil, inDirection: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }


}

