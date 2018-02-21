//
//  CardInfoController.swift
//  LYNKD
//
//  Created by Apple on 23/11/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit

class CardInfoController: UIViewController {
    // MARK: - IBOutlet
    var customPicker: UIPickerView!
    @IBOutlet weak var lblErrorCommonMsg: UILabel!
    @IBOutlet var viewOnScroll: UIView!
    @IBOutlet var imgProgessbar: UIImageView!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var txtCardNum: UITextField!
    @IBOutlet var txtYear: UITextField!
    @IBOutlet var topView: UIView!
    @IBOutlet var txtSecurityCode: UITextField!
    @IBOutlet var cardName: UITextField!
    @IBOutlet weak var txtCardName: JVFloatLabeledTextField!
    @IBOutlet weak var txtBillingAdd1: JVFloatLabeledTextField!
    @IBOutlet weak var txtBillingAdd2: JVFloatLabeledTextField!
    @IBOutlet weak var txtZip: JVFloatLabeledTextField!
    @IBOutlet weak var txtState: JVFloatLabeledTextField!
    @IBOutlet weak var txtCity: JVFloatLabeledTextField!
   
    @IBOutlet weak var viewOfBlurr: UIView!
    @IBOutlet var imgHorizontalStrip: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
     @IBOutlet weak var btnSubmit: UIButton!
     @IBOutlet weak var btnSkip: UIButton!
     @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var viewBtn: UIView!

    var flgBtn = ""
    
    // MARK: - Custum Variable
    
    var btnNextAbvKey: UIButton?
    var btnNextAbv: UIButton!
    var strPortalAccountName = ""
    var strUserEmail = ""
    var imgProfile: UIImage?
    var isProfileImageSelected = false
    var signUpDictData = [String: Any]()
    var flgViewCntroller = ""
    var strBillingaddress1 = ""
    var strBillingaddress2 = ""
    var strCity = ""
    var strZipcode = ""
    var strState = ""
    var strCountry = ""
    var strSelectedMonth = ""
    var strSelectedyear = ""
    var keyboardToolbar: UIToolbar!
    var flgTxtField = ""
    var accept: UIBarButtonItem!
    var arrayOFMonths = [String]()
    var arrayOfYear = [String]()
    var blurEffectView: UIVisualEffectView!
    var KeyBoardheight: Int = 0
    let expiryDatePicker = MonthYearPickerView()
    
