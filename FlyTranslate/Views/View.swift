//
//  ViewController.swift
//  FlyTranslate
//
//  Created by Denis Garifyanov on 29/11/2018.
//  Copyright © 2018 Denis Garifyanov. All rights reserved.
//

import UIKit
import Speech

enum placeHolderStates: String {
    case en = "Английский"
    case ru = "Русский"
    case write = "Пишите..."
    case talk = "Говорите..."
    case none = ""
}

class View: UIViewController, ViewProtocol {
    let presenter = Presenter.instance.self
    var isEnToRuModeOn = true
    var keyboardIsShown = false
    var recordedSpeech = ""
    @IBOutlet weak var sendTextButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textField: UITextView! // textView if be honest
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!

    
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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var frontIconLeftConstraint: CGFloat?
    var frontIconRightConstraint: CGFloat?
    
    let audioEngine = AVAudioEngine()
    let speechEnRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let speechRuRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "ru"))
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    

    


    
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
    

    
    //MARK: - preparing and update view
    func preparing() {
        self.chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.chatTableView.separatorStyle = .none
        self.chatTableView.allowsSelection = false
        self.chatTableView.keyboardDismissMode = .onDrag
        
        self.textField.text = self.isEnToRuModeOn ? placeHolderStates.en.rawValue : placeHolderStates.ru.rawValue
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
        
        self.textField.isScrollEnabled = false
        self.textField.textContainer.heightTracksTextView = true
        self.textField.endFloatingCursor()

        self.textField.textColor = UIColor.lightGray
        self.textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.beginningOfDocument)
        
        updateIconsPositions()
        updateButtons(showMic: true)
    }
    
    
    func resetTextField() {
        self.textField.textColor = UIColor.lightGray
        self.textField.text = placeHolderStates.write.rawValue
        self.textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.beginningOfDocument)
        self.textViewHeight.constant = CGFloat(integerLiteral: 36)
        UIView.animate(withDuration: 0.5) {
            self.bottomView.layoutIfNeeded()
        }
    }
    func updateView () {
        resetTextField()
        self.textField.text = self.isEnToRuModeOn ? placeHolderStates.en.rawValue : placeHolderStates.ru.rawValue
        if audioEngine.isRunning { placeHolderHandler(state: .talk)}
        UIView.animate(withDuration: 0.5) {
            self.textField.backgroundColor = self.currentColour()
            self.bottomView.backgroundColor = self.currentColour()
            self.textViewHeight.constant = CGFloat(integerLiteral: 36)
        }
        self.textField.isEditable = audioEngine.isRunning ? false : true
        updateIconsPositions()
    }
    func updateButtons (showMic: Bool) {
        if showMic {
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.sendTextButton.imageView?.alpha = 0
                self.micButton.imageView?.alpha = 100
            }, completion: { _ in
                self.sendTextButton.isHidden = true
                self.sendTextButton.isEnabled = false
                self.micButton.isHidden = false
                self.micButton.isEnabled = true
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.micButton.imageView?.alpha = 0
                self.sendTextButton.imageView?.alpha = 100
            }, completion: { _ in
                self.sendTextButton.isHidden = false
                self.sendTextButton.isEnabled = true
                self.micButton.isHidden = true
                self.micButton.isEnabled = false
            })
        }
        
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
    func placeHolderHandler (state: placeHolderStates) {
        let placeHolderColor = UIColor.lightGray
        switch state {
        case .talk:
            self.textField.textColor = placeHolderColor
            self.textField.text = state.rawValue
        default:
            return
        }
    }
    
    func changeDirection() {
        self.isEnToRuModeOn = !isEnToRuModeOn
    }
    
    //MARK: - keyboard notifications
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardIsShown {return} else {keyboardIsShown = !keyboardIsShown}
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //updateButtons()
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
            //updateButtons()
            UIView.animate(withDuration: 0.3) {
                self.mainView.layoutIfNeeded()
            }
            updateView()
            
        }
    }
}

//MARK: - data source methods and append a message
extension View: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.countMessages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.cellPerfomer(by: indexPath, inTableView: tableView)
    }
    func showTranslatedMessage(message: IndexPath) {
        self.chatTableView.insertRows(at: [message], with: .automatic)
    }
}




//MARK: - textView delegate methods and menu's buttons
extension View: UITextViewDelegate {
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = placeHolderStates.write.rawValue
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            updateButtons(showMic: true)
            textView.text = placeHolderStates.write.rawValue
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            updateButtons(showMic: false)
            textView.textColor = UIColor.white
            textView.text = text
        }
        else {
            return true
        }
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        self.textViewHeight.constant = estimatedSize.height
        UIView.animate(withDuration: 0.3) {
            self.bottomView.layoutIfNeeded()
            self.chatTableView.layoutIfNeeded()
        }
    }
    
    @IBAction func sendText(_ sender: Any) {
        guard let textIsHere = self.textField.text else {
            //TODO: - do some exclusion
            return
        }
        self.presenter.translate(someText: textIsHere, isFromEngToRus: isEnToRuModeOn)
        resetTextField()
        updateButtons(showMic: true)
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

