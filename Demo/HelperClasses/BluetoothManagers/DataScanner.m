//
//  DataScanner.m
//  LYNKD
//
//  Created by Ashish Chaudhary on 12/2/17.
//  Copyright © 2017 Magneto IT solutions Pvt Ltd. All rights reserved.
//

#import "DataScanner.h"
#define QuickLock_TI_KEYFOB_SHARECODE_TIME_LENGTH  17
#define QuickLock_TI_KEYFOB_SHARECODE_COUNT_LENGTH                                   5
@implementation DataScanner

// Share code Date Time Base
-(NSData *)addSharecodeTimeBase:(NSString *)strShareCode share_Code_Start_Time:(NSDate *)share_Code_Start_Time share_Code_End_Time:(NSDate *)share_Code_End_Time share_Code_Start_Time_minutes:(int)share_Code_Start_Time_minutes share_Code_End_Time_minutes:(int) share_Code_End_Time_minutes share_Code_DATE_Time_FLAG:(int) share_Code_DATE_Time_FLAG
{
    NSString *SHARECODE = strShareCode;// lockDevice.share_Code_Time;
    
    Byte b1, b2, b3, b4;//, b5, b6, b7, b8, b9, b10, b11, b12;
    
    NSScanner *scan = [NSScanner scannerWithString:[SHARECODE substringWithRange:NSMakeRange(0, 2)]];
    unsigned int n = 0;
    [scan scanHexInt:&n];
    b1 = n;
    
    scan = [NSScanner scannerWithString:[SHARECODE substringWithRange:NSMakeRange(2, 2)]];
    [scan scanHexInt:&n];
    b2 = n;
    
    scan = [NSScanner scannerWithString:[SHARECODE substringWithRange:NSMakeRange(4, 2)]];
    [scan scanHexInt:&n];
    b3 = n;
    
    scan = [NSScanner scannerWithString:[SHARECODE substringWithRange:NSMakeRange(6, 2)]];
    [scan scanHexInt:&n];
    b4 = n;
    return [self BD_share_Code_Time:b1 CODE2:b2 CODE3:b3 CODE4:b4 share_Code_Start_Time:share_Code_Start_Time share_Code_End_Time:share_Code_End_Time share_Code_Start_Time_minutes:share_Code_Start_Time_minutes share_Code_End_Time_minutes:share_Code_End_Time_minutes share_Code_DATE_Time_FLAG:share_Code_DATE_Time_FLAG];
    
}

// Add share code User Access wise
-(NSData *)addSharecode:(NSString *)strShareCode ShareCodeCount:(NSString *) strShareCodeCount
{
    NSString *SHARECODE = strShareCode;
    NSString *sCount = strShareCodeCount;
    
    Byte b1, b2, b3, b4, bc;
    
    NSScanner *scan = [NSScanner scannerWithString:[SHARECODE substringWithRange:NSMakeRange(0, 2)]];
    unsigned int n = 0;
    [scan scanHexInt:&n];
    b1 = n;
    
    scan = [NSScanner scannerWithString:[SHARECODE substringWithRange:NSMakeRange(2, 2)]];
    [scan scanHexInt:&n];
    b2 = n;
    
    scan = [NSScanner scannerWithString:[SHARECODE substringWithRange:NSMakeRange(4, 2)]];
    [scan scanHexInt:&n];
    b3 = n;
    
    scan = [NSScanner scannerWithString:[SHARECODE substringWithRange:NSMakeRange(6, 2)]];
    [scan scanHexInt:&n];
    b4 = n;
    
    scan = [NSScanner scannerWithString:[sCount substringWithRange:NSMakeRange(0, 2)]];
    [scan scanHexInt:&n];
    bc = n;
    
   return  [self BD_share_Code_Count:b1 CODE2:b2 CODE3:b3 CODE4:b4 CODECOUNT:bc];
}

