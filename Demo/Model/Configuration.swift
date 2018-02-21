//
//  Configuration.swift
//  MalaBes
//
//  Created by PUNDSK006 on 4/18/17.
//  Copyright © 2017 Intechcreative Pvt. Ltt. All rights reserved.
//

import Foundation
import UIKit


// URL Struct

struct Url
{
    //static let baseURL = "http://103.51.153.235/bosnia/backend/web/index.php/api/"   // Pune server
    //static let baseURL = "http://27.109.19.234/bosnia/backend/web/index.php/api/"   // Ahmadabad server
    static let baseURL = "http://54.218.40.65/lynkd/backend/web/api2/"   //Live link 28/7
    static let autocompleteLocationApi = "https://maps.googleapis.com/maps/api/place/autocomplete/json?types=establishment&language=eng&key=\(string.googleAPIKeyForGeoCode)&input="
     static var deviceUDID  =  "9ff0c421de3a073f990f14d3d298778ea9037c6cb6a575045b3c588344b4e6"
    static let getAddressApi = "https://maps.googleapis.com/maps/api/geocode/json?key=\(string.googleAPIKeyForGeoCode)&latlng="
    static let getLatLongApi = "https://maps.googleapis.com/maps/api/place/details/json?key=\(string.googleAPIKeyForGeoCode)&sensor=false&reference="
    // static let dashBoard = "http://54.218.40.65/lynkd/backend/web/api2/getdashboardscreen?portal_account_id=" CHAITANYA
    static let dashBoard = "https://app.lynkd.com/lynkd/backend/web/api2/getdashboardscreen?portal_account_id="
    
}

// MARK: static String Data

struct string  {
    // user_type = "1";//1=agent, 2=seller, 3=buyer
    static let userAgent = "1"
    static let userSeller = "2"
    static let userBuyer = "3"
    
    static let arrMenuTab : Array<String> = ["HOME", "CATEGORY","STORE"]   
    static var noInternetConnMsg = NSLocalizedString("No Internet", comment: "")
    static var noInternateMessage2 = NSLocalizedString("Please check your internet connection", comment: "")
    static var noDataFoundMsg = NSLocalizedString("We didn't find any properties", comment: "")
    static var noDataFoundMsgForSaveSearch = NSLocalizedString("We didn't find any searches", comment: "")
    static var noDataFoundMsgForDetal = NSLocalizedString("We didn't find any information for this property", comment: "")
    static var oppsMsg = NSLocalizedString("OOPS!", comment: "")
    static var someThingWrongMsg = NSLocalizedString("something went wrong, Please try again later", comment: "")
    
    static let googleAPIKey = "AIzaSyDElNzttQbP76lkdR75_x5ucvL_aX2R_7o" //"AIzaSyC33uHNkqBJV4KTVgUN5cX9Oem_yl6yJ7A"
    static let googleAPIKeyForGeoCode = "AIzaSyBbY8F3JLtyWXvkNklhSDLi9QoUFktN208" //"AIzaSyBJMf03e66En0D08uW3mybyFfjz8mn6KZc"
}

struct user {
    static var username = ""
    static var user_id = ""
    static var userimage = ""
    static var login_type = ""
    static var email = ""
    static var password = ""
    static var isLoggedIn = Bool()
    static var flagAfterScreen = "login"
    static var privateKey = ""
    static var accountPortalId = ""

}

// MARK: Color--------------------------------------------------

struct color  {
    static let theamColor = UIColor(red: 60.0/255.0, green: 142.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    static let btnSelColor = UIColor(red: 72.0/255.0, green: 140.0/255.0, blue: 202.0/255.0, alpha: 1.0)
    static let btnUnSelColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
    static let btnRedBgColor = UIColor(red: 212.0/255.0, green: 74.0/255.0, blue: 57.0/255.0, alpha: 1.0)
    static let bgColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
}
struct FontAndStoryBoardname{
    static let storyboardName = "RegisterFlow"//Signup
    static let storyboardName1 = "RegisterFlow"//Signup
    static let fontBtn =  UIFont.systemFont(ofSize:20.0, weight: .regular)
}

class A{
    class func isValidEmail(testEmail:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testEmail)
        
    }
}

// MARK: FontAndSize--------------------------------------------------
struct fontAndSize {
    static let menuItemFont = "HelveticaNeue-Medium"
    static let menuItemFontSize : CGFloat = 15.0
    
    static let NaviTitleFont = "Quicksand-Medium"
    static let NaviTitleFontSize : CGFloat = 17.0
}

// MARK:  Device  Detection------------------------------------------------


enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType  {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

// MARK:  Device OS Version  Detection

struct Version {
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
}

class commonClass {
   // http://103.51.153.235/bosnia/backend/web/index.php/api/setfavpropertydetails?flag=1&user_id=1&property_id=20
}


