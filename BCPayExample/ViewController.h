//
//  ViewController.h
//  BeeCloudDemo
//
//  Created by RInz on 15/2/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeeCloud.h"

static NSString * const billTitle = @"2015-11-12 Release";

@interface ViewController : UITableViewController<UIAlertViewDelegate, BeeCloudDelegate>

@property (strong, nonatomic) NSMutableArray *payList;

@property  (assign, nonatomic) NSInteger actionType;//0:pay;1:query;

@end