// Set Share code User count wise
-(NSData *)BD_share_Code_Count:(Byte)CODE1 CODE2:(Byte)CODE2 CODE3:(Byte)CODE3 CODE4:(Byte)CODE4 CODECOUNT:(Byte)CODECOUNT
{
    char bytes[QuickLock_TI_KEYFOB_SHARECODE_COUNT_LENGTH];
    
    //  4 Byte:Received share code
    bytes[0] = CODE1;
    bytes[1] = CODE2;
    bytes[2] = CODE3;
    bytes[3] = CODE4;
    
    // User access count
    bytes[4] = CODECOUNT;
    
    return [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_SHARECODE_COUNT_LENGTH];
    // [[BLEManager sharedInstance] writeValueForCharacteristic:DeviceID
//                                                 serviceUUID:QuickLock_TI_KEYFOB_SHARECODE_MAIN
//                                          characteristicUUID:QuickLock_TI_KEYFOB_SHARECODE_COUNT
//                                                        data:d];
}


// set Share code Time wise
-(NSData *)BD_share_Code_Time:(Byte)CODE1 CODE2:(Byte)CODE2 CODE3:(Byte)CODE3 CODE4:(Byte)CODE4 share_Code_Start_Time:(NSDate *)share_Code_Start_Time share_Code_End_Time:(NSDate *)share_Code_End_Time share_Code_Start_Time_minutes:(int)share_Code_Start_Time_minutes share_Code_End_Time_minutes:(int) share_Code_End_Time_minutes share_Code_DATE_Time_FLAG:(int) share_Code_DATE_Time_FLAG
{
    //DhavalTannarana
    char bytes[QuickLock_TI_KEYFOB_SHARECODE_TIME_LENGTH];
    
    // Share code
    bytes[0] = CODE1;
    bytes[1] = CODE2;
    bytes[2] = CODE3;
    bytes[3] = CODE4;
    
    NSDate *date2000;
    uint time;
    NSDateFormatter *fm;
    fm = [[NSDateFormatter alloc]init];
    [fm setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    date2000 = [fm dateFromString:@"2000-01-01 00:00:00"];
    
    // start time
    time = (int)[share_Code_Start_Time timeIntervalSinceDate:date2000];
    bytes[4] = time;
    bytes[5] = time >> 8;
    bytes[6] = time >> 16;
    bytes[7] = time >> 24;
    
    // end time
    time = (int)[share_Code_End_Time timeIntervalSinceDate:date2000];
    bytes[8] = time;
    bytes[9] = time >> 8;
    bytes[10] = time >> 16;
    bytes[11] = time >> 24;
    
    time = share_Code_Start_Time_minutes;
    bytes[12] = time;
    bytes[13] = time >> 8;
    
    time = share_Code_End_Time_minutes;
    bytes[14] = time;
    bytes[15] = time >> 8;
    
    bytes[16] = share_Code_DATE_Time_FLAG;
    
    return [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_SHARECODE_TIME_LENGTH];
}

-(NSData*)WriteWifiPasswordData:(NSString*)password {
    
    Byte b1, b2;
    
    NSScanner *scan = [NSScanner scannerWithString:[password substringWithRange:NSMakeRange(0, 2)]];
    //NSMutableArray *byte = [[NSMutableArray alloc]init];
    unsigned long int length = password.length/2;
    char bytes[length];
    unsigned int n = 0;
    [scan scanHexInt:&n];
    b1 = n;
    int j = 0;  // WriteWifiPasswordData
    for (int i = 0; i<password.length; i = i+2) {
        //NSLog(@"%@",password.length)
        scan = [NSScanner scannerWithString:[password substringWithRange:NSMakeRange(i, 2)]];
        [scan scanHexInt:&n];
        b2 = n;
        bytes[j] = b2;
        j++;
    }
    
    // NSString *hexString = [self stringToHex:password];
    //NSData *d = [[NSData alloc] initwithst
    NSData *d = [[NSData alloc] initWithBytes:bytes length:9];
    return d;
}

- (NSString *) stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        // [hexString [NSString stringWithFormat:@"%02x", chars[i]]]; /*previous input*/
        [hexString appendFormat:@"%02x", chars[i]]; /*EDITED PER COMMENT BELOW*/
    }
    free(chars);
    
    return hexString ;
}

