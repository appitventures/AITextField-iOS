//
//  AITextField.swift
//  AITextField
//
//  Created by AppitVentures on 19/10/16.
//  Copyright © 2016 AppitVentures. All rights reserved.
//

import UIKit

@objc protocol AITextFieldProtocol {
    // protocol definition
    
    func keyBoardHidden(textField:UITextField)
    @objc optional func didSelectedPickerIndex(index: NSInteger,textField:AITextField)
    
}
@IBDesignable
class AITextField: UITextField, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource
{
    enum AITextFieldType
    {
        case NormalTextField
        case DatePickerTextField
        case TimePickerTextField
        case TextPickerTextField
        case PasswordTextField
        case EmailTextField
        case PhoneNumberTextField
        case NumberTextField
    }
    
    var textFieldType:AITextFieldType = AITextFieldType.NormalTextField
    var datePicker:UIDatePicker? = nil
    var picker:UIPickerView? = nil
    var dateFormatString = "MM/dd/yyyy" //"dd/MM/yyyy"//"MMM dd, yyyy"
    let timeFormatString = "hh:mm a"
    var selectedDate: Date? = nil
    var pickerViewArray = [Any]()
    var selectedTextInPicker:String = ""
    var aiDelegate:AITextFieldProtocol? = nil
    var selectedCountryRegion:String? = nil
    var datePickerMode:UIDatePickerMode = UIDatePickerMode.date
    
    
    @IBInspectable var text_Color: UIColor? = UIColor.black
    
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        delegate = self
        
    }
    required override init(frame: CGRect)
    {
        super.init(frame: frame)
        delegate = self
    }
    func createSeparator(borderColor:UIColor,xpos:CGFloat)
    {
        let separator = CALayer()
        let width = CGFloat(1.0)
        separator.borderColor = borderColor.cgColor
        separator.frame = CGRect(x: xpos, y: self.frame.size.height-width, width: self.frame.size.width-(2*xpos), height: self.frame.size.height)
        separator.borderWidth = width
        self.layer.addSublayer(separator)
        self.layer.masksToBounds = true
        self.layoutIfNeeded()
    }
    func createSeparator(borderColor:UIColor,xpos:CGFloat,borderwidth:CGFloat)
    {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: xpos, y: self.frame.size.height-width, width: borderwidth, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.layoutIfNeeded()
    }
    func setLeftGap (width:Int, placeHolderImage:UIImage)
    {
        let leftGap:UIView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        leftGap.backgroundColor = UIColor.clear
        
        let imageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = placeHolderImage
        
        leftGap.addSubview(imageView)
        
        self.leftView = leftGap;
        self.leftViewMode = UITextFieldViewMode.always
        
    }
    
    func setRightGap (width:Int, placeHolderImage:UIImage)
    {
        let rightGap:UIView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: Int(self.frame.size.height)))
        rightGap.backgroundColor = UIColor.clear
        
        let imageView:UIImageView = UIImageView(frame: CGRect(x: -10, y: 0, width: width, height: Int(self.frame.size.height)))
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.image = placeHolderImage
        
        rightGap.addSubview(imageView)
        
        self.rightView = rightGap
        self.rightViewMode = UITextFieldViewMode.always
    }
    
    func setRightViewText(text:String)
    {
        let rightGap:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: Int(self.frame.size.height)))
        rightGap.backgroundColor = UIColor.clear
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: Int(self.frame.size.height)))
        label.textAlignment = .right
        label.font = self.font
        label.textColor = .lightGray
        label.text = text
        label.sizeToFit()
        rightGap.addSubview(label)
        
        self.rightView = rightGap
        self.rightViewMode = UITextFieldViewMode.always
        
    }
    
    func updateUIAsPerTextFieldType() {
        
        switch textFieldType
        {
        case AITextFieldType.NormalTextField:
            break;
       
        case AITextFieldType.DatePickerTextField:
            addDatePicker()
            setToolBar()
            break;
            
        case AITextFieldType.TimePickerTextField:
            addTimePicker()
            setToolBar()
            break;
        case AITextFieldType.TextPickerTextField:
            addTextPicker()
            setToolBar()
            break;
       
        case AITextFieldType.PasswordTextField:
            self.isSecureTextEntry = true
            break;
            
        case AITextFieldType.EmailTextField:
            self.keyboardType = UIKeyboardType.emailAddress
            self.autocorrectionType = UITextAutocorrectionType.no
            break;
            
        case AITextFieldType.PhoneNumberTextField:
            self.keyboardType = UIKeyboardType.phonePad
            setToolBar()
            break;
            
        case AITextFieldType.NumberTextField:
            self.keyboardType = UIKeyboardType.numberPad
            setToolBar()
            break;
        }
        
        self.textColor = text_Color
        //self.font = UIFont.systemFont(ofSize: 16)
        self.layoutIfNeeded()
    }
    func addTextPicker()
    {
        self.picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
        self.picker?.delegate = self
        self.picker?.dataSource = self
        self.picker?.translatesAutoresizingMaskIntoConstraints = false
        self.picker?.backgroundColor = .white
        self.inputView = self.picker;
    }
    func addDatePicker()
    {
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
        self.datePicker?.datePickerMode = self.datePickerMode
        self.datePicker?.backgroundColor = .white
        self.datePicker?.translatesAutoresizingMaskIntoConstraints = false
        
        self.inputView = self.datePicker
    }
    func addTimePicker() {
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 255))
        self.datePicker?.datePickerMode = UIDatePickerMode.time
        self.datePicker?.backgroundColor = .white
        self.datePicker?.translatesAutoresizingMaskIntoConstraints = false
        
        self.inputView = self.datePicker
    }
    func setToolBar()
    {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 44)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AITextField.doneButtonClicked))
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(AITextField.cancelButtonClicked))
        
        let flixibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        toolBar.items = [cancelButton,flixibleSpace,doneButton]
        toolBar.tintColor = .blue
        
        toolBar.isTranslucent = false
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        
        self.inputAccessoryView = toolBar
    }
    /*
     When user click done button
     */
    @objc func doneButtonClicked()
    {
        switch self.textFieldType {
            
        case AITextFieldType.DatePickerTextField:
            setDateTextWithFormatter(string: self.dateFormatString as NSString)
            
            break
        case AITextFieldType.TimePickerTextField:
            setDateTextWithFormatter(string: self.timeFormatString as NSString)
            break
        case AITextFieldType.TextPickerTextField:
            setPickerViewTexttoTextField()
            break;
       
        default:
            break
        }
        self.aiDelegate?.keyBoardHidden(textField: self)
        self.resignFirstResponder()
    }
    /*
     When user clicked cancel button.
     */
    @objc func cancelButtonClicked()
    {
        switch self.textFieldType {
        case AITextFieldType.DatePickerTextField:
            setOldDateTextWithFormatter(string: self.dateFormatString as NSString)
            
            break
        case AITextFieldType.TimePickerTextField:
            setOldDateTextWithFormatter(string: self.timeFormatString as NSString)
            break
        case AITextFieldType.TextPickerTextField:
            setOldTexttoTextField()
            break
        default:
            break
        }
        self.resignFirstResponder()
    }
    
    func setPickerViewTexttoTextField()
    {
        if (self.pickerViewArray.count)>0
        {
            let selectedIndex = self.picker?.selectedRow(inComponent: 0)
            let selectedOption:String = self.pickerViewArray[selectedIndex!] as! String
            self.text = selectedOption
            self.selectedTextInPicker = selectedOption
            
            aiDelegate?.didSelectedPickerIndex!(index:selectedIndex! , textField: self)
            
        }
    }
    func setSelectedCountryTexttoTextField()
    {
        let selectedIndex = self.picker?.selectedRow(inComponent: 0)
        let selectedCountry = self.pickerViewArray[selectedIndex!] as! NSDictionary
        let selectedOption:String = selectedCountry["code"] as! String
        self.text = selectedOption
        self.selectedCountryRegion = selectedCountry["name"] as? String
    }
    func setOldTexttoTextField()
    {
        self.text = self.selectedTextInPicker
    }
    func setDateTextWithFormatter(string:NSString)
    {
        let date = self.datePicker?.date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date!)
        
        self.selectedDate = calendar.date(from: components)!
        
        let date_Formatter = DateFormatter()
        date_Formatter.dateFormat = string as String?
        
        let dateString = date_Formatter.string(from: (self.datePicker?.date)!)
        self.text = dateString
        
        
    }
    func setOldDateTextWithFormatter(string:NSString)
    {
        if (self.selectedDate != nil)
        {
            let date_Formatter = DateFormatter()
            date_Formatter.dateFormat = string as String?
            let dateString = date_Formatter.string(from: self.selectedDate!)
            self.text = dateString
            
        }
    }
    
    func getSelectedIndex() -> Int
    {
        if self.textFieldType == AITextFieldType.TextPickerTextField {
            return (self.picker?.selectedRow(inComponent: 0))!
        }
        return 100000
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.aiDelegate?.keyBoardHidden(textField: self)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
       
        let selectedOption:NSString = self.pickerViewArray[row] as! NSString
        return NSAttributedString(string: selectedOption as String, attributes: nil)
    }
    
    // Disable paste action
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        //return super.canPerformAction(action, withSender: sender)
        return false
    }
    
}