    // MARK: - Viewcontroller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.tabBarController?.tabBar.isHidden = true
        btnSubmit.isUserInteractionEnabled = true
        
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            let string = String(format: "%02d/%d", month, year)
            NSLog(string) // should show something like 05/2015
            self.strSelectedMonth = String(month)
            self.strSelectedyear = String(year)
            self.txtYear.text  = string
        }
        
        txtCardNum.text = ""
        txtYear.text = ""
        txtSecurityCode.text = ""
        flgTxtField = "cardNum"
        createToolBar()
        arrayOfYear = [String]()
        arrayOFMonths = arrayOfYear
        arrayOFMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        //---------
        let date = Date()
        let units: Set<Calendar.Component> = [.hour, .day, .month, .year]
        let comps = Calendar.current.dateComponents(units, from: date)
        
        let year = comps.year
        var currentYear: Int = year!
        for _ in 0..<10 {
            currentYear = (currentYear + 1)
            arrayOfYear.append("\(currentYear)")
        }
        txtYear.text = ""
        txtSecurityCode.text = ""
        ///pavan----shailendra
        navigationController?.isNavigationBarHidden = true
        //   [self createNavigationBar];
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        gestureRecognizer.numberOfTapsRequired = 1
        viewOnScroll.addGestureRecognizer(gestureRecognizer)
        if (flgViewCntroller == "Home") {
            imgProgessbar.image = UIImage(named: "progressive-bar1")
            lblSubtitle.text = "My Home | Billing Info"
            btnSubmit.backgroundColor = UIColor(red: 216.0 / 255.0, green: 216.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
            btnSubmit.isUserInteractionEnabled = false
            btnSubmit.setTitle("Save", for: .normal)
            
            viewBtn.isHidden = true
            btnSubmit.isHidden = false
        }
        else if (flgViewCntroller == "Card") {
            imgProgessbar.image = UIImage(named: "progressive-bar9")
            if SessionDataManager.shared().isSignupFlowFromAccessCode {
                btnSubmit.isHidden = true
                viewBtn.isHidden = false
            }else{
                viewBtn.isHidden = true
                btnSubmit.isHidden = false
            }
        }
        self.stopIndicator()
    }
    override  func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    // MARK: - Custum Methods
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        let touch = touches.first
        if touch?.phase == .began {
            view.endEditing(true)
            btnDonePicker((Any).self)
        }
    }
    
    func startIndicator()   {
        DispatchQueue.main.async {
            self.imgHorizontalStrip.isHidden = true
            let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "horizontalStrip12", withExtension: "gif")!)
            self.imgHorizontalStrip.image = UIImage.gif(data: imageData)
        }
        
    }
    func stopIndicator()   {
        DispatchQueue.main.async {
            self.imgHorizontalStrip.isHidden = true
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        btnDonePicker((Any).self)
        if(txtYear.text == "" && flgTxtField == "txtYear"){
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            txtYear.text = "\(month)/\(year)"
            //  print( "\(year),,,\(month)")
        }
        
    }
    func blurrEffect() {
        viewOfBlurr.isHidden = false
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            viewOfBlurr.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: .dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = viewOfBlurr.bounds
            //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewOfBlurr.addSubview(blurEffectView)
        }
        else {
            viewOfBlurr.backgroundColor = UIColor.black
        }
    }
    func returnMonthNumber(usingMonth monthName: String) -> String {
        arrayOFMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        if (monthName == "Jan") {
            return "01"
        }
        if (monthName == "Feb") {
            return "02"
        }
        if (monthName == "Mar") {
            return "03"
        }
        if (monthName == "Apr") {
            return "04"
        }
        if (monthName == "May") {
            return "05"
        }
        if (monthName == "Jun") {
            return "06"
        }
        if (monthName == "Jul") {
            return "07"
        }
        if (monthName == "Aug") {
            return "08"
        }
        if (monthName == "Sep") {
            return "09"
        }
        if (monthName == "Oct") {
            return "10"
        }
        if (monthName == "Nov") {
            return "11"
        }
        if (monthName == "Dec") {
            return "12"
        }
        else {
            return "0"
        }
        return "0"
    }
    
    //---Create Toolbar---
    func createToolBar() {
        keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 60))
        keyboardToolbar.backgroundColor = UIColor(red: 175.0 / 255.0, green: 179.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
        //textFieldTintColor;
        let extraSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accept = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(self.closeKeyboard))
        accept.tintColor = UIColor.black
        keyboardToolbar.items = [extraSpace, accept]
    }
    
    @objc func closeKeyboard(_ sender: Any) {
        keyboardToolbar.isHidden   = true
        if (flgTxtField == "cardNum") {
            txtCardNum.resignFirstResponder()
            txtYear.becomeFirstResponder()
        }else if(flgTxtField == "txtYear"){
            expiryDatePicker.removeFromSuperview()
            txtSecurityCode.becomeFirstResponder()
        }
        else if (flgTxtField == "secCode") {
            txtCardName.becomeFirstResponder()
        }
        else if (flgTxtField == "zip") {
            // startAnimating()
            //            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            //                DispatchQueue.main.async(execute: {() -> Void in
            //                    self.getCityAndState(txtZip.text)
            //                })
            //            })
            txtState.becomeFirstResponder()
        }
        
    }
    func  btnNxtAbvKeyboardDesign(title:String){
        
        if (flgViewCntroller == "Home") {
            btnNextAbv = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
            btnNextAbv?.addTarget(self, action: #selector(abvKeyboardBtnPress), for: .touchUpInside)
            btnNextAbv.setTitle(title, for: .normal)
            btnNextAbv.titleLabel?.font = FontAndStoryBoardname.fontBtn
        }
        else if (flgViewCntroller == "Card") {
            if (flgTxtField == "CardName" || flgTxtField == "Address1" || flgTxtField == "Address2" ){
                btnNextAbv = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
            }else{
                btnNextAbv = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
            }
            btnNextAbv?.addTarget(self, action: #selector(abvKeyboardBtnPress), for: .touchUpInside)
            btnNextAbv.setTitle(title, for: .normal)
            btnNextAbv.titleLabel?.font = FontAndStoryBoardname.fontBtn
        }
    }
    func btnEnableDisableFuntionality(){
        
        if  true == true {
            btnSubmit.backgroundColor = color.btnSelColor
            btnSubmit.isUserInteractionEnabled = true
            btnNextAbv.backgroundColor = color.btnSelColor
            btnSubmit.isUserInteractionEnabled = true
        }else{
            btnSubmit.backgroundColor = color.btnUnSelColor
            btnSubmit.isUserInteractionEnabled = false
            btnNextAbv.backgroundColor = color.btnUnSelColor
            btnSubmit.isUserInteractionEnabled = false
        }
    }
    @objc func  abvKeyboardBtnPress(){
        if (flgViewCntroller == "Home") {
            self.navigationController?.popViewController(animated: true)
        }
        else if (flgViewCntroller == "Card") {
            self.btnSubmitPress(btnSubmit)
        }
    }
    
    @objc  func datePickerValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        //  dobTxtField.text = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //  dob = dateFormatter.string(from: sender.date)
    }
    func btnEnable(){
        btnNextAbv.isUserInteractionEnabled = true
        btnNextAbv.backgroundColor = color.btnSelColor
        
        btnSubmit.isUserInteractionEnabled = true
        btnSubmit.backgroundColor = color.btnSelColor
    }
    func btnDisable(){
        btnNextAbv.isUserInteractionEnabled = false
        btnNextAbv.backgroundColor = color.btnUnSelColor
        
        btnSubmit.isUserInteractionEnabled = false
        btnSubmit.backgroundColor = color.btnUnSelColor
    }
    
    func checkBtn(){
        if (flgViewCntroller == "Home") {
               btnEnable()
        }
        else if (flgViewCntroller == "Card") {
            
        }
    }
}