-(NSData*)verifyPassword:(NSString*)password {
    
    Byte b1, b2, b3, b4;
    
    NSScanner *scan = [NSScanner scannerWithString:[password substringWithRange:NSMakeRange(0, 2)]];
    unsigned int n = 0;
    [scan scanHexInt:&n];
    b1 = n;
    
    scan = [NSScanner scannerWithString:[password substringWithRange:NSMakeRange(2, 2)]];
    [scan scanHexInt:&n];
    b2 = n;
    
    scan = [NSScanner scannerWithString:[password substringWithRange:NSMakeRange(4, 2)]];
    [scan scanHexInt:&n];
    b3 = n;
    
    scan = [NSScanner scannerWithString:[password substringWithRange:NSMakeRange(6, 2)]];
    [scan scanHexInt:&n];
    b4 = n;
    
    
    char bytes[9];
    
    //  1 Byte:Type: Verify Password
    bytes[0] = 0x00;
    
    //  4 Byte:旧密码 验证密码时，两组密码一致
    bytes[1] = b1; // '\x12'  '4' 'V'  'x'
    bytes[2] = b2;
    bytes[3] = b3;
    bytes[4] = b4;
    
    //  4 Byte:新密码
    bytes[5] = b1;
    bytes[6] = b2;
    bytes[7] = b3;
    bytes[8] = b4;
    
    NSData *d = [[NSData alloc] initWithBytes:bytes length:9];
    return d;
}

-(NSData*)setLockControlisLockOpen {
    
    char bytes[CUSTOMER_Unit_LENGTH];
    bool isLockOpen = YES;
    
    if (isLockOpen)
    {
        bytes[0] = 0x01;
    }
    else
    {
        bytes[0] = 0x00;
    }
    
    NSData *data = [[NSData alloc] initWithBytes:bytes length:1];
    return data;
}

-(NSData*)addRFIDIntoDevice{
    
    char bytes[CUSTOMER_Unit_LENGTH];
    
    bytes[0] = 0x01;
    
    NSData *data = [[NSData alloc] initWithBytes:bytes length:1];
    return data;
}

-(NSData*)getWifiFisrtData{
    
    char bytes[1];
    
    bytes[0] = 0x0D;
    
    NSData *data = [[NSData alloc] initWithBytes:bytes length:1];
    return data;
}

-(NSData*)deleteRFIDFromTheDevice:(NSString *)rfifTag{
    NSString *RFID = rfifTag;
    Byte b1, b2, b3, b4, b5, b6, b7;
    
    NSScanner *scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(0, 2)]];
    unsigned int n = 0;
    [scan scanHexInt:&n];
    b1 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(2, 2)]];
    [scan scanHexInt:&n];
    b2 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(4, 2)]];
    [scan scanHexInt:&n];
    b3 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(6, 2)]];
    [scan scanHexInt:&n];
    b4 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(8, 2)]];
    [scan scanHexInt:&n];
    b5 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(10, 2)]];
    [scan scanHexInt:&n];
    b6 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(12, 2)]];
    [scan scanHexInt:&n];
    b7 = n;
    
    char bytes[EighthLenght];
    
    bytes[7] = 0xE0;
    
    //  4 Byte:Received RFID/TAG ID to delete
    bytes[0] = b1;
    bytes[1] = b2;
    bytes[2] = b3;
    bytes[3] = b4;
    bytes[4] = b5;
    bytes[5] = b6;
    bytes[6] = b7;
    
    NSLog(@"%@",[NSString stringWithFormat:@"RFID : %02x %02x %02x %02x %02x %02x %02x %02x",bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7]]);
    //    NSLog(@"Bytes for TAG : %@",bytes);
    NSData *d = [[NSData alloc] initWithBytes:bytes length:EighthLenght];
    return d;
}
-(NSData*)setLockConnection {
    
    char bytes[CUSTOMER_Unit_LENGTH];
    bool isLockOpen = YES;
    
    if (isLockOpen)
    {
        bytes[0] = 0x01;
    }
    else
    {
        bytes[0] = 0x00;
    }
    
    NSData *data = [[NSData alloc] initWithBytes:bytes length:1];
    return data;
}

