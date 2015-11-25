//
//  ViewController.m
//  BeeCloudDemo
//
//  Created by RInz on 15/2/5.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

#import "ViewController.h"
#import "QueryResultViewController.h"
#import "AFNetworking.h"
#import "PayPalMobile.h"
#import "BCOffinePay.h"
#import "GenQrCode.h"
#import "QRCodeViewController.h"
#import "ScanViewController.h"
#import "PayChannelCell.h"
#import "BDWalletSDKMainManager.h"

@interface ViewController ()<BeeCloudDelegate, PayPalPaymentDelegate, SCanViewDelegate, QRCodeDelegate,BDWalletSDKMainManagerDelegate> {
    PayPalConfiguration * _payPalConfig;
    PayPalPayment *_completedPayment;
    PayChannel currentChannel;
    NSArray *channelList;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.actionType == 0) {
        self.title = @"支付";
    } else if (self.actionType == 1) {
        self.title = @"查询支付订单";
    } else if (self.actionType == 2) {
        self.title = @"查询退款订单";
    }
    channelList = @[@{@"channel":@"微信",@"img":@"wxPay",
                      @"subChannel":@[@{@"sub":@(PayChannelWxApp),@"title":@"微信APP支付"},
                                      @{@"sub":@(PayChannelWxNative),@"title":@"微信扫码支付"},
                                      @{@"sub":@(PayChannelWxScan),@"title":@"微信刷卡支付"}]},
                    @{@"channel":@"支付宝",@"img":@"aliPay",
                      @"subChannel":@[@{@"sub":@(PayChannelAliApp),@"title":@"支付宝APP支付"},
                                      @{@"sub":@(PayChannelAliOfflineQrCode),@"title":@"支付宝扫码支付"},
                                      @{@"sub":@(PayChannelAliScan),@"title":@"支付宝条码支付"}]},
                    @{@"channel":@"银联在线",@"img":@"uPay",
                      @"subChannel":@[@{@"sub":@(PayChannelUnApp),@"title":@"银联在线"}]},
                    @{@"channel":@"PayPal",@"img":@"paypal",
                      @"subChannel":@[@{@"sub":@(PayChannelPayPal),@"title":@"PayPal"}]},
                    @{@"channel":@"百度钱包",@"img":@"baidu",
                      @"subChannel":@[@{@"sub":@(PayChannelBaiduApp),@"title":@"百度钱包"}]}];
    self.payList = [NSMutableArray arrayWithCapacity:10];
#pragma mark - 设置delegate
    [BeeCloud setBeeCloudDelegate:self];
}

#pragma mark - 微信、支付宝、银联、百度钱包

