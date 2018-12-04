//
//  ViewController.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 29/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import UIKit

class View: UIViewController, ViewProtocol {


    
    @IBOutlet weak var sendTextButton: UIButton!
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    func setGreeting(greeting: String) {
        
    }
    let presenter = Presenter.instance.self
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        self.chatTableView.dataSource = self
        self.textField.delegate = self
        
        self.chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        //self.chatTableView.separatorStyle = .none
        self.presenter.translate(someText: "Hello World", isFromEngToRus: true)
    }


    
    
    func pickTranslated(message: MessageAsSomeTranslate) {
        print(message.translatedText!)
    }
    
    func showTranslatedMessage(message: IndexPath) {
        self.chatTableView.insertRows(at: [message], with: .automatic)
    }
}

//MARK: - data source methods
extension View: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countMessages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.cellPerfomer(by: indexPath, inTableView: tableView)
    }
}


//MARK: - textField delegate methods
extension View: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    @IBAction func sendText(_ sender: Any) {
        self.presenter.translate(someText: textField.text!, isFromEngToRus: true)
        self.textField.text = ""
    }
}