- (NSData *)changePasssword:(NSString *)newPassword OldPassword :(NSString *) strOldPassword
{
    NSString *oldPassword = strOldPassword;
    
    Byte old1, old2, old3, old4, new1, new2, new3, new4;
    
    NSScanner *scan = [NSScanner scannerWithString:[oldPassword substringWithRange:NSMakeRange(0, 2)]];
    unsigned int n = 0;
    [scan scanHexInt:&n];
    old1 = n;
    
    scan = [NSScanner scannerWithString:[oldPassword substringWithRange:NSMakeRange(2, 2)]];
    [scan scanHexInt:&n];
    old2 = n;
    
    scan = [NSScanner scannerWithString:[oldPassword substringWithRange:NSMakeRange(4, 2)]];
    [scan scanHexInt:&n];
    old3 = n;
    
    scan = [NSScanner scannerWithString:[oldPassword substringWithRange:NSMakeRange(6, 2)]];
    [scan scanHexInt:&n];
    old4 = n;
    
    scan = [NSScanner scannerWithString:[newPassword substringWithRange:NSMakeRange(0, 2)]];
    [scan scanHexInt:&n];
    new1 = n;
    
    scan = [NSScanner scannerWithString:[newPassword substringWithRange:NSMakeRange(2, 2)]];
    [scan scanHexInt:&n];
    new2 = n;
    
    scan = [NSScanner scannerWithString:[newPassword substringWithRange:NSMakeRange(4, 2)]];
    [scan scanHexInt:&n];
    new3 = n;
    
    scan = [NSScanner scannerWithString:[newPassword substringWithRange:NSMakeRange(6, 2)]];
    [scan scanHexInt:&n];
    new4 = n;
    
    // The new password is stored in a variable, replace the original password with variable success after changing passwords, modify the new password failed emptied variables stored
    NSString *tempNewPassword = newPassword;
    
    return [self BD_setModifyPassword:old1
                         oldPassword2:old2
                         oldPassword3:old3
                         oldPassword4:old4
                         newPassword1:new1
                         newPassword2:new2
                         newPassword3:new3
                         newPassword4:new4];
}

-(NSData *)BD_setModifyPassword:(Byte)old1 oldPassword2:(Byte)old2 oldPassword3:(Byte)old3 oldPassword4:(Byte)old4 newPassword1:(Byte)new1 newPassword2:(Byte)new2 newPassword3:(Byte)new3 newPassword4:(Byte)new4
{
    char bytes[QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_PASSWORD_LENGTH];
    
    //  1 Byte:Type: Change Password
    bytes[0] = 0x01;
    
    //  4 Byte: Old Password
    bytes[1] = old1;
    bytes[2] = old2;
    bytes[3] = old3;
    bytes[4] = old4;
    
    //  4 Byte:new password
    bytes[5] = new1;
    bytes[6] = new2;
    bytes[7] = new3;
    bytes[8] = new4;
    
    NSData *d = [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_PASSWORD_LENGTH];
    return d;
}
-(NSData*)changePassowrd {
    
    NSString *oldPassword = @"12345678";
    
    NSString *newPassword = @"12345677";
    
    Byte old1, old2, old3, old4, new1, new2, new3, new4;
    
    NSScanner *scan = [NSScanner scannerWithString:[oldPassword substringWithRange:NSMakeRange(0, 2)]];
    unsigned int n = 0;
    [scan scanHexInt:&n];
    old1 = n;
    
    scan = [NSScanner scannerWithString:[oldPassword substringWithRange:NSMakeRange(2, 2)]];
    [scan scanHexInt:&n];
    old2 = n;
    
    scan = [NSScanner scannerWithString:[oldPassword substringWithRange:NSMakeRange(4, 2)]];
    [scan scanHexInt:&n];
    old3 = n;
    
    scan = [NSScanner scannerWithString:[oldPassword substringWithRange:NSMakeRange(6, 2)]];
    [scan scanHexInt:&n];
    old4 = n;
    
    scan = [NSScanner scannerWithString:[newPassword substringWithRange:NSMakeRange(0, 2)]];
    [scan scanHexInt:&n];
    new1 = n;
    
    scan = [NSScanner scannerWithString:[newPassword substringWithRange:NSMakeRange(2, 2)]];
    [scan scanHexInt:&n];
    new2 = n;
    
    scan = [NSScanner scannerWithString:[newPassword substringWithRange:NSMakeRange(4, 2)]];
    [scan scanHexInt:&n];
    new3 = n;
    
    scan = [NSScanner scannerWithString:[newPassword substringWithRange:NSMakeRange(6, 2)]];
    [scan scanHexInt:&n];
    new4 = n;
    
    // The new password is stored in a variable, replace the original password with variable success after changing passwords, modify the new password failed emptied variables stored
    char bytes[9];
    
    //  1 Byte:Type: Change Password
    bytes[0] = 0x01;
    
    //  4 Byte: Old Password
    bytes[1] = old1;
    bytes[2] = old2;
    bytes[3] = old3;
    bytes[4] = old4;
    
    //  4 Byte:new password
    bytes[5] = new1;
    bytes[6] = new2;
    bytes[7] = new3;
    bytes[8] = new4;
    
    NSData *data = [[NSData alloc] initWithBytes:bytes length:9];
    return data;
}

