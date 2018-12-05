//
//  ViewController.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 29/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import UIKit
import Speech

class View: UIViewController, ViewProtocol {
    let presenter = Presenter.instance.self
    var isEnToRuModeOn = true
    var keyboardIsShown = false
    var recognitionIsBegining = false
    var recordedSpeech = ""
    @IBOutlet weak var sendTextButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var iconsSubView: UIView!
    @IBOutlet weak var englishIcon: UIImageView!
    @IBOutlet weak var russianIcon: UIImageView!
    @IBOutlet weak var englishIconLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var englishIconRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var russianIconLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var russianIconRighConstraint: NSLayoutConstraint!
    
    var frontIconLeftConstraint: CGFloat?
    var frontIconRightConstraint: CGFloat?
    
    let audioEngine = AVAudioEngine()
    let speechEnRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let speechRuRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "ru"))
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    @IBAction func micButtonTapped(_ sender: Any) {
        if  audioEngine.isRunning {
            stopRecordAndRecognizeSpeechAndSendText()
            updateView()
            self.micButton.backgroundColor = .none
            return
        }
        self.recordAndRecognizeSpeech()
        self.micButton.backgroundColor = .black
        updateView()
    }
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    func setGreeting(greeting: String) {
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        self.chatTableView.estimatedRowHeight = 200
        self.chatTableView.rowHeight = UITableView.automaticDimension
        self.chatTableView.dataSource = self
        self.textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        preparing()
        self.presenter.translate(someText: "Hello World", isFromEngToRus: self.isEnToRuModeOn)
    }

    func pickTranslated(message: MessageAsSomeTranslate) {
        print(message.translatedText!)
    }
    
    func showTranslatedMessage(message: IndexPath) {
        self.chatTableView.insertRows(at: [message], with: .automatic)
    }
    
    //MARK: - preparing and update view
    func preparing() {
        self.chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.chatTableView.separatorStyle = .none
        self.chatTableView.allowsSelection = false
        self.chatTableView.keyboardDismissMode = .onDrag
        self.textField.borderStyle = .none
        self.textField.text = self.isEnToRuModeOn ? "Английский" : "Русский"
        self.textField.backgroundColor = currentColour()
        self.bottomView.backgroundColor = currentColour()
        self.bottomView.layer.cornerRadius = CGFloat(integerLiteral: 20)
        self.iconsSubView.layer.cornerRadius = CGFloat(integerLiteral: 18)
        self.englishIcon.layer.cornerRadius = CGFloat(integerLiteral: 16)
        self.russianIcon.layer.cornerRadius = CGFloat(integerLiteral: 16)
        self.englishIcon.layer.borderWidth = CGFloat(integerLiteral: 2)
        self.russianIcon.layer.borderWidth = CGFloat(integerLiteral: 2)
        self.englishIcon.layer.borderColor = UIColor.white.cgColor
        self.russianIcon.layer.borderColor = UIColor.white.cgColor
        
        self.frontIconRightConstraint = englishIconRightConstraint.constant
        self.frontIconLeftConstraint = englishIconLeftConstraint.constant
        updateIconsPositions()
        updateButtons()
    }
    func updateView () {
        
        if !self.textField.isEditing {
            self.textField.text = self.isEnToRuModeOn ? "Английский" : "Русский"
        }
        UIView.animate(withDuration: 0.5) {
            self.textField.backgroundColor = self.currentColour()
            self.bottomView.backgroundColor = self.currentColour()
            
        }
        self.textField.isEnabled = audioEngine.isRunning ? false : true
        updateIconsPositions()
    }
    func updateButtons () {
        self.sendTextButton.isHidden = keyboardIsShown ? false : true
        self.sendTextButton.isEnabled = keyboardIsShown ? true : false
        self.micButton.isHidden = keyboardIsShown ? true : false
        self.micButton.isEnabled = keyboardIsShown ? false : true
    }
    func updateIconsPositions() {
        let viewWhichShoudBeInFront = self.isEnToRuModeOn ? self.englishIcon : self.russianIcon
        self.englishIconLeftConstraint.constant = (!self.isEnToRuModeOn ? self.frontIconLeftConstraint : self.frontIconRightConstraint)!
        self.englishIconRightConstraint.constant = (!self.isEnToRuModeOn ? self.frontIconRightConstraint : self.frontIconLeftConstraint)!
        self.russianIconLeftConstraint.constant = (!self.isEnToRuModeOn ? self.frontIconRightConstraint : self.frontIconLeftConstraint)!
        self.russianIconRighConstraint.constant = (!self.isEnToRuModeOn ? self.frontIconLeftConstraint : self.frontIconRightConstraint)!

        UIView.animate(withDuration: 0.5) {
            self.iconsSubView.bringSubviewToFront(viewWhichShoudBeInFront!)
            self.iconsSubView.layoutIfNeeded()
        }
    }
    
    func changeDirection() {
        self.isEnToRuModeOn = !isEnToRuModeOn
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardIsShown {return} else {keyboardIsShown = !keyboardIsShown}
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            updateButtons()
            self.bottomConstraint.constant -= keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.mainView.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if !keyboardIsShown {return} else {keyboardIsShown = !keyboardIsShown}
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant += keyboardSize.height
            updateButtons()
            UIView.animate(withDuration: 0.3) {
                self.mainView.layoutIfNeeded()
            }
            updateView()
            
        }
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




//MARK: - textField delegate methods and buttons
extension View: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    @IBAction func sendText(_ sender: Any) {
        guard let textIsHere = self.textField.text else {
            //TODO: - do some exclusion
            return
        }
        self.presenter.translate(someText: textIsHere.localizedCapitalized, isFromEngToRus: isEnToRuModeOn)
        self.textField.text = ""
    }
    @IBAction func changeModeTapped(_ sender: Any) {
        self.changeDirection()
        updateView()
    }
    
    func currentColour() -> UIColor {
        return isEnToRuModeOn ? UIColor.UIColorFromHex(rgbValue: 0x007CE9) : UIColor.UIColorFromHex(rgbValue: 0xED4C5C)
    }
}

//MARK: - speech recognizer
extension View: SFSpeechRecognizerDelegate {
    func recordAndRecognizeSpeech() {
        let node = self.audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, time) in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch  {
            print(error)
        }
        let recognizer = self.isEnToRuModeOn ? speechEnRecognizer : speechRuRecognizer
        guard let rocognizer = recognizer else { return }
        if !rocognizer.isAvailable {
            return
        }
        self.recognitionTask = rocognizer.recognitionTask(with: request, resultHandler: { (result, error) in
            if let catchedResult = result {
                self.recordedSpeech = catchedResult.bestTranscription.formattedString
                //TODO - animation for mic button
            } else if let error = error {
                print(error)
            }
        })
    }
    func stopRecordAndRecognizeSpeechAndSendText(){
        audioEngine.stop()
        let node = audioEngine.inputNode
        node.removeTap(onBus: 0)
        recognitionTask?.cancel()
        self.presenter.translate(someText: recordedSpeech, isFromEngToRus: self.isEnToRuModeOn)
    }
}

