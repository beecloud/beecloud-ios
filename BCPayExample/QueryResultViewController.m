//
//  QueryResultViewController.m
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/27.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "QueryResultViewController.h"
#import "BeeCloud.h"
#import "BCPayUtil.h"

@interface QueryResultViewController ()

@end

@implementation QueryResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"orderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSString *cellString = @"";
    if ([[self.dataList objectAtIndex:indexPath.row] isKindOfClass:[BCQueryBillResult class]]) {
        cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        BCQueryBillResult *result = (BCQueryBillResult *)[self.dataList objectAtIndex:indexPath.row];
        
        cellString = [NSString stringWithFormat:@"订单标题:%@\n渠道:%@     金额:%ld\n交易时间:%@\n交易订单号:%@\n交易状态:%@\n,是否撤销:%@,optional:%@", result.title, result.subChannel, (long)result.totalFee,[BCPayUtil millisecondToDateString:result.createTime],result.billNo,result.payResult?@"成功":@"失败",result.revertResult?@"是":@"否",result.optional];
        
    } else if ([[self.dataList objectAtIndex:indexPath.row] isKindOfClass:[BCQueryRefundResult class]]) {
       
        BCQueryRefundResult *result = (BCQueryRefundResult *)[self.dataList objectAtIndex:indexPath.row];
        
        cellString = [NSString stringWithFormat:@"订单标题:%@\n渠道:%@\n总金额:%ld 退款金额:%ld\n交易时间:%@\n交易订单号:%@\n退款单号:%@\n退款是否成功状态:%@\n退款是否完成:%@", result.title,result.subChannel, (long)result.totalFee, (long)result.refundFee,[BCPayUtil millisecondToDateString:result.createTime],result.billNo,result.refundNo, result.result?@"成功":@"失败",result.finish?@"完成":@"未完成"];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = cellString;
    
    return cell;
}

@end