-(NSData*)setWiFiListforDevice {
    
    char bytes[2];
    bytes[0] = 0x1;
    
    NSData *data = [[NSData alloc] initWithBytes:bytes length:CUSTOMER_Unit_LENGTH];
    return data;
}

-(NSData*)getHistoryDataForDevcice{
    char bytes[QuickLock_TI_KEYFOB_HISTORY_CONTROL_LENGTH];
    
    bytes[0] = 0x01;
    
    NSData *d = [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_HISTORY_CONTROL_LENGTH];
    
    return d;
}


-(NSData *)BD_setCurrentTime
{
    NSDate *date2000;
    uint time;
    NSDateFormatter *fm;
    char bytes[QuickLock_TI_KEYFOB_TIME_LENGTH];
    
    fm = [[NSDateFormatter alloc]init];
    [fm setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    date2000 = [fm dateFromString:@"2000-01-01 00:00:00"];
    time = (int)[[NSDate date] timeIntervalSinceDate:date2000];
    bytes[0] = time;
    bytes[1] = time >> 8;
    bytes[2] = time >> 16;
    bytes[3] = time >> 24;
    
    NSData *d = [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_TIME_LENGTH];
    
    return d;
}

-(NSData *)BD_setUserName:(NSString*)userName
{
    char bytes[QuickLock_TI_KEYFOB_HISTORY_PHONE_ID_LENGTH];
    int i;
    
    if (userName.length > 14)
    {
        userName = [userName substringToIndex:14];
    }
    
    //字节0的位置，放入手机名的有效长度
    if (userName.length < QuickLock_TI_KEYFOB_HISTORY_PHONE_ID_LENGTH)
    {
        bytes[0] = userName.length;
    }
    else
    {
        bytes[0] = QuickLock_TI_KEYFOB_HISTORY_PHONE_ID_LENGTH - 1;
    }
    
    //1-14字节，写入手机名，无效补0
    for (i = 0; i < QuickLock_TI_KEYFOB_HISTORY_PHONE_ID_LENGTH - 1; i++)
    {
        if (i < userName.length)
        {
            bytes[i + 1] = [userName characterAtIndex:i];
        }
        else
        {
            bytes[i + 1] = (char)0;
        }
    }
    return [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_HISTORY_PHONE_ID_LENGTH];
}



//  4 Byte processing time
-(NSDate*)GetBytesToDate:(Byte)b0 b1:(Byte)b1 b2:(Byte)b2 b3:(Byte)b3
{
    int n;
    NSDate *da,*date2000;
    NSDateFormatter *fm;
    
    fm = [[NSDateFormatter alloc]init];
    [fm setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    date2000 = [fm dateFromString:@"2000-01-01 00:00:00"];
    
    n = b0 | (b1 << 8) | (b2 << 16) | (b3 << 24);
    da = [[NSDate alloc]initWithTimeInterval:n sinceDate:date2000];
    
    return da;
    
}


-(NSData *)getRFIDAddInBulk:(NSString *)RFIDTagId
{
    NSString *RFID = RFIDTagId;
    Byte b1, b2, b3, b4, b5, b6, b7;
    
    NSScanner *scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(0, 2)]];
    unsigned int n = 0;
    [scan scanHexInt:&n];
    b1 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(2, 2)]];
    [scan scanHexInt:&n];
    b2 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(4, 2)]];
    [scan scanHexInt:&n];
    b3 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(6, 2)]];
    [scan scanHexInt:&n];
    b4 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(8, 2)]];
    [scan scanHexInt:&n];
    b5 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(10, 2)]];
    [scan scanHexInt:&n];
    b6 = n;
    
    scan = [NSScanner scannerWithString:[RFID substringWithRange:NSMakeRange(12, 2)]];
    [scan scanHexInt:&n];
    b7 = n;
    
    return [self BD_getRFIDAddInBulk:b1 RFID2:b2 RFID3:b3 RFID4:b4 RFID5:b5 RFID6:b6 RFID7:b7];
}
-(NSData *)BD_getRFIDAddInBulk:(Byte)RFID1 RFID2:(Byte)RFID2 RFID3:(Byte)RFID3 RFID4:(Byte)RFID4 RFID5:(Byte)RFID5 RFID6:(Byte)RFID6 RFID7:(Byte)RFID7
{
    char bytes[QuickLock_TI_KEYFOB_RFID_PHONE_ID_LENGTH];
    
    bytes[7] = 0xE0;
    // A8BD482A500104
    //  4 Byte:Received RFID/TAG ID to delete
    bytes[0] = RFID1;
    bytes[1] = RFID2;
    bytes[2] = RFID3;
    bytes[3] = RFID4;
    bytes[4] = RFID5;
    bytes[5] = RFID6;
    bytes[6] = RFID7;
    
    NSLog(@"%@",[NSString stringWithFormat:@"RFID : %02x %02x %02x %02x %02x %02x %02x %02x",bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7]]);
    //    NSLog(@"Bytes for TAG : %@",bytes);
    return [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_RFID_PHONE_ID_LENGTH];
}

