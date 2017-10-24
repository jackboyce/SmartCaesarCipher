//
//  ViewController.swift
//  SmartCaesarCipher
//
//  Created by Jack Boyce on 10/23/17.
//  Copyright © 2017 Jack Boyce. All rights reserved.
//

import UIKit
//import AppKit

class ViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var outputText: UITextView!
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var shiftNumberText: UITextField!
    let inputTextPlaceholder = "Plain text"
    let outputTextPlaceholder = "Cipher text"
    let testDict = ["the":1,
                "as":1,
                "so":1,
                "and":1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(smartDecrypt(str: "dro myg kxn pyh tewzon yfob dro wyyx"))
        // Do any additional setup after loading the view, typically from a nib.
        //Let the keyboard be dismissed by tapping anywhere not on the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.outputText.layer.borderWidth = 1.0
        self.outputText.layer.borderColor = UIColor.gray.cgColor
        self.inputText.layer.borderWidth = 1.0
        self.inputText.layer.borderColor = UIColor.gray.cgColor
        
        inputText.text = inputTextPlaceholder
        inputText.textColor = UIColor.lightGray
        inputText.delegate = self
        
        outputText.text = outputTextPlaceholder
        outputText.textColor = UIColor.lightGray
        outputText.delegate = self
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("END EDIT")
        if textView.text.isEmpty {
            
            if textView == inputText {
                textView.text = inputTextPlaceholder
            } else if textView == outputText {
                textView.text = outputTextPlaceholder
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("START EDIT")
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func setBlack(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func encryptPressed(_ sender: Any) {
        dismissKeyboard()
        //textViewDidBeginEditing(outputText)
        
        if inputText.text == "" || inputText.text == inputTextPlaceholder && shiftNumberText.text == "" {
            errorText.text = "No plain text or shift number"
            return
        } else if inputText.text == "" ||  inputText.text == inputTextPlaceholder {
            errorText.text = "No plain text"
            return
        } else if shiftNumberText.text == "" {
            errorText.text = "No shift number"
            return
        } else if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: shiftNumberText.text!)) {
            errorText.text = "Shift can only be an integer"
            return
        }
        errorText.text = ""
        
        setBlack(outputText)
        
        outputText.text = shift(string: inputText.text!, num: Int(shiftNumberText.text!)!)
    }

    @IBAction func decryptPressed(_ sender: Any) {
        dismissKeyboard()
//        textViewDidBeginEditing(inputText)
        if outputText.text == "" || outputText.text == outputTextPlaceholder {
            errorText.text = "No cipher text"
            return
        }
        errorText.text = ""
        
        setBlack(inputText)
        
        let text = outputText.text!
        var stuff:[(string: String, score: Int, shift: Int)] = []
        
        for i in (0...25) {
            var tempText = shift(string: text, num: i)
            let textArray = tempText.characters.split{$0 == " "}.map(String.init)
            var score = 0
            for j in textArray {
                if let val = Dict.dict[j] {
                    score += val
                }
            }
            stuff.append((tempText, score, i))
        }
        
        var best: (string: String, score: Int, shift: Int) = ("", -1, -1)
        for i in stuff {
            if(i.score > best.score) {
                best = i
            }
            print("\(i.score) \(i.string)")
        }
        inputText.text = best.string
        shiftNumberText.text = "\(26 - best.shift)"
    }
    
    func smartDecrypt(str: String) -> String{
        let text = str//"the cow and fox jumped over the moon"
        var stuff:[(string: String, score: Int)] = []
        
        for i in (0...26) {
            var tempText = shift(string: text, num: i)
            let textArray = tempText.characters.split{$0 == " "}.map(String.init)
            var score = 0
            for j in textArray {
                if let val = testDict[j] {
                    score += val
                }
            }
            stuff.append((tempText, score))
        }
        
        var best: (string: String, score: Int) = ("", -1)
        for i in stuff {
            if(i.score > best.score) {
                best = i
            }
            print("\(i.score) \(i.string)")
        }
        return best.string
    }
    
    func shift(string: String, num: Int) -> String {
        var CString = string.cString(using: String.Encoding.utf8)
        
        for i in (0..<CString!.count) {
            if(((CString?[i])! >= 65 && (CString?[i])! <= 90)) {
                var newNum = Int((CString?[i])!) + num % 26
                if newNum > 90 {
                    newNum %= 90
                    newNum += 64
                }
                CString?[i] = CChar(newNum)
            } else if ((CString?[i])! >= 97 && (CString?[i])! <= 122) {
                var newNum = Int((CString?[i])!) + num % 26
                if newNum > 122 {
                    newNum %= 122
                    newNum += 96
                }
                CString?[i] = CChar(newNum)
            }
        }
        return NSString(bytes: CString!, length: CString!.count, encoding: String.Encoding.utf8.rawValue) as String!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

