//
//  BCUtil.m
//  BeeCloud SDK
//
//  Created by Junxian Huang on 2/17/14.
//  Copyright (c) 2014 BeeCloud Inc. All rights reserved.
//

#import "BCUtil.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@implementation BCUtil

+ (NSString *)getAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getDeviceId {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString]?nil: [[[UIDevice currentDevice] identifierForVendor] UUIDString], @"";
}

+ (NSString *)getDeviceType {
    return [UIDevice currentDevice].model;
}

+ (NSString *)getNetworkType {
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"]
                          valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
        case 0:
            break;
        case 1:
            return @"2G";
        case 2:
            return @"3G";
        case 3:
            return @"4G";
        case 4:
            return @"LTE";
        case 5:
            return @"WiFi";
        default:
            break;
    }
    return @"Unknown";
}

+ (NSString *)getCarrierName {
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    return [carrier carrierName];
}

+ (float)getBatteryLevel {
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    return [[UIDevice currentDevice] batteryLevel];
}

+ (NSString *)generateRandomUUID {
    return [[NSUUID UUID] UUIDString].lowercaseString;
}

+ (NSDate *)millisecondToDate:(long long)millisecond {
    return [NSDate dateWithTimeIntervalSince1970:((double)millisecond / 1000.0)];
}

+ (long long)dateToMillisecond:(NSDate *)date {
    if (date == nil) return 0;
    return (long long)([date timeIntervalSince1970] * 1000.0);
}

+ (NSDate *)stringToDate:(NSString *)string {
    if (string == nil || string.length == 0) return nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kBCDateFormat];
    return [dateFormatter dateFromString:string];
}

+ (NSString *)dateToString:(NSDate *)date {
    if (date == nil) return nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kBCDateFormat];
    return [dateFormatter stringFromDate:date];
}

//TODO: (hwl) string convert to MD5
+ (NSString *)stringToMD5:(NSString *)string {
    if(string == nil || [string isEqualToString:@""]) return @"";
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash uppercaseString];
}

+ (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)isValidMobile:(NSString *)mobile {
    NSString *phoneRegex = @"^([0|86|17951]?(13[0-9])|(15[^4,\\D])|(17[678])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isLetter:(unichar)ch {
    return (BOOL)((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'));
}

+ (BOOL)isDigit:(unichar)ch {
    return (BOOL)(ch >= '0' && ch <= '9');
}

+ (BOOL)isValidIdentifier:(NSString *)str {
    if (str == nil || str.length == 0) return NO;
    // First letter not a letter.
    if (![BCUtil isLetter:[str characterAtIndex:0]]) return NO;
    for (NSUInteger i = 1; i < str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        // Invalid character.
        if (![BCUtil isLetter:ch] && ![BCUtil isDigit:ch] && ch != '_') return NO;
    }
    // Identifier ending with "__" is reserved.
    if ([str hasSuffix:@"__"]) return NO;
    return YES;
}

+ (BOOL)isValidUUID:(NSString *)uuid {
    if (uuid == nil || uuid.length != 36) return NO;
    for (NSUInteger i = 0; i < uuid.length; i++) {
        unichar ch = [uuid characterAtIndex:i];
        if (i == 8 || i == 13 || i == 18 || i == 23) {
            if (ch != '-')
                return NO;
        } else {
            if (!([BCUtil isDigit:ch] || (ch >= 'a' && ch <= 'f') || (ch >= 'A' && ch <= 'F')))
                return NO;
        }
    }
    return YES;
}

+ (BOOL)isValidTraceNo:(NSString *)str {
    if (![BCUtil isValidString:str]) return NO;
    for (NSUInteger i = 0; i < str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        // Invalid character.
        if (![BCUtil isLetter:ch] && ![BCUtil isDigit:ch]) return NO;
    }
    return YES;
}

+ (BOOL)isValidString:(NSString *)str {
    if (str == nil || (NSNull *)str == [NSNull null] || str.length == 0 ) return NO;
    return YES;
}

+ (BOOL)isPureInt:(NSString *)str {
    NSScanner *scan = [NSScanner scannerWithString:str];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


+ (BOOL)isPureFloat:(NSString *)str {
    NSScanner *scan = [NSScanner scannerWithString:str];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (NSUInteger)getBytes:(NSString *)str {
    if (![BCUtil isValidString:str]) {
        return 0;
    } else {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData* da = [str dataUsingEncoding:enc];
        return [da length];
    }
}

+ (NSNumber *)getTimeStampFromString:(NSString *)string {
    NSDate *dat = [BCUtil stringToDate:string];
    if (dat) return [BCUtil getTimeStampFromDate:dat];
    return nil;
}

+ (NSNumber *)getTimeStampFromDate:(NSDate *)date {
    NSTimeInterval a = [date timeIntervalSince1970]*1000;
    return [NSNumber numberWithLongLong:(long long)a];
}

@end
