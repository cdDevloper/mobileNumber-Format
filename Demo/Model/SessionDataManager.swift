//
//  SessionDataManager.swift
//  LYNKD
//
//  Created by Apple on 06/12/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

import UIKit
import CoreBluetooth

private let sharedSessionDataManager = SessionDataManager()

class SessionDataManager: NSObject {
    
    var share_Code_DATE_Time_FLAG:Int = 0
    var share_Code_End_Time_minutes:Int = 0
    //var share_Code_Start_Time:String = ""
    var share_Code_End_Time:Date = Date()
    var share_Code_Start_Time_minutes:Int  = 0
    var shareCode:String = ""
    var isSetNewPassword:Bool = false
    var selectedRFIDTagForDeleteting:[String] = []
    var isSerchingNewDevice: Bool? //true= Connect New Device, false= Connect to Already Connected Device
    var isNewMobileDevice: Bool? //true= Connect New Device, false= Connect to Already Connected Device
    var isSerchingDevicesForPopup: Bool?
    var selectedUUIDString: String?
    var selectedMacIdString: String = ""
    var selectedRFIDToAdd:[String] = []
    var selectedDeviceIndex: Int?
    var firmwareDownloading = false
    var share_Code_Time:String = ""
    var share_Code_Count:String = ""
    var share_Code_Time1:String = ""
    var share_Code_Time2: NSString = ""
    var share_code_time_flag: Int = 0
    var str_share_Code_Stert_time:String = ""
    var str_share_Code_End_time:String = ""
    var share_Code_Start_Time:Date = Date()
    var isSignupFlowFromAccessCode = false
    var accessCodeID = ""
    var planDetailID = ""
    var planAssigned = ""
    
    var keyCode = "0"
    var ledTimeOut: Int = 0
    var autoLockTime: Int = 0
    
    
    
    /*
     @property (nonatomic, retain) NSString *share_Code;
     
     @property (nonatomic, retain) NSDate *share_Code_Start_Time;
     @property (nonatomic, assign) int share_Code_End_Time_minutes;
     @property (nonatomic, retain) NSDate *share_Code_End_Time;
     @property (nonatomic, assign) int share_Code_DATE_Time_FLAG;
     @property (nonatomic, retain) NSString *share_Code_Time1;
     @property (nonatomic, retain) NSString *share_Code_Time2;
     @property (nonatomic, assign) int share_code_time_flag;
     @property (nonatomic, retain) NSString *str_share_Code_Stert_time;
     @property (nonatomic, retain) NSString *str_share_Code_End_time;*/
    
    
    var connectedLynkdPeripheral: CBPeripheral!
    var CbControlManager : CBCentralManager!
    var encrptionData : Data?
    class func shared() -> SessionDataManager {
    
        return sharedSessionDataManager
    }
    
    
    
}