// MARK: - IBAction Methods

extension CardInfoController {
    
    @IBAction func btnBackPress(_ sender: Any) {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSkipPress(_ sender: Any) {
       
       flgBtn = "skip"
       self.callCardInfoAPI()
        
    }
    
    @IBAction func btnNextPress(_ sender: Any) {
         self.checkValidation()
    }
   
    func startAnimating() {
        // startActivityIndicator()
    }
    
    func stopAnimating() {
        //stopActivityIndicator()
    }
    
    
    func checkValidation(){
        
        if txtCardNum.text!.hasPrefix("3"){
            if txtCardNum.text?.count != 17 {
                self.view.makeToast("Please enter the valid card number")
            }else{
                checkTxtField()
            }
        }
        else if txtCardNum.text?.count != 19 {
            self.view.makeToast("Please enter the valid card number")
        }
        else if (txtYear.text == "") {
            self.view.makeToast("Please select expiration date")
            
        }
        else if (txtSecurityCode.text == "") {
            self.view.makeToast("Please enter the security code")
        }
        else if txtCardName.text?.count == 0 {
            //lblErrorCommonMsg.text =
            self.view.makeToast("Please enter the card name")
        }
            
        else if txtCardNum.text!.hasPrefix("3"){
            if (txtSecurityCode.text?.count)! < 4  {
                self.view.makeToast("Security code must be 4 digits")
            }else{
                checkTxtField2()
            }
        }
        else if (txtSecurityCode.text?.count)! < 3  {
            self.view.makeToast("Security code must be 3 digits")
        }
        else if (txtBillingAdd1.text == "") {
            self.view.makeToast("Please enter the address")
        }
        else if (txtZip.text == "") {
            self.view.makeToast("Please enter the zip code")
        }
        else if (txtState.text == "") {
            self.view.makeToast("Please enter the state")
        }
        else if (txtCity.text == "") {
            self.view.makeToast("Please enter the city")
        }
        else {
            lblErrorCommonMsg.isHidden = true
            self.startIndicator()
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                self.flgBtn = "next"
                self.callCardInfoAPI()
                
            })
        }
    }
    @IBAction func btnSubmitPress(_ sender: Any) {
    
        
        if (flgViewCntroller == "Home") {
            self.navigationController?.popViewController(animated: true)
        }
        else if (flgViewCntroller == "Card") {
            self.checkValidation()
        }
    }
    
    @IBAction func btnDonePicker(_ sender: Any) {
        view.endEditing(true)
        if strSelectedMonth.count != 0 && strSelectedyear.count != 0 {
            flgTxtField = "secCode"
            //    [_txtSecurityCode becomeFirstResponder];
            // topView.isHidden = true
            txtYear.text = "\(strSelectedMonth)/\(strSelectedyear)"
        }
    }
    
    @IBAction func btnYear(_ sender: Any) {
        view.endEditing(true)
        flgTxtField = "cardNum"
        // topView.isHidden = false
    }
    
    @IBAction func btnMonth(_ sender: Any) {
        view.endEditing(true)
        flgTxtField = "cardNum"
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        var components = DateComponents()
        
        components.year = -100
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        components.year = 0
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        
        datePickerView.minimumDate = minDate
        datePickerView.maximumDate = maxDate
        
        txtYear.becomeFirstResponder()
        txtYear.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func createPostDictionary(strCardNumber:String) -> Dictionary<String,String> {
        
        let user_id =   String(format: "%@",  UserDefaultUtils.retriveObjectForKey(userDefaults.user_ID) as! CVarArg)
        let private_key = String(format: "%@",  UserDefaultUtils.retriveObjectForKey(userDefaults.private_Key) as! CVarArg)
        let portal_Account_ID = String(format: "%@",  UserDefaultUtils.retriveObjectForKey(userDefaults.portal_Account_ID) as! CVarArg)
    
        if SessionDataManager.shared().isSignupFlowFromAccessCode{
            if flgBtn == "skip"{
                let postDict = [ "user_id":user_id, // user_id,
                    "private_key":  private_key,// private_key,
                    "name_card": Validation1.checkNotNullParameterWithReturnString(checkStr: txtCardName.text!),
                    "billing_address": Validation1.checkNotNullParameterWithReturnString(checkStr: txtBillingAdd1.text!),
                    "city": Validation1.checkNotNullParameterWithReturnString(checkStr: txtCity.text!), "state": Validation1.checkNotNullParameterWithReturnString(checkStr: txtState.text!), "expiry_month": strSelectedMonth,
                    "expiry_year": strSelectedyear,
                    "card_number": strCardNumber, "cvv": Validation1.checkNotNullParameterWithReturnString(checkStr: txtSecurityCode.text!), "billing_address2": Validation1.checkNotNullParameterWithReturnString(checkStr: txtBillingAdd2.text!),
                    "zip_code": Validation1.checkNotNullParameterWithReturnString(checkStr: txtZip.text!),
                    "portal_account_id":portal_Account_ID,
                    "acess_code":appDelegate.accessCode,
                    "skipFlag":"1",
                    "accessCodeId":SessionDataManager.shared().accessCodeID] as!  Dictionary<String,String>
                    return postDict
            }else{
                
                let postDict = [ "user_id":user_id, // user_id,
                    "private_key":  private_key,// private_key,
                    "name_card": Validation1.checkNotNullParameterWithReturnString(checkStr: txtCardName.text!),
                    "billing_address": Validation1.checkNotNullParameterWithReturnString(checkStr: txtBillingAdd1.text!),
                    "city": Validation1.checkNotNullParameterWithReturnString(checkStr: txtCity.text!), "state": Validation1.checkNotNullParameterWithReturnString(checkStr: txtState.text!), "expiry_month": strSelectedMonth,
                    "expiry_year": strSelectedyear,
                    "card_number": strCardNumber, "cvv": Validation1.checkNotNullParameterWithReturnString(checkStr: txtSecurityCode.text!), "billing_address2": Validation1.checkNotNullParameterWithReturnString(checkStr: txtBillingAdd2.text!),
                    "zip_code": Validation1.checkNotNullParameterWithReturnString(checkStr: txtZip.text!),
                    "portal_account_id":portal_Account_ID,
                    "acess_code":appDelegate.accessCode,
                    "skipFlag":"0"] as!  Dictionary<String,String>
                return postDict
            }
           
        }else{
            
            let postDict = [ "user_id":user_id, // user_id,
                "private_key":  private_key,// private_key,
                "name_card": Validation1.checkNotNullParameterWithReturnString(checkStr: txtCardName.text!),
                "billing_address": Validation1.checkNotNullParameterWithReturnString(checkStr: txtBillingAdd1.text!),
                "city": Validation1.checkNotNullParameterWithReturnString(checkStr: txtCity.text!), "state": Validation1.checkNotNullParameterWithReturnString(checkStr: txtState.text!), "expiry_month": strSelectedMonth,
                "expiry_year": strSelectedyear,
                "card_number": strCardNumber, "cvv": Validation1.checkNotNullParameterWithReturnString(checkStr: txtSecurityCode.text!), "billing_address2": Validation1.checkNotNullParameterWithReturnString(checkStr: txtBillingAdd2.text!),
                "zip_code": Validation1.checkNotNullParameterWithReturnString(checkStr: txtZip.text!),
                "portal_account_id":portal_Account_ID,
                "acess_code":appDelegate.accessCode,
                "skipFlag":"0"] as!  Dictionary<String,String>
            return postDict
        }
        
       
        
    }
    
    func callCardInfoAPI() {
        var strCardNumber: String = ""
       ///DispatchQueue.main.async {
            strCardNumber  = self.txtCardNum.text!
        //}
        strCardNumber = strCardNumber.replacingOccurrences(of: "-", with: "")
        self.startIndicator()
        let dictionary = self.createPostDictionary(strCardNumber: strCardNumber)
        let apiURL = URLConstant.BaseUrl + URLConstant.BillingInfo
        _ = BillingInfo().billingInfo(apiURL, postData: dictionary as [String : AnyObject], withSuccessHandler: { (userModel) in
            
                self.appDelegate.accessCode = ""
                let storyboard = UIStoryboard(name: FontAndStoryBoardname.storyboardName, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "SuccessController") as! SuccessController
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc , animated: true, completion: nil)
                self.stopIndicator()
                self.flgBtn = ""
       
        }, withFailureHandlere: { (error: String) in
            self.view.makeToast(error, duration: 2.0, position: .center)
            self.stopIndicator()
            self.flgBtn = ""
        })
        
    }
    
    func checkTxtField(){
        let cardNum = txtCardNum.text!
        if (txtYear.text == "") {
            self.view.makeToast("Please select expiration date")
            
        }
        else if (txtSecurityCode.text == "") {
            self.view.makeToast("Please enter the security code")
        }
        else if cardNum.hasPrefix("3"){
            if (txtSecurityCode.text?.count)! < 4  {
                self.view.makeToast("Security code must be 4 digits")
            }else{
                checkTxtField2()
            }
        }
        else if (txtSecurityCode.text?.count)! < 3  {
            self.view.makeToast("Security code must be 3 digits")
        }
        else if (txtBillingAdd1.text == "") {
            self.view.makeToast("Please enter the address")
        }
        else if (txtZip.text == "") {
            self.view.makeToast("Please enter the zip code")
        }
        else if (txtState.text == "") {
            self.view.makeToast("Please enter the state")
        }
        else if (txtCity.text == "") {
            self.view.makeToast("Please enter the city")
            
        }
        else {
            lblErrorCommonMsg.isHidden = true
            self.startIndicator()
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                self.callCardInfoAPI()
            })
        }

    }
    func checkTxtField2(){
        
        if (txtBillingAdd1.text == "") {
            self.view.makeToast("Please enter the address")
        }
        else if (txtZip.text == "") {
            self.view.makeToast("Please enter the zip code")
        }
        else if (txtState.text == "") {
            self.view.makeToast("Please enter the state")
        }
        else if (txtCity.text == "") {
            self.view.makeToast("Please enter the city")
        }
        else {
            lblErrorCommonMsg.isHidden = true
            self.startIndicator()
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                self.callCardInfoAPI()
            })
        }
    }
}


