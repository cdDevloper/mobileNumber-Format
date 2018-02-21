//
//  RequestQuoteViewController.swift
//  LYNKD
//
//  Created by Ashish Chaudhary on 2/17/18.
//  Copyright © 2018 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit

class RequestQuoteViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyNameErrLabel: UILabel!
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var contactNameErrLabel: UILabel!
    @IBOutlet weak var zipCodeTextField : UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityErrLabel: UILabel!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var stateErrLabel: UILabel!
    @IBOutlet weak var contactEmailTextField: UITextField!
    @IBOutlet weak var contactEmailErrLabel: UILabel!
    @IBOutlet weak var contactPhoneTextfield: UITextField!
    @IBOutlet weak var contactPhoneErrLabel: UILabel!
    @IBOutlet weak var extensionTextField: UITextField!
    @IBOutlet weak var usersCountTextField: UITextField!
    @IBOutlet weak var usersCountErrLabel: UILabel!
    @IBOutlet weak var devicesTextField: UITextField!
    @IBOutlet weak var devicesCountErrLabel: UILabel!
    @IBOutlet weak var industryTextField: UITextField!
    @IBOutlet weak var industryErrLabel: UILabel!
    @IBOutlet weak var btnPlanOne: UIButton!
    @IBOutlet weak var btnPlanTwo: UIButton!
    @IBOutlet weak var btnPlanThree: UIButton!
    @IBOutlet weak var btnRequestQuote: UIButton!
    
    var isPlanOneSelected:Bool = false
    var isPlanTwoSelected:Bool = false
    var isPlanThreeSelected:Bool = true //default plan
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.addTapGesture()
    }
    
    
    
    // MARK: - Private Methods
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHideKeyboard(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapHideKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func checkTextFieldValidation(tag: Int)
    {
        switch tag {
        case 0:
            if self.companyNameTextField.text == "" {
                self.companyNameErrLabel.isHidden = false
            } else {
                self.companyNameErrLabel.isHidden = true
            }
            break
            
        case 1:
            if self.contactNameTextField.text == "" {
                self.contactNameErrLabel.isHidden = false
            } else {
                self.contactNameErrLabel.isHidden = true
            }
            break
            
        case 3:
            if self.cityTextField.text == "" {
                self.cityErrLabel.isHidden = false
            } else {
                self.cityErrLabel.isHidden = true
            }
            break
            
        case 4:
            if self.stateTextField.text == "" {
                self.stateErrLabel.isHidden = false
            } else {
                self.stateErrLabel.isHidden = true
            }
            break
            
        case 5:
            if self.contactEmailTextField.text == "" {
                self.contactEmailErrLabel.isHidden = false
                self.contactEmailErrLabel.text = "Email cannot be blank."
            } else {
                if Validation1.isValidEmail(testEmail:self.contactEmailTextField.text!) {
                    self.contactEmailErrLabel.isHidden = true
                } else {
                    self.contactEmailErrLabel.isHidden = false
                    self.contactEmailErrLabel.text = "Invalid Email Address."
                }
            }
            break
            
        case 6:
            
            if self.contactPhoneTextfield.text == "" {
                self.contactPhoneErrLabel.isHidden = false
                self.contactPhoneErrLabel.text = "Phone cannot be blank."
            } else {
                if (Validation1.isValidPhone(testPhoneNumber: self.contactPhoneTextfield.text!.replacingOccurrences(of: "-", with: ""))) {
                    self.contactPhoneErrLabel.isHidden = true
                } else {
                    self.contactPhoneErrLabel.isHidden = false
                    self.contactPhoneErrLabel.text = "Invalid Phone Number."
                }
            }
            break
            
        case 8:
            if self.usersCountTextField.text == "" {
                self.usersCountErrLabel.isHidden = false
            } else {
                if (Validation1.isValidNumber(number: self.usersCountTextField.text!)) {
                    self.usersCountErrLabel.isHidden = true
                } else {
                    self.usersCountErrLabel.isHidden = false
                    self.usersCountErrLabel.text = "Enter valid number."
                }
            }
            break
            
        case 9:
            if self.devicesTextField.text == "" {
                self.devicesCountErrLabel.isHidden = false
                self.devicesCountErrLabel.text = "Device Count cannot be blank."
            } else {
                if (Validation1.isValidNumber(number: self.devicesTextField.text!)) {
                    self.devicesCountErrLabel.isHidden = true
                } else {
                    self.devicesCountErrLabel.isHidden = false
                    self.devicesCountErrLabel.text = "Enter valid number."
                }
            }
            break
            
        case 10:
            if self.industryTextField.text == "" {
                self.industryErrLabel.isHidden = false
            } else {
                self.industryErrLabel.isHidden = true
            }
            break
        default:
            break
        }
    }
    
    func isAllTextFieldValid() -> Bool {
        
        if self.companyNameTextField.text == "" {
            self.companyNameErrLabel.isHidden = false
            return false
        } else {
            self.companyNameErrLabel.isHidden = true
        }
        
        if self.contactNameTextField.text == "" {
            self.contactNameErrLabel.isHidden = false
            return false
        } else {
            self.contactNameErrLabel.isHidden = true
        }
        
        if self.cityTextField.text == "" {
            self.cityErrLabel.isHidden = false
            self.cityErrLabel.text = "City cannot be blank."
            return false
        } else {
            self.cityErrLabel.isHidden = true
        }
        
        if self.stateTextField.text == "" {
            self.stateErrLabel.isHidden = false
            self.stateErrLabel.text = "State cannot be blank."
            return false
        } else {
            self.stateErrLabel.isHidden = true
        }
        
        if self.contactEmailTextField.text == "" {
            self.contactEmailErrLabel.isHidden = false
            self.contactEmailErrLabel.text = "Email cannot be blank."
            return false
        } else {
            if Validation1.isValidEmail(testEmail:self.contactEmailTextField.text!) {
                self.contactEmailErrLabel.isHidden = true
            } else {
                self.contactEmailErrLabel.isHidden = false
                self.contactEmailErrLabel.text = "Invalid Email Address."
            }
        }
        
        if self.contactPhoneTextfield.text == "" {
            self.contactPhoneErrLabel.isHidden = false
            self.contactPhoneErrLabel.text = "Phone cannot be blank."
            return false
        } else {
            if (Validation1.isValidPhone(testPhoneNumber: self.contactPhoneTextfield.text!.replacingOccurrences(of: "-", with: ""))) {
                self.contactPhoneErrLabel.isHidden = false
                self.contactPhoneErrLabel.text = "Invalid Phone Number."
            } else {
                self.contactPhoneErrLabel.isHidden = true
            }
        }
        
        if self.usersCountTextField.text == "" {
            self.usersCountErrLabel.isHidden = false
            self.usersCountErrLabel.text = "Users Count cannot be blank."
            return false
        } else {
            if (Validation1.isValidNumber(number: self.usersCountTextField.text!)) {
                self.usersCountErrLabel.isHidden = true
            } else {
                self.usersCountErrLabel.isHidden = false
                self.usersCountErrLabel.text = "Enter valid number."
            }
        }
        
        if self.devicesTextField.text == "" {
            self.devicesCountErrLabel.isHidden = false
            self.devicesCountErrLabel.text = "Device Count cannot be blank."
            return false
        } else {
            if (Validation1.isValidNumber(number: self.devicesTextField.text!)) {
                self.devicesCountErrLabel.isHidden = true
            } else {
                self.devicesCountErrLabel.isHidden = false
                self.devicesCountErrLabel.text = "Enter valid number."
            }
        }
        
        if self.extensionTextField.text == "" {
            return false
        } else {
            if (!Validation1.isValidNumber(number: self.extensionTextField.text!)) {
                return false
            }
        }
        
        if self.zipCodeTextField.text == "" {
            return false
        } else {
            if (!Validation1.isValidNumber(number: self.zipCodeTextField.text!)) {
                return false
            }
        }
        
        if self.industryTextField.text == "" {
            self.industryErrLabel.isHidden = false
            return false
        } else {
            self.industryErrLabel.isHidden = true
        }
        
        return true
    }
    
    
    func callEnterpriseAPI(){
        let apiURL     = URLConstant.BaseUrl + URLConstant.proAccount
        let dictionary = createPostDictionary()
        
        _ = BillingInfo().billingInfo(apiURL, postData: dictionary as [String : AnyObject], withSuccessHandler: { (userModel) in
            
            let storyboard = UIStoryboard(name: FontAndStoryBoardname.storyboardName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SuccessController") as! SuccessController
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc , animated: true, completion: nil)
            
        }, withFailureHandlere: { (error: String) in
            self.view.makeToast(error, duration: 2.0, position: .center)
        })
    }
    
    func createPostDictionary() -> Dictionary<String,String> {
        
        var cra_flag = "0",ls_flag = "0", wl_flag = "0"
        
        if isPlanOneSelected{
            cra_flag = "1"
        }
        if isPlanTwoSelected{
            ls_flag = "1"
        }
        if isPlanThreeSelected{
            wl_flag = "1"
        }
        
        let postDict = ["company_name" : companyNameTextField.text!,
                        "contact" : contactNameTextField.text!,
                        "city" : cityTextField.text!,
                        "state" : stateTextField.text!,
                        "phone":contactPhoneTextfield.text!,
                        "email" : contactEmailTextField.text!,
                        "users_count":usersCountTextField.text!,
                        "device_count":devicesTextField.text!,
                        "industry":industryTextField.text! ,
                        "cra_flag":cra_flag,
                        "ls_flag": ls_flag,
                        "wl_flag":wl_flag,
                        "zipcode": zipCodeTextField.text!,
                        "extension":extensionTextField.text! ] as  Dictionary<String,String>
        
        return postDict
        
    }
    
    //MARK: - Events
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func requestQuoteButtonClicked(_ sender: Any) {
        
        if isAllTextFieldValid() {
            callEnterpriseAPI()
            //            let storyboard = UIStoryboard(name: "RegisterFlow", bundle: nil)
            //            let setUpProfessionalPopUpViewController = storyboard.instantiateViewController(withIdentifier: "SetUpProfessionalPopUpViewController") as? SetUpProfessionalPopUpViewController
            //            setUpProfessionalPopUpViewController?.delegate = self
            //            self.navigationController?.present(setUpProfessionalPopUpViewController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func planOneButtonClicked(_ sender: Any) {
        
        if isPlanOneSelected {
            btnPlanOne.setImage(UIImage(named: "RadioUnsel"), for: .normal)
            isPlanOneSelected = false
        } else {
            btnPlanOne.setImage(UIImage(named: "RadioSel"), for: .normal)
            isPlanOneSelected = true
        }
        
    }
    
    @IBAction func planTwoButtoClicked(_ sender: Any) {
        
        if isPlanTwoSelected {
            btnPlanTwo.setImage(UIImage(named: "RadioUnsel"), for: .normal)
            isPlanTwoSelected = false
        } else {
            btnPlanTwo.setImage(UIImage(named: "RadioSel"), for: .normal)
            isPlanTwoSelected = true
        }
    }
    
    @IBAction func planThreeButtonClicked(_ sender: Any) {
        
        if isPlanThreeSelected {
            btnPlanThree.setImage(UIImage(named: "RadioUnsel"), for: .normal)
            isPlanThreeSelected = false
        } else {
            btnPlanThree.setImage(UIImage(named: "RadioSel"), for: .normal)
            isPlanThreeSelected = true
        }
    }
    
}

extension RequestQuoteViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        self.checkTextFieldValidation(tag: textField.tag)
        
        // Do not add a line break
        return false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == contactPhoneTextfield{
            
                let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789").inverted) == nil
                
                if !replacementStringIsLegal
                {
                    return false
                }
                
                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                let components = newString.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted)
                
                let decimalString = components.joined(separator: "") as NSString
                let length = decimalString.length
                let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
                
        
                if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
                {
                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                    
                    return (newLength > 10) ? false : true
                }
                var index = 0 as Int
                let formattedString = NSMutableString()
                
                if hasLeadingOne
                {
                    formattedString.append("1 ")
                    index += 1
                }
                if length - index > 3 //magic number separata every four characters
                {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                    formattedString.appendFormat("%@-", prefix)
                    index += 3
                }
                
                if length - index > 3
                {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                    formattedString.appendFormat("%@-", prefix)
                    index += 3
                }
            
                let remainder = decimalString.substring(from: index)
                formattedString.append(remainder)
                textField.text = formattedString as String
                return false
                
            }
        return true

        }
    
    
}

extension RequestQuoteViewController: SetUpProfessionalDelegate {
    
    func didClosePopUpWithOption(selectedOption: String) {
        
        if selectedOption == "setUpProfessional" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SetupProfileController") as! SetupProfileController
            vc.strFlg = "AccessCode"
            appDelegate.plan = "HM"
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if let loginViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController = loginViewController
                }
            }
        }
    }
}

extension RequestQuoteViewController: SuccessControllerDelegate {
    func hiddenblurrViewOnSetupProfile() {
        
    }

    func gotoLoginAfterSignUp() {
       self.navigationController?.popToRootViewController(animated: true)
    }
}

