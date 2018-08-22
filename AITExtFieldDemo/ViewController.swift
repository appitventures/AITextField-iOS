//
//  ViewController.swift
//  AITExtFieldDemo
//
//  Created by Sreekanth Bandi on 20/08/18.
//  Copyright © 2018 Sreekanth Bandi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardBGView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var stateTextField: AITextField!
    @IBOutlet weak var dobTextField: AITextField!
    @IBOutlet weak var phoneNumberTextField: AITextField!
    @IBOutlet weak var emailTextField: AITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "AITextField"
        
        emailTextField.setLeftGap(width: 10, placeHolderImage: UIImage())
        phoneNumberTextField.setLeftGap(width: 10, placeHolderImage: UIImage())
        dobTextField.setLeftGap(width: 10, placeHolderImage: UIImage())
        stateTextField.setRightGap(width: 10, placeHolderImage: #imageLiteral(resourceName: "keyboardArrowDown"))
        stateTextField.setLeftGap(width: 10, placeHolderImage: UIImage())
        
        emailTextField.textFieldType = .EmailTextField
        phoneNumberTextField.textFieldType = .PhoneNumberTextField
        dobTextField.textFieldType = .DatePickerTextField
        stateTextField.textFieldType = .TextPickerTextField
        
        var statesDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "USStateAbbreviations", ofType: "plist") {
            statesDict = NSDictionary(contentsOfFile: path)
        }
        
        let states = statesDict?.allKeys as! [String]//allKeys as! [String]
        let sortedStates = states.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        var statesArray = [Any]()
        for state in sortedStates
        {
            statesArray.append(state)
        }
        
        stateTextField.pickerViewArray = statesArray
        
        
        emailTextField.text_Color = UIColor.gray
        phoneNumberTextField.text_Color = UIColor.gray
        dobTextField.text_Color = UIColor.gray
        stateTextField.text_Color = UIColor.gray
        
        emailTextField.updateUIAsPerTextFieldType()
        phoneNumberTextField.updateUIAsPerTextFieldType()
        dobTextField.updateUIAsPerTextFieldType()
        stateTextField.updateUIAsPerTextFieldType()
        
        
        setGradient(colors: [UIColor(red: 127.0/255.0, green: 0.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor, UIColor(red: 83.0/255.0, green: 226.0/255.0, blue: 234.0/255.0, alpha: 1.0).cgColor], angle: 360)

        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
        
        cardBGView.backgroundColor = .clear
        cardBGView.layer.shadowColor = UIColor.gray.cgColor
        cardBGView.layer.shadowOpacity = 0.3
        cardBGView.layer.shadowOffset = CGSize(width: -1, height: 2)
        cardBGView.layer.shadowRadius = 6
    }
    
    func setGradient(colors: [CGColor], angle: Float = 0) {
       
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        gradient.colors = colors
        
        let alpha: Float = angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        gradient.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        gradient.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))
        
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