// MARK: - UIPickerViewDelegate And Datasource Methods
extension CardInfoController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return arrayOFMonths.count
        }
        else {
            return arrayOfYear.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return arrayOFMonths[row]
        }
        else {
            return arrayOfYear[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            strSelectedMonth = arrayOFMonths[row]
        }
        else {
            strSelectedyear = arrayOfYear[row]
        }
    }
}

// MARK: - UItextFieldDelegate Methods
extension CardInfoController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 60))
        keyboardToolbar.isHidden   = false
        
        if (flgViewCntroller == "Home") {
            btnNxtAbvKeyboardDesign(title:"Save")
            btnEnableDisableFuntionality()
            
            if textField == txtYear {
                flgTxtField = "txtYear"
                txtYear.inputView = expiryDatePicker
                // accessoryView.addSubview(keyboardToolbar)
            }
        }
        else if (flgViewCntroller == "Card") {
            if textField == txtCardNum {
                flgTxtField = "cardNum"
                btnNxtAbvKeyboardDesign(title:"Next")
                btnEnableDisableFuntionality()
                accept.title = "Next"
                //  accessoryView.addSubview(keyboardToolbar)
                // textField.inputAccessoryView = keyboardToolbar
                
            }else if textField == txtYear {
                flgTxtField = "txtYear"
                btnNxtAbvKeyboardDesign(title:"Next")
                btnEnableDisableFuntionality()
                accept.title = "Next"
                txtYear.inputView = expiryDatePicker
                // accessoryView.addSubview(keyboardToolbar)
                
            }else if textField == txtCardName {
                flgTxtField = "CardName"
                btnNxtAbvKeyboardDesign(title:"Next")
                btnEnableDisableFuntionality()
                accept.title = "Next"
            }
            else if textField == txtSecurityCode {
                flgTxtField = "secCode"
                btnNxtAbvKeyboardDesign(title:"Next")
                btnEnableDisableFuntionality()
                accept.title = "Next"
                //accessoryView.addSubview(keyboardToolbar)
            }else if textField == txtBillingAdd1 {
                flgTxtField = "Address1"
                btnNxtAbvKeyboardDesign(title:"Next")
                btnEnableDisableFuntionality()
            }else if textField == txtBillingAdd2 {
                flgTxtField = "Address2"
                btnNxtAbvKeyboardDesign(title:"Next")
                btnEnableDisableFuntionality()
            }
            else if textField == txtZip {
                flgTxtField = "zip"
                btnNxtAbvKeyboardDesign(title:"Next")
                btnEnableDisableFuntionality()
                accept.title = "Next"
                //accessoryView.addSubview(keyboardToolbar)
                // textField.inputAccessoryView = keyboardToolbar
            }
            else {
                btnNxtAbvKeyboardDesign(title:"Next")
                btnEnableDisableFuntionality()
                //accessoryView.addSubview(keyboardToolbar)
                textField.inputView = customPicker;
            }
            //checkBtn()
        }
        
        if !SessionDataManager.shared().isSignupFlowFromAccessCode {
            accessoryView.addSubview(btnNextAbv)
            textField.inputAccessoryView = accessoryView
        }
       
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newStr: String? = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if(txtZip == textField){
                txtState.text = ""
                txtCity.text = ""
            if newStr!.count > 3{
                  self.getCityAndState(newStr!)
            }
            return true
        }
        else if(txtCardNum  == textField){
            let replacementStringIsLegal = string.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789").inverted) == nil
            
            if !replacementStringIsLegal
            {
                return false
            }
            
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if newString.hasPrefix("3"){
                let components = newString.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted)
                
                let decimalString = components.joined(separator: "") as NSString
                let length = decimalString.length
                let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
                
                if length == 0 || (length > 15 && !hasLeadingOne) || length > 17
                {
                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                    return (newLength > 15) ? false : true
                }
                var index = 0 as Int
                let formattedString = NSMutableString()
                
                if hasLeadingOne
                {
                    formattedString.append("1 ")
                    index += 1
                }
                if length - index > 4 //magic number separata every four characters
                {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                    formattedString.appendFormat("%@-", prefix)
                    index += 4
                }
                
                if length - index > 6
                {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 6))
                    formattedString.appendFormat("%@-", prefix)
                    index += 6
                }
                
         
                let remainder = decimalString.substring(from: index)
                formattedString.append(remainder)
                textField.text = formattedString as String
                return false
            }else{
                
                let components = newString.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted)
                
                let decimalString = components.joined(separator: "") as NSString
                let length = decimalString.length
                let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
                
                if length == 0 || (length > 16 && !hasLeadingOne) || length > 19
                {
                    let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                    return (newLength > 16) ? false : true
                }
                var index = 0 as Int
                let formattedString = NSMutableString()
                
                if hasLeadingOne
                {
                    formattedString.append("1 ")
                    index += 1
                }
                if length - index > 4 //magic number separata every four characters
                {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                    formattedString.appendFormat("%@-", prefix)
                    index += 4
                }
                
                if length - index > 4
                {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                    formattedString.appendFormat("%@-", prefix)
                    index += 4
                }
                if length - index > 4
                {
                    let prefix = decimalString.substring(with: NSMakeRange(index, 4))
                    formattedString.appendFormat("%@-", prefix)
                    index += 4
                }
                
                
                let remainder = decimalString.substring(from: index)
                formattedString.append(remainder)
                textField.text = formattedString as String
                return false
            }
            
        } else if(txtSecurityCode == textField){
            if (txtCardNum.text?.hasPrefix("3"))!{
                if Int(newStr!.count) > 4{
                    return false
                }
            }else{
                if Int(newStr!.count) > 3{
                    return false
                }
            }
            
        }else if(txtState == textField){
            if Int(newStr!.count)  > 2{
                return false
            }
        }
      
        if (flgViewCntroller == "Home") {
            btnSubmit.backgroundColor = UIColor(red: 61.0 / 255.0, green: 142.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
            btnSubmit.isUserInteractionEnabled = true
            btnSubmit.setTitle("Save", for: .normal)
        }
        else if (flgViewCntroller == "Card") {
           
        }
        
        lblErrorCommonMsg.isHidden = true
     
        checkBtn()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtCardName {
            txtBillingAdd1.becomeFirstResponder()
        }else if textField == txtCardNum {
            txtYear.becomeFirstResponder()
        }
        else if textField == txtBillingAdd1 {
            txtBillingAdd2.becomeFirstResponder()
        }
        else if textField == txtBillingAdd2 {
            txtZip.becomeFirstResponder()
        }
        else if textField == txtState {
            txtCity.becomeFirstResponder()
        }
        else if textField == txtCity {
            view.endEditing(true)
        }
        else {
            view.endEditing(true)
        }
        checkBtn()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkBtn()
        keyboardToolbar.isHidden   = true
    }
    
}

