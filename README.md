## BeeCloud iOS SDK (Open Source)

![pass](https://travis-ci.org/beecloud/beecloud-ios.svg) ![license](https://img.shields.io/badge/license-MIT-brightgreen.svg) ![version](https://img.shields.io/badge/version-v3.3.2-blue.svg) 

## 简介

本项目的官方GitHub地址是 [https://github.com/beecloud/beecloud-ios](https://github.com/beecloud/beecloud-ios)

目前已经包含微信APP、支付宝APP、银联在线APP、PayPal、百度钱包 APP支付功能，以及支付订单和退款订单的查询功能。还包含了线下收款功能(包括微信扫码、微信刷卡、支付宝扫码、支付宝条形码)，以及订单状态的查询与订单撤销。  
本SDK是根据[BeeCloud Rest API](https://github.com/beecloud/beecloud-rest-api) 开发的 iOS SDK, 适用于 iOS6 及以上版本。可以作为调用BeeCloud Rest API的示例或者直接用于生产。

## 流程

下图为整个支付的流程:
![pic](http://7xavqo.com1.z0.glb.clouddn.com/UML.png)

其中需要开发者开发的只有：

步骤①**（在App端）发送支付要素**

做完这一步之后就会跳到相应的支付页面（如微信app中），让用户继续后续的支付步骤

步骤⑤：**（在App端）处理同步回调结果**

付款完成或取消之后，会回到客户app中，需要做相应界面展示的更新（比如弹出框告诉用户"支付成功"或"支付失败")。非常不推荐用同步回调的结果来作为最终的支付结果，因为同步回调可能（虽然可能性不大）出现结果不准确的情况，最终支付结果应以下面的异步回调为准。

步骤⑦：**（在客户服务端）处理异步回调结果（[Webhook](https://beecloud.cn/doc/?index=8)）**
 
付款完成之后，根据客户在BeeCloud后台的设置，BeeCloud会向客户服务端发送一个Webhook请求，里面包括了数字签名，订单号，订单金额等一系列信息。客户需要在服务端依据规则要验证**数字签名是否正确，购买的产品与订单金额是否匹配，这两个验证缺一不可**。验证结束后即可开始走支付完成后的逻辑。

## 安装

方法一、下载本工程源码，将`BCPaySDK`文件夹中的代码拷贝进自己项目，并按照下文的3个步骤导入相应文件进自己工程即可。

- 下载的`BCPaySDK`文件夹下的`Channel`文件夹里包含了`支付宝`, `银联`, `微信`, `PayPal`,`OfflinePay`,`百度钱包`的原生SDK，请按需选择自己所需要的渠道。 

- iOS SDK使用了第三方Http请求库**AFNetworking**，请一起引入项目（如您之前已经使用AFNetworking，则无需重复导入，但是建议使用最新的AFNetworking版本，新版本修复了一个关于HTTPS链接的安全漏洞）。  

- 最后加入系统库 `libz.dylib`, `libsqlite3.dylib`, `libc++.dylib`。  
> iOS9 加入`libz.1.2.5.tbd`、`libc++.tbd`、`libsqlite3.tbd` 
 

- 使用PayPal支付，需要添加以下系统库：  
 `AudioToolbox.framework`  
 `CoreLocation.framework`  
 `MessageUI.framework`  
 `CoreMedia.framework`  
 `CoreVideo.framework`  
 `Accelerate.framework`  
 `AVFoundation.framework`  

- 使用百度钱包，需要添加以下系统库：  
![BDWalletVendor](http://7xavqo.com1.z0.glb.clouddn.com/BDWalletVendor.png)

方法二、使用CocoaPods   
在podfile中加入

```
pod 'BeeCloud' //包含支付宝微信银联三个渠道
pod 'BeeCloud/Alipay' //只包含支付宝
pod 'BeeCloud/Wx' //只包括微信
pod 'BeeCloud/UnionPay' //只包括银联
pod 'BeeCloud/PayPal' //只包括paypal
pod 'BeeCloud/Offline' //只包括线下收款
pod 'BeeCloud/Baidu' //只包括百度钱包
```

## 配置

① 添加`URL Schemes`  

在`Xcode`中，选择你的工程设置项，选中`TARGETS`，在`Info`标签栏的 `URL Types`添加`URL Schemes`。如果使用微信，填入所注册的微信应用程序`APPID`;如果不使用微信，则自定义，允许英文字母和数字，首字母必须是英文字母，建议起名稍复杂一些，尽量避免与支付宝(alipay)等其他程序冲突。  

![URL Schemes](http://7xavqo.com1.z0.glb.clouddn.com/scheme.png)
在Info.plist中显示为：

 ```
 <array>
	<dict>
		<key>CFBundleURLName</key>
		<string>zhifubao</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>payDemo</string>
		</array>
	</dict>
	<dict>
		<key>CFBundleURLName</key>
		<string>weixin</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>wxf1aa465362b4c8f1</string>
		</array>
	</dict>
 </array>
 ```

② `iOS 9`以上版本如果需要使用支付宝和微信支付，需要在`Info.plist`添加以下代码：

    ```
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>weixin</string>
        <string>wechat</string>
        <string>alipay</string>
    </array>
    ```
③ `iOS 9`默认限制了http协议的访问，如果App需要使用`http://`访问，必须在 `Info.plist`添加如下代码：

    ```
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    ```
④ 如果Build失败，遇到以下错误信息：

    ```
    XXXXXXX does not contain bitcode. You must rebuild it with bitcode enabled (Xcode setting ENABLE_BITCODE), obtain an updated library from the vendor, or disable bitcode for this target.
    ```
    请到 Xcode 项目的 Build Settings 页搜索 bitcode，将 Enable Bitcode 设置为 NO。


## 注册  

① 初始化

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //请替换成自己的BeeCloud账户中的AppID和AppSecret
    [BeeCloud initWithAppID:@"c5d1cba1-5e3f-4ba0-941d-9b0a371fe719" andAppSecret:@"39a7a518-9ac8-4a9e-87bc-7885f33cf18c"];

    //如果需要微信支付，请添加下面这行（自行替换微信APP ID）
    [BeeCloud initWeChatPay:@"wxf1aa465362b4c8f1"];

    //如果需要PayPal，请添加下面这行
    [BeeCloud initPayPal:@"AVT1Ch18aTIlUJIeeCxvC7ZKQYHczGwiWm8jOwhrREc4a5FnbdwlqEB4evlHPXXUA67RAAZqZM0H8TCR" secret:@"EL-fkjkEUyxrwZAmrfn46awFXlX-h2nRkyCVhhpeVdlSRuhPJKXx3ZvUTTJqPQuAeomXA8PZ2MkX24vF" sanBox:YES];
    return YES;
}
```

② handleOpenUrl

```objc
//为保证从支付宝，微信返回本应用，须绑定openUrl.
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    }
    return YES;
}

//iOS9之后apple官方建议使用此方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if (![BeeCloud handleOpenUrl:url]) {
        //handle其他类型的url
    }
    return YES;
}
```
 

## 使用方法
>具体使用请参考项目中的`BCPayExample`工程

实现接口`BeeCloudDelegate`，获取不同类型的请求对应的响应。  

*  使用以下方法设置delegate:

```objc
[BeeCloud setBeeCloudDelegate:self];
```

*  实现BeeCloudDelegate:

```objc
- (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
        	  //支付响应事件类型，包含微信、支付宝、银联、百度
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                BCPayReq *payReq = (BCPayReq *)resp.request;
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
        	  //查询订单或者退款记录响应事件类型
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
        	  //线下支付响应事件类型
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
        	  //线下支付订单状态查询响应事件类型
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
        	  //线下撤销订单响应事件类型，包含WX_SCAN,ALI_SCAN,ALI_OFFLINE_QRCODE
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
```

*  请求与响应事件说明  
   BeeCloud iOS SDK 的功能以事件为单元划分为：
   > 事件类型被定义在`/BCPaySDK/BeeCloud/Internal/BCPayConstant.h`
   * **请求事件**  
     `/BCPaySDK/BeeCloud/Classes/BCRequest/`目录下包含所有请求事件对象。  
   * **响应事件**  
     `/BCPaySDK/BeeCloud/Classes/BCResponse/`目录下包含所有响应事件对象。
     
     - 公共返回参数  

		参数名 | 类型 | 含义 
	---- | ---- | ----
	resultCode | Integer| 返回码，0为正常
	resultMsg  | String | 返回信息， OK为正常
	errDetail  | String | 具体错误信息
	bcId       | String | 成功发起支付后返回支付订单表记录唯一标识
	request    | BCBaseReq| 请求事件对象


### 支付

#### 微信&支付宝&银联&百度
通过构造`BCPayReq`的实例，使用`[BeeCloud sendBCReq:payReq]`方法发起支付请求。  
**响应事件对象为`BCPayResp`**

```objc
//微信、支付宝、银联、百度钱包
- (void)doPay:(PayChannel)channel {
    NSString *billno = [self genBillNo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    
    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = channel;
    payReq.title = billTitle;
    payReq.totalFee = @"1";
    payReq.billNo = billno;
    payReq.scheme = @"payDemo";
    payReq.billTimeOut = 300;
    payReq.viewController = self;
    payReq.optional = dict;
    [BeeCloud sendBCReq:payReq];
}

```

#### PayPal
通过构造`BCPayPalReq`的实例，使用`[BeeCloud sendBCReq:payReq]`方法发起支付请求。  
**响应事件对象为`BCBaseResp`**
 
 ```objc
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
    payReq.shortDesc = @"paypal test";
    payReq.viewController = self;
    payReq.payConfig = _payPalConfig;
    
    [BeeCloud sendBCReq:payReq]; 
}
 ```
##### 实现`PayPalPaymentDelegate`
  
> **支付完成后必须进行Verify的操作**

```objc
//支付完成
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {

	//使用`completedPayment`完成Payment Verify操作
	BCPayPalVerifyReq *req = [[BCPayPalVerifyReq alloc] init];
   req.payment = _completedPayment;
   [BeeCloud sendBCReq:req];
   
   [self dismissViewControllerAnimated:YES completion:nil];
}
//支付取消
- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
   
    [self dismissViewControllerAnimated:YES completion:nil];
}
```

#### 百度钱包  
通过构造`BCPayReq`的实例，使用`[BeeCloud sendBCReq:req]`方法发起支付查询。
**响应事件类型对象：`BCPayResp`**

```objc

//向BeeCloud获取orderInfo
- (void)doPay:(PayChannel)channel {
    NSString *billno = [self genBillNo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];

    BCPayReq *payReq = [[BCPayReq alloc] init];
    payReq.channel = channel;//渠道
    payReq.title = @"BeeCloud自制白开水";//订单标题
    payReq.totalfee = @"1";//订单金额
    payReq.billTimeOut = 300; //订单超时时间，秒位单位，建议大于5分钟
    payReq.billno = billno;//商户自定义订单号，必须保证唯一性
    payReq.optional = dict;//商户业务扩展参数
    [BeeCloud sendBCReq:payReq];
}
//发起支付
- (void)onBeeCloudResp:(BCBaseResp *)resp {
    
    switch (resp.type) {
        case BCObjsTypePayResp:
        {
            BCPayResp *tempResp = (BCPayResp *)resp;
            if (tempResp.resultCode == 0) {
                BCPayReq *payReq = (BCPayReq *)resp.request;
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
        default:
        {
            if (resp.result_code == 0) {
                [self showAlertView:resp.result_msg];
            } else {
                [self showAlertView:resp.err_detail];
            }
        }
            break;
    }
}
实现BDWalletSDKMainManagerDelegate
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
```

#### OfflinePay
通过构造`BCOfflinePayReq`的实例，使用`[BeeCloud sendBCReq:req]`方法发起支付订单查询。  
**响应事件类型对象：`BCOfflinePayResp`**

```objc
- (void)doOfflinePay:(PayChannel)channel authCode:(NSString *)authcode {
    NSString *billno = [self genBillNo];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value",@"key", nil];
    
    BCOfflinePayReq *payReq = [[BCOfflinePayReq alloc] init];
    payReq.channel = channel;
    payReq.title = @"Offline Pay";
    payReq.totalfee = @"1";
    payReq.billno = billno;
    payReq.authcode = authcode;
    payReq.terminalid = @"BeeCloud617"; 
    payReq.storeid = @"BeeCloud618";
    payReq.optional = dict;
    [BeeCloud sendBCReq:payReq];
}
```

##### 订单状态查询
通过构造`BCOfflineStatusReq`的实例，使用`[BeeCloud sendBCReq:req]`方法发起支付订单查询。  
**响应事件类型对象：`BCOfflineStatusResp`**

```objc
BCOfflineStatusReq *req = [[BCOfflineStatusReq alloc] init];
req.channel = PayChannelWxScan;
req.billno = @"2015091821320048";
[BeeCloud sendBCReq:req];               
```

##### 订单撤销
通过构造`BCOfflineRevertReq`的实例，使用`[BeeCloud sendBCReq:req]`方法发起支付订单撤销。目前仅支持`WX_SCAN`、`ALI_OFFLINE_QRCODE`、`ALI_SCAN`  
**响应事件类型对象：`BCOfflineRevertResp`**

```objc
BCOfflineRevertReq *req = [[BCOfflineRevertReq alloc] init];
req.channel = PayChannelWxScan;
req.billno = @"2015091821320048";
[BeeCloud sendBCReq:req];
```


### 查询

#### 查询支付订单  
通过构造`BCQueryReq`的实例，使用`[BeeCloud sendBCReq:req]`方法发起支付查询。  
**响应时间类型对象：`BCQueryResp`**   
**支付订单对象: `BCQueryBillResult`**  

```objc
BCQueryReq *req = [[BCQueryReq alloc] init];
//req.channel = channel;
req.billno = @"20150722164700237";
//req.starttime = @"2015-07-21 00:00";
//req.endtime = @"2015-07-23 12:00";
req.skip = 0;
req.limit = 20;
[BeeCloud sendBCReq:req];
```

#### 查询退款订单  
通过构造`BCQueryRefundReq`的实例，使用`[BeeCloud sendBCReq:req]`方法发起退款查询。  
**响应事件类型对象：`BCQueryResp`**  
**退款订单对象: `BCQueryRefundResult`**

```objc
   BCQueryRefundReq *req = [[BCQueryRefundReq alloc] init];
   //req.channel = channel;
   req.billno = @"20150722164700237";
   //req.starttime = @"2015-07-21 00:00";
   //req.endtime = @"2015-07-23 12:00";
   //req.refundno = @"20150709173629127";
   req.skip = 0;
   req.limit = 20;
   [BeeCloud sendBCReq:req];
```

#### 查询退款状态（只支持微信）
通过构造`BCRefundStatusReq`的实例，使用`[BeeCloud sendBCReq:req]`方法发起退款查询。  
**响应事件类型对象：`BCRefundStatusResp`**

```objc
BCRefundStatusReq *req = [[BCRefundStatusReq alloc] init];
req.refundno = @"20150709173629127";
[BeeCloud sendBCReq:req];
```

## Demo
项目中的`BCPayExample`文件夹为我们的demo文件  
在真机上运行`BCPayExample`target，体验真实支付场景

## 测试
项目根目录命令行运行`bash runTest.sh`, 就可以完成Unit Test。

## 常见问题
- 关于weekhook的接收  
文档请阅读 [webhook](https://github.com/beecloud/beecloud-webhook)

- 支付宝支付时，提示“ALI69”，“ALI64”？  
一般是因为RSA公钥不正确或未上传导致的。解决方法：在[支付宝商家服务平台](https://b.alipay.com/order/serviceIndex.htm)检查RSA公钥是否生成错误或者没上传。

- BCPayExample中支付宝支付，跳转到支付后提示“系统繁忙”？    
由于支付宝政策原因，故不再提供支付宝支付的测试功能，请在BeeCloud平台配置正确参数后，使用自行创建的APP的appID和appSecret。给您带来的不便，敬请谅解。

- 在iPhone上未安装支付宝钱包客户端的情况下，APP内发起支付宝支付，会是怎么样的？  
正常情况下，会跳到支付宝网页收银台。如果你是从webview发起的支付请求，则不会跳转，请提示用户当前手机没安装APP。

- iPhone未安装支付宝钱包不跳转支付？  
在调用支付的时候取下[[[UIApplication shareApplication] windows] index:0] 看看hidden属性是否为YES 如果是就隐藏了window，H5就出不来了设置为NO就可以了 [[[UIApplication sharedApplication] windows] objectAtIndex:0]; 或 把您的App中把第0个window的hidden属性改成NO，就可以了。

- iOS跳转到微信后立刻返回原APP？  
可能是由于微信中还保持上次等待支付的场景导致的。后台关闭微信，重新发起微信支付就正常了。

## 代码贡献
我们非常欢迎大家来贡献代码，我们会向贡献者致以最诚挚的敬意。

一般可以通过在Github上提交[Pull Request](https://github.com/beecloud/beecloud-dotnet-sdk)来贡献代码。

Pull Request要求

- 代码规范 

- 代码格式化 

- 必须添加测试！ - 如果没有测试（单元测试、集成测试都可以），那么提交的补丁是不会通过的。

- 记得更新文档 - 保证`README.md`以及其他相关文档及时更新，和代码的变更保持一致性。

- 创建feature分支 - 最好不要从你的master分支提交 pull request。

- 一个feature提交一个pull请求 - 如果你的代码变更了多个操作，那就提交多个pull请求吧。

- 清晰的commit历史 - 保证你的pull请求的每次commit操作都是有意义的。如果你开发中需要执行多次的即时commit操作，那么请把它们放到一起再提交pull请求。

## 联系我们
- 如果有什么问题，可以到BeeCloud开发者1群:**321545822** 或 BeeCloud开发者2群:**427128840** 提问
- 更详细的文档，见源代码的注释以及[官方文档](https://beecloud.cn/doc/?index=1)
- 如果发现了bug，欢迎提交[issue](https://github.com/beecloud/beecloud-dotnet-sdk/issues)
- 如果有新的需求，欢迎提交[issue](https://github.com/beecloud/beecloud-dotnet-sdk/issues)

## 代码许可
The MIT License (MIT).