- (void)doPay:(PayChannel)channel {
    NSString *billno = [self genBillNo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    /**
        按住键盘上的option键，点击参数名称，可以查看参数说明
    **/
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = channel; //支付渠道
    payReq.title = billTitle;//订单标题
    payReq.totalFee = @"1";//订单价格
    payReq.billNo = billno;//商户自定义订单号
    payReq.scheme = @"payDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.billTimeOut = 300;//订单超时时间
    payReq.viewController = self; //用于银联支付的页面跳转，银联必有参数
    payReq.optional = dict;//商户业务扩展参数，会在webhook回调时返回
    [BeeCloud sendBCReq:payReq];
}

- (void)doOfflinePay:(PayChannel)channel authCode:(NSString *)authcode {
    NSString *billno = [self genBillNo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    
    /**
     按住键盘上的option键，点击参数名称，可以查看参数说明
     **/
    BCOfflinePayReq *payReq = [[BCOfflinePayReq alloc] init];
    payReq.channel = channel; //支付渠道，支持WX_NATIVE、WX_SCAN、ALI_OFFLINE_QRCODE、ALI_SCAN
    payReq.title = @"Offline Pay";//订单标题
    payReq.totalfee = @"1"; //订单价格
    payReq.billno = billno; //商户自定义订单号
    payReq.authcode = authcode; //支付授权码(ALI_SCAN,WX_SCAN时必需)，通过扫码用户的支付宝钱包(付款)、微信钱包(刷卡)获取
    payReq.terminalid = @"BeeCloud617"; //自定义扫码设备号
    payReq.storeid = @"BeeCloud618";//自定义店铺编号
    payReq.optional = dict;//用于商户业务扩展参数，会在webhook回调时返回
    [BeeCloud sendBCReq:payReq];
}

#pragma mark - PayPal Pay
- (void)doPayPal {
    BCPayPalReq *payReq = [[BCPayPalReq alloc] init];
    
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
                                    withQuantity:2
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    
    PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00066"];
    
    PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00291"];
    
    payReq.items = @[item1, item2, item3];
    payReq.shipping = @"5.00";
    payReq.tax = @"2.50";
    payReq.shortDesc = billTitle;
    payReq.viewController = self;
    payReq.payConfig = _payPalConfig;
    
    [BeeCloud sendBCReq:payReq];
    
}

#pragma mark - PayPal Verify
- (void)doPayPalVerify {
    BCPayPalVerifyReq *req = [[BCPayPalVerifyReq alloc] init];
    req.payment = _completedPayment;
    req.optional = @{@"key1":@"value1"};
    [BeeCloud sendBCReq:req];
}

#pragma mark - PayPalPaymentDelegate

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success! %@", completedPayment.description);
    
    _completedPayment = completedPayment;
    
    [self doPayPalVerify];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BCPay回调

- (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
#pragma mark - 支付响应事件类型，包含微信、支付宝、银联、百度
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                BCPayReq *payReq = (BCPayReq *)resp.request;
                //百度钱包需要用户用获取到的orderInfo，调用百度钱包SDK发起支付
                if (payReq.channel == PayChannelBaiduApp) {
                    [[BDWalletSDKMainManager getInstance] doPayWithOrderInfo:tempResp.paySource[@"orderInfo"] params:nil delegate:self];
                } else {
                    [self showAlertView:resp.resultMsg];
                }
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        
        case BCObjsTypeQueryResp:
        {
#pragma mark - 查询订单或者退款记录响应事件类型
            BCQueryResp *tempResp = (BCQueryResp *)resp;
            if (resp.resultCode == 0) {
                if (tempResp.count == 0) {
                    [self showAlertView:@"未找到相关订单信息"];
                } else {
                    self.payList = tempResp.results;
                    [self performSegueWithIdentifier:@"queryResult" sender:self];
                }
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        case BCObjsTypeOfflinePayResp:
        {
#pragma mark - 线下支付响应事件类型
            BCOfflinePayResp *tempResp = (BCOfflinePayResp *)resp;
            if (resp.resultCode == 0) {
                BCOfflinePayReq *payReq = (BCOfflinePayReq *)tempResp.request;
                switch (payReq.channel) {
                    case PayChannelAliOfflineQrCode:
                    case PayChannelWxNative:
                        if (tempResp.codeurl.isValid) {
                            QRCodeViewController *qrCodeView = [[QRCodeViewController alloc] init];
                            qrCodeView.resp = tempResp;
                            qrCodeView.delegate = self;
                            self.modalPresentationStyle = UIModalPresentationCurrentContext;
                            qrCodeView.view.backgroundColor = [UIColor whiteColor];
                            [self presentViewController:qrCodeView animated:YES completion:nil];
                        }
                        break;
                    case PayChannelAliScan:
                    case PayChannelWxScan:
                    {
                        BCOfflineStatusReq *req = [[BCOfflineStatusReq alloc] init];
                        req.channel = payReq.channel;
                        req.billno = payReq.billno;
                        [BeeCloud sendBCReq:req];
                    }
                        break;
                    default:
                        break;
                }
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        case BCObjsTypeOfflineBillStatusResp:
        {
#pragma mark- 线下支付订单状态查询响应事件类型
            static int queryTimes = 1;
            BCOfflineStatusResp *tempResp = (BCOfflineStatusResp *)resp;
            if (tempResp.resultCode == 0) {
                if (!tempResp.payResult && queryTimes < 3) {
                    queryTimes++;
                    [BeeCloud sendBCReq:tempResp.request];
                } else {
                    [self showAlertView:tempResp.payResult?@"支付成功":@"支付失败"];
                    //                BCOfflineRevertReq *req = [[BCOfflineRevertReq alloc] init];
                    //                req.channel = tempResp.request.channel;
                    //                req.billno = tempResp.request.billno;
                    //                [BeeCloud sendBCReq:req];
                    queryTimes = 1;
                }
                
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        case BCObjsTypeOfflineRevertResp:
        {
#pragma mark - 线下撤销订单响应事件类型，包含WX_SCAN,ALI_SCAN,ALI_OFFLINE_QRCODE
            BCOfflineRevertResp *tempResp = (BCOfflineRevertResp *)resp;
            if (resp.resultCode == 0) {
                [self showAlertView:tempResp.revertStatus?@"撤销成功":@"撤销失败"];
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",tempResp.resultMsg, tempResp.errDetail]];
            }
        }
            break;
        default:
        {
            if (resp.resultCode == 0) {
                [self showAlertView:resp.resultMsg];
            } else {
                [self showAlertView:[NSString stringWithFormat:@"%@ : %@",resp.resultMsg, resp.errDetail]];
            }
        }
            break;
    }
}

- (void)showAlertView:(NSString *)msg {
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 订单查询

- (void)doQuery:(PayChannel)channel {
    
    if (self.actionType == 1) {
        BCQueryReq *req = [[BCQueryReq alloc] init];
        req.channel = channel;
        //   req.billno = @"20150901104138656";//订单号
       //  req.startTime = @"2015-10-22 00:00";//订单时间
        // req.endTime = @"2015-10-23 00:00";//订单时间
        req.skip = 0;//
        req.limit = 50;
        [BeeCloud sendBCReq:req];
    } else if (self.actionType == 2) {
        BCQueryRefundReq *req = [[BCQueryRefundReq alloc] init];
        req.channel = channel;
        //  req.billno = @"20150722164700237";
        //  req.starttime = @"2015-07-21 00:00";
        // req.endtime = @"2015-07-23 12:00";
        //req.refundno = @"20150709173629127";
        req.skip = 0;
        req.limit = 20;
        [BeeCloud sendBCReq:req];
    }
}

#pragma maek tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return channelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sub = channelList[section][@"subChannel"];
    return sub.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return  channelList[section][@"channel"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"payChannelCell";
    
    PayChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[PayChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *row = channelList[indexPath.section][@"subChannel"][indexPath.row];
    cell.cImg.image = [UIImage imageNamed:channelList[indexPath.section][@"img"]];
    cell.title.text = row[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *row = channelList[indexPath.section][@"subChannel"];
    PayChannel channel = [row[indexPath.row][@"sub"] integerValue];
    if (self.actionType == 0) {
        switch (channel) {
            case PayChannelWxApp:
            case PayChannelAliApp:
            case PayChannelUnApp:
            case PayChannelBaiduApp:
                [self doPay:channel];
                break;
            case PayChannelWxNative:
            case PayChannelAliOfflineQrCode:
                [self doOfflinePay:channel authCode:@""];
                break;
            case PayChannelWxScan:
            case PayChannelAliScan:
                currentChannel = channel;
#if TARGET_IPHONE_SIMULATOR
                [self showAlertView:@"模拟器不能打开相机"];
#elif TARGET_OS_IPHONE
                [self showScanViewController];
#endif
                break;
            case PayChannelPayPal:
            case PayChannelPayPalSanBox:
                [self doPayPal];
                break;
            default:
                break;
        }
    } else {
        switch (channel) {
            case PayChannelWxScan:
                [self doQuery:PayChannelWx];
                break;
            case PayChannelAliScan:
            case PayChannelAliOfflineQrCode:
                [self doQuery:PayChannelAli];
                break;
            default:
                [self doQuery:channel];
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  打开摄像头，扫描用户的二维码
 */
- (void)showScanViewController {
    ScanViewController *scanView = [[ScanViewController alloc] init];
    scanView.delegate = self;
    [self presentViewController:scanView animated:YES completion:nil];
}

/**
 *  获得支付授权码，发起支付
 *
 *  @param authCode 支付授权码
 */
- (void)scanWithAuthCode:(NSString *)authCode {
    [self doOfflinePay:currentChannel authCode:authCode];
}

/**
 *  用户付款后，查询订单状态
 *
 *  @param resp 支付结果
 */
- (void)qrCodeBeScaned:(BCOfflinePayResp *)resp {
    BCOfflineStatusReq *req = [[BCOfflineStatusReq alloc] init];
    BCOfflinePayReq *payReq = (BCOfflinePayReq *)resp.request;
    req.channel = payReq.channel;
    req.billno = payReq.billno;
    [BeeCloud sendBCReq:req];
}

#pragma mark - prepare segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QueryResultViewController *viewController = (QueryResultViewController *)segue.destinationViewController;
    if([segue.identifier isEqualToString:@"queryResult"]) {
        viewController.dataList = self.payList;
    }
}

#pragma mark - 生成订单号
- (NSString *)genBillNo {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

- (void)setHideTableViewCell:(UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = view;
}

#pragma mark - Baidu Delegate
- (void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString *)payDescs {
    NSString *status = @"";
    switch (statusCode) {
        case 0:
            status = @"支付成功";
            break;
        case 1:
            status = @"支付中";
            break;
        case 2:
            status = @"支付取消";
            break;
        default:
            break;
    }
    [self showAlertView:status];
}

- (void)logEventId:(NSString *)eventId eventDesc:(NSString *)eventDesc {
    
}

@end