// MARK: - SuccessControllerDelegate Methods
extension CardInfoController: SuccessControllerDelegate {
    func hiddenblurrViewOnSetupProfile() {
        
    }
    
    func gotoLoginAfterSignUp() {
        viewOfBlurr.isHidden = true
        var isAvailable = false
        for viewController: UIViewController in (navigationController?.viewControllers)! {
            if (viewController is ViewController) {
                isAvailable = true
                navigationController?.popToViewController(viewController, animated: false)
            }
        }
        if isAvailable == false {
            // let alert = storyboard.instantiateViewController(withIdentifier: "AlertLogin") as? AlertLogin
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func getCityAndState(_ zipcode: String) {
        
        let strBaseUrl = "https://maps.googleapis.com/maps/api/geocode/json?address=\(zipcode)&sensor=true&key=AIzaSyDlqlHJ_k8YcvJ4_RUxng0pyDF8NQPTIW8"
        
        _ = GetCityStateProxy().getCityStateProxy(strBaseUrl,
                                                  postData:["":""] as [String : AnyObject],
                                                  withSuccessHandler: { (response) in
                                                    let dictResponse = response as? [AnyHashable: Any]
                                                    
                                                    if (dictResponse!["status"] as! String == "OK") {
                                                        self.parseThedatawithDictionary(dictResponse!)
                                                        //Parse the data
                                                    }
                                                    else if (dictResponse?["status"] as! String == "ZERO_RESULTS") {
                                                        self.view.makeToast("Invalid Zip-code!")
                                                         self.txtCity.text = ""
                                                          self.txtState.text = ""
                                                        // strCountry.text = ""
                                                    }
                                                    
        }, withFailureHandlere: { (error: String) in
            self.view.makeToast(error, duration: 2.0, position: .center)
        })
    }
    
    func parseThedatawithDictionary(_ dicOfData: [AnyHashable: Any]) {
        var address_components = [AnyHashable]()
        address_components = dicOfData["results"] as! [AnyHashable]
        if address_components.count > 0 {
            var resultsValue = address_components[0] as? [String: AnyHashable]
            if resultsValue?.count != 0 {
                var addressComponentvalues = resultsValue!["address_components"]as! [AnyHashable]
                txtCity.text = ""
                txtState.text = ""
                for j in 0..<addressComponentvalues.count {
                    var temp = addressComponentvalues[j] as? [String: AnyHashable]
                    let type =  temp!["types"] as? [Any]
                    for i in 0..<type!.count {
                        let typeVal = type![i] as! String
                        if (typeVal == "locality") {
                            txtCity.text = temp!["long_name"] as? String ?? ""
                            //print("\(String(describing: temp!["long_name"]))")
                        }
                        //Get The State Name
                        if (typeVal == "administrative_area_level_1") {
                           txtState.text = temp!["long_name"] as? String ?? ""
                            //print("\(String(describing: temp!["long_name"]))")
                        }
                        //Get The Country Name
                        if (typeVal == "country") {
                            // txtCountry.text = "\(type[j]["long_name"])"
                            print("\(String(describing: temp!["long_name"]))")
                        }
                    }
                }
            }
        }
    }
}

