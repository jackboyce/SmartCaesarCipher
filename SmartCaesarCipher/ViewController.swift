//
//  ViewController.swift
//  SmartCaesarCipher
//
//  Created by Jack Boyce on 10/23/17.
//  Copyright © 2017 Jack Boyce. All rights reserved.
//

import UIKit
//import AppKit

class ViewController: UIViewController{

    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var outputText: UITextView!
    @IBOutlet weak var inputText: UITextView!
    @IBOutlet weak var shiftNumberText: UITextField!
    let testDict = ["the":1,
                "as":1,
                "so":1,
                "and":1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(smartDecrypt(str: "dro myg kxn pyh tewzon yfob dro wyyx"))
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func encryptPressed(_ sender: Any) {
        if inputText.text == "" && shiftNumberText.text == "" {
            errorText.text = "No input text or shift number"
            return
        } else if inputText.text == "" {
            errorText.text = "No input text"
            return
        } else if shiftNumberText.text == "" {
            errorText.text = "No shift number"
            return
        } else if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: shiftNumberText.text!)){
            errorText.text = "Shift can only be an integer"
            return
        }
        errorText.text = ""
        
        outputText.text = shift(string: inputText.text!, num: Int(shiftNumberText.text!)!)
    }

    @IBAction func decryptPressed(_ sender: Any) {
        if outputText.text == "" {
            errorText.text = "No output text"
            return
        }
        errorText.text = ""
        
        let text = outputText.text!//"the cow and fox jumped over the moon"
        var stuff:[(string: String, score: Int, shift: Int)] = []
        
        for i in (0...26) {
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

        
        
//        inputText.text = shift(string: outputText.text!, num: (26 - (Int(shiftNumberText.text!)! % 26)))
    }
    
    func smartDecrypt(str: String) -> String{
        var text = str//"the cow and fox jumped over the moon"
        var stuff:[(string: String, score: Int)] = []
        
        for i in (0...26) {
            var tempText = shift(string: text, num: i)
            var textArray = tempText.characters.split{$0 == " "}.map(String.init)
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