-(NSData *)setAlarm:(Byte)type delay:(Byte)delay
{
   char bytes[QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_ALARM_LENGTH];

   bytes[0] = type;
   bytes[1] = delay;

   return [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_ALARM_LENGTH];
}
-(NSData *)setNotification
{
    char bytes[QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_ALARM_LENGTH];
    
    bytes[0] = 0x0001;
    
    return [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_ALARM_LENGTH];
}

-(NSData *)setPassCode:(NSString *)keyCode
{
    char bytes[11];
    
    if ([keyCode isEqualToString:@"0"])
    {
        // Disable
        bytes[0] = 0x00;
        bytes[1] = 0x00;
        
        NSData *d = [[NSData alloc] initWithBytes:bytes length:11];
        
        
        return d;
    }
    NSMutableArray *arrStr = [[NSMutableArray alloc]init];
    arrStr = [keyCode componentsSeparatedByString:@" "];
    [arrStr removeObjectAtIndex:arrStr.count-1];
    NSString *s = [NSString stringWithFormat:@"%d",arrStr.count];
    [arrStr insertObject:s atIndex:0];
    
    
    for (int i = 0; i < arrStr.count; i++)
    {
        NSString *str = [arrStr objectAtIndex:i];
        int byte = [str intValue];
        bytes[i] = byte;
    }
    
    NSData *d = [[NSData alloc] initWithBytes:bytes length:11];
    
    return d;
}

-(NSData*)setLedTimeOut:(int)LEDSecond
{
    char bytes[QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_ALARM_LENGTH];
    
    bytes[0] = LEDSecond;
    
    NSData *d = [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_ALARM_LENGTH];
    return d;
}

-(NSData *)setLockOpenTime:(int)lockOpenSecond
{
    char bytes[QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_ALARM_LENGTH];
    
    bytes[0] = lockOpenSecond;
    
    NSData *d = [[NSData alloc] initWithBytes:bytes length:QuickLock_TI_KEYFOB_CUSTOMER_UNLOCK_ALARM_LENGTH];
    return d;
}
@end
