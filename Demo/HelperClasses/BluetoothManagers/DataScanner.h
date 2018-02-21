//
//  DataScanner.h
//  LYNKD
//
//  Created by Ashish Chaudhary on 12/2/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreBluetooth/CoreBluetooth.h>

#define CUSTOMER_Unit_LENGTH                        1
#define QuickLock_TI_KEYFOB_HISTORY_CONTROL_LENGTH  1
#define QuickLock_TI_KEYFOB_HISTORY_PHONE_ID_LENGTH 15
#define QuickLock_TI_KEYFOB_RFID_PHONE_ID_LENGTH    8

#define CUSTOMER_Unit_LENGTH                        1
#define EighthLenght                                8
#define QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_PASSWORD_LENGTH 9

#define QuickLock_TI_KEYFOB_TIME_LENGTH             4
#define QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_ALARM_LENGTH 1

#define kUserNameRange @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'-_., "
@interface DataScanner : NSObject

-(NSData*)verifyPassword:(NSString*)password;


-(NSData*)setLockControlisLockOpen;

-(NSData*)setLockConnection;

-(NSData*)changePassowrd;

-(NSData*)addRFIDIntoDevice;

-(NSData*)setWiFiListforDevice;

-(NSData*)getHistoryDataForDevcice;

-(NSData*)deleteRFIDFromTheDevice:(NSString *)rfifTag;

-(NSData *)BD_setCurrentTime;

-(NSData*)WriteWifiPasswordData:(NSString*)password;

-(NSString *)stringToHex:(NSString *)str;

-(NSData*)getWifiFisrtData;

-(NSData *)BD_setUserName:(NSString*)userName;

-(NSDate*)GetBytesToDate:(Byte)b0 b1:(Byte)b1 b2:(Byte)b2 b3:(Byte)b3;

- (NSData *)changePasssword:(NSString *)newPassword OldPassword :(NSString *) strOldPassword;

-(NSData *)getRFIDAddInBulk:(NSString *)RFIDTagId;
-(NSData *)addSharecodeTimeBase:(NSString *)strShareCode share_Code_Start_Time:(NSDate *)share_Code_Start_Time share_Code_End_Time:(NSDate *)share_Code_End_Time share_Code_Start_Time_minutes:(int)share_Code_Start_Time_minutes share_Code_End_Time_minutes:(int) share_Code_End_Time_minutes share_Code_DATE_Time_FLAG:(int) share_Code_DATE_Time_FLAG;

-(NSData *)addSharecode:(NSString *)strShareCode ShareCodeCount:(NSString *) strShareCodeCount;

-(NSData *)setAlarm:(Byte)type delay:(Byte)delay;

-(NSData *)setPassCode:(NSString *)keyCode;

-(NSData *)setNotification;

-(NSData *)setLedTimeOut:(int)ledTimeOut;

-(NSData *)setLockOpenTime:(int)lockOpenSecond;
@end
