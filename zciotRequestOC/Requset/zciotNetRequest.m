//
//  zciotNetRequest.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "zciotNetRequest.h"
#import "AFdanli.h"
@implementation zciotNetRequest
+ (zciotNetRequest *)shareSocket{
    static zciotNetRequest *shareManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareManager = [self new];
    });
    return shareManager;
}
#pragma mark ／／／／／／／／socket／／／／／／／／／／
-(void) initSocketMoudle {
    //serverIPStr = [ConfigManager getValueByKey:@"SocketServerIP"];
    //serverPortStr = [ConfigManager getValueByKey:@"SocketServerPort"];
    NSLog(@"--------------");//192.168.1.223  114.215.107.206
    _serverIPStr = socketIP;
    serverPortStr = socketPort;
    self.isConnected = NO;
    
    @try {
        @autoreleasepool {
            if (self.dataClient!=NULL && self.dataClient!=nil) {
                [self.dataClient disconnect];
                self.dataClient = nil;
            }
            if (getDataQueue) {
                dispatch_release(getDataQueue);
            }
            getDataQueue = dispatch_queue_create("dataSendGetQueue", NULL);
            dispatch_async(getDataQueue,^{
                self.dataClient = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:getDataQueue];
                NSError *error = nil;
                if (![self.dataClient connectToHost:self.serverIPStr onPort:[serverPortStr intValue] withTimeout:TIMEDOUT_TIME error:&error]) {
                    NSLog(@"Error connecting: %@", error);
                }
            });
        }
    }
    @catch (NSException *exception) {
        NSLog(@"initSocketMoudle error : %@",exception);
    }
}
#pragma mark  Socket Delegate
#pragma mark // 连接状态
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"test = >%@",[NSThread currentThread]);
    NSLog(@"%@",[NSDate new]);
    NSLog(@"socket:%p didConnectToHost:%@ port:%d", sock, host, port);
    if (self.dataClient==sock) {
        self.isConnected=YES;
        socketConnCount=0;//每次连接成功都设置为0
        self.lastDate = [NSDate date];
        NSLog(@"接收线程连接成功 connected!");
        [NSThread detachNewThreadSelector:@selector(startSendHeartBeat:) toTarget:self withObject:sock];
        [sock readDataWithTimeout:-1 tag:GetDataTag];
        //        if (self.isLogin) {
        //            [self sendLoginInfo];
        //        }
//        [self sendScoketMsgDict:[NSDictionary dictionaryWithObjectsAndKeys:self.phoneImei,@"imei",@"2",@"system", nil] type:WJDataType_APPVERSION];
//        [sock readDataWithTimeout:-1 tag:GetDataTag];
//        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//        // 沙盒中读取信息
//        NSString *name = [defaults objectForKey:KEY_USER_NAME];
//        NSString *pwd = [defaults objectForKey:KEY_USER_PWD];
//        
//        if (name && pwd) {
//            NSLog(@"name = %@,pwd=%@",name,pwd);
//            self.password = pwd;
//            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:name,@"mobilePhone",self.phoneImei,@"imei",pwd,@"password",@"2",@"type", nil];//
//            
//            
//            NSString* str = [[DataParser getInstance] getSocketSendData:WJDataType_Login params:[dict JSONString]];
//            
//            [self sendStringMsg:self.dataClient str:str tag:2];
//        }
        
        //[sock readDataWithTimeout:-1 tag:GetDataTag];
        
    }
}


#pragma mark // 接收心跳和数据
// tag:1为心跳数据 2为数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"--------->socket:%p didReadData:withTag:%ld", sock, tag);
    if (self.dataClient==sock) {
        NSString* dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *str = [dataStr substringToIndex:dataStr.length-1];
        if([str hasSuffix:@"*"] && [str hasPrefix:@"#"]){
            id obj = [[DataParser getInstance] handleAccpetData:dataStr];
            
            // [sock readDataWithTimeout:-1 tag:HeartbeatTag];
            [sock readDataWithTimeout:-1 tag:GetDataTag];
            NSLog(@"%@",obj);
            if (obj) {
                NSDictionary *dict = (NSDictionary *)obj;
                
               // NSString *type = [dict objectForKey:@"dataType"];
                //                if([WJDataType_StudentList isEqualToString:type]){
                //                    [NSThread detachNewThreadSelector:@selector(handleSocketData:) toTarget:self withObject:dict];
                //                }else{
                //
                //                }
                [self performSelectorOnMainThread:@selector(handleSocketData:) withObject:dict waitUntilDone:NO];
            }
        }else{
            NSLog(@"===>%@",_socketValue);
            [_socketValue appendString:dataStr];
            NSString *re = [_socketValue substringToIndex:_socketValue.length-1];
            if ([re hasSuffix:@"*"] && [re hasPrefix:@"#"]) {
                //[_socketValue appendString:@" "];
                NSString *ss = [NSString stringWithFormat:@"%@",_socketValue];
                _socketValue = [NSMutableString new];
                id obj = [[DataParser getInstance] handleAccpetData:ss];
                
                // [sock readDataWithTimeout:-1 tag:HeartbeatTag];
                [sock readDataWithTimeout:-1 tag:GetDataTag];
                
                if (obj) {
                    NSDictionary *dict = (NSDictionary *)obj;
                    
                    NSString *type = [dict objectForKey:@"dataType"];
                    if([WJDataType_StudentList isEqualToString:type]){
                        [NSThread detachNewThreadSelector:@selector(handleSocketData:) toTarget:self withObject:dict];
                    }else{
                        [self performSelectorOnMainThread:@selector(handleSocketData:) withObject:dict waitUntilDone:NO];
                    }
                }
            }
        }
        
        
        [sock readDataWithTimeout:-1 tag:GetDataTag];
    }
}

static int socketMaxCount=15;

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    self.isConnected=NO;
    self.isSocketLogin = NO;
    if (sock==self.dataClient) {
        //NSLog(@"连接断开!");
    }
    //[self tips:@"s连接断开"];
    if (socketConnCount > socketMaxCount) {
        //NSLog(@"网络异常，无法连接");
        // TODO
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"城市公交"
        //                                                            message:[NSString stringWithFormat:@"%@",@"连接失败，请检查网络设置！"]
        //                                                           delegate:self
        //                                                  cancelButtonTitle:@"OK"
        //                                                  otherButtonTitles:nil];
        //        [alertView show];
    } else {
        // 重连睡眠时间
        sleep(3);
        [self reconnect:nil];
        socketConnCount++;
    }
    //NSLog(@".....");
}

-(void) reconnect:(id) sender {
    
    if (!self.hudIsHide) {
        [self hideHud];
        [SVProgressHUD showErrorWithStatus:@"网络异常!" duration:.8];
    }
    //NSLog(@"--->%@",[NSThread currentThread]);
    NSError *error = nil;
    if (![self.dataClient connectToHost:_serverIPStr onPort:[serverPortStr intValue] withTimeout:TIMEDOUT_TIME error:&error]) {
        //NSLog(@"yes");
    }else{
        //NSLog(@"no  重连接");
        
        //
    }
    //NSLog(@"test = >%@",[NSThread currentThread]);
}
-(void)hideHud{
    [SVProgressHUD dismiss];
    self.hudIsHide = YES;
}
#pragma mark 发送数据
- (void) sendStringMsg:(GCDAsyncSocket*)newClient str:(NSString*) str tag:(int) tag {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (!str || [str length] <=0) {
        //NSLog(@"sendStringMsg: strMsg is empty!!!");
        //return;
    }else{
        NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
        // 发送数据
        // [newClient writeData:data withTimeout:-1 tag:tag];
        [newClient writeData:data withTimeout:-1 tag:GetDataTag];
    }
    
    
    // 继续监听读取
    // [newClient readDataWithTimeout:-1 tag:tag];
    [newClient readDataWithTimeout:-1 tag:GetDataTag];
    
    // 读取指定长度的数据
    // [client readDataToLength:1024 withTimeout:5 tag:GetDataTag];
    
    // sleep(1);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)showMsgHud:(id)sender{
    [SVProgressHUD showErrorWithStatus:@"网络异常!" duration:.8];
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (void) sendScoketMsgDict:(NSDictionary*) dict type:(NSString*)type{
    NSLog(@"====-===%@",[NSThread currentThread]);
    if (![self isConnectionAvailable]) {
        
//        [self performSelectorInBackground:@selector(msgHandle:) withObject:nil];
        [SVProgressHUD showErrorWithStatus:@"网络异常!" duration:.8];
        return;
    }
    [self checkSocketInfo];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (dict) {
        NSString * param= [self dictionaryToJson:dict];
        NSString* str = [[DataParser getInstance] getSocketSendData:type params:param];
        NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
        // 发送数据
        // [newClient writeData:data withTimeout:-1 tag:tag];
        [self.dataClient writeData:data withTimeout:-1 tag:GetDataTag];
    }else{
        NSLog(@"sendStringMsg: strMsg is empty!!!");
    }
    
    // 继续监听读取
    // [newClient readDataWithTimeout:-1 tag:tag];
    [self.dataClient readDataWithTimeout:-1 tag:GetDataTag];
    
    // 读取指定长度的数据
    // [client readDataToLength:1024 withTimeout:5 tag:GetDataTag];
    
    // sleep(1);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)checkSocketInfo{
    NSLog(@"sendLoginInfo");
    if (!self.isConnected) {
        if (!self.dataClient ) {
            NSLog(@"sendLoginInfo--> dataClient = null");
            [self initSocketMoudle];
        }else{
            [self reconnect:nil];
        }
        
    }
    
}

#pragma mark ---发送心跳
-(void)startSendHeartBeat:(id) sender{
    if (heartBeatTimer) {
        [heartBeatTimer invalidate];
        heartBeatTimer = nil;
    }
    heartBeatTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:HeartbeatInterval target:self selector:@selector(sendHeartBeatBy:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:heartBeatTimer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:INT32_MAX]];
}

-(void)sendHeartBeatBy:(id) sender{
    // 连接中断重连
    NSDate* lastDate = self.lastDate;
    NSString* interval = [NSDate timeIntervalToNow:lastDate];
    if ([interval intValue] > HeartbeatTimeInterval+30) {
        [self reconnect:nil];
    }
    if (self.isConnected) {
        @try {
            // 更新序号
            heartbeatCount++;
            if (heartbeatCount>=INT32_MAX) {
                heartbeatCount=0;
            }
            // 心跳数据格式
            //TODO imei
            NSString* heartbeatData = [[DataParser getInstance] getSocketSendData:WJDataType_HeartBeat params:[NSString stringWithFormat:@"{'imei':'%@'}",[self getToken]]];
            // 发送心跳
            [self sendStringMsg:self.dataClient str:heartbeatData tag:HeartbeatTag];
        }
        @catch (NSException *exception) {
            NSLog(@"sendHeartBeat error: %@",exception);
        }
    }
}
-(NSString*)getToken{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:KEY_DeviceTokenString];
    if (!token) {
        token = @"b629735c42085a6c5193bf532365279cb5cfc6a88e7124487ba8af1a55913b68";
    }
    return  token;
}
#pragma mark - -----------socket返回数据处理-----------
//// 读取接收的数据
//- (void)readStream {
//    char buffer[1024];
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    while (recv(CFSocketGetNative(socket), //与本机关联的Socket 如果已经失效返回－1:INVALID_SOCKET
//                buffer, sizeof(buffer), 0)) {
//        NSLog(@"%@", [NSString stringWithUTF8String:buffer]);
//    }
//}
//方法二


-(void)handleSocketData:(NSDictionary *)dict{
    
    
    NSLog(@"--------->handleSocketData");
    
    NSString *type = [dict objectForKey:@"dataType"];
    NSLog(@"%@",type);
    [self hideHud];
    if ([WJDataType_Login isEqualToString:type]) { //登录
        UserModel* user = [dict objectForKey:@"data"];
        if (user) {
            if ([SocketSuccessed isEqualToString:user.msgCode ]){
                NSLog(@"测试，通信成功");
                //NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                
//                if (self.appDelegate.qingcFlag == 1) {
//                    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
//                    
//                    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];//清空所有
//                    self.appDelegate.shuaxin = 1;
//                }
                
                
                // self.password  =@"111111";
                // 同步到沙盒中
//                user.imei = self.phoneImei;
//                user.password = self.password;
//                user.token = self.phoneImei;
                //self.appDelegate.userDto.Id = user.Id;
                //[self saveNSUserDefaults];
//                [defaults setObject:user.mobilePhone forKey:KEY_USER_PHONE];
//                [defaults setObject:user.isBindDevice forKey:KEY_USER_isBindDevice];
//                [defaults setObject:user.Id forKey:KEY_USER_ID];
//                [defaults setObject:user.kdid forKey:KEY_USER_KDID];
//                //[defaults setObject:self.appDelegate.userDto.Id forKey:KEY_USER_ID];
//                
//                [defaults setObject:user.password forKey:KEY_USER_PWD];
//                [defaults setObject:user.isBindDevice forKey:KEY_USER_isBindDevice];
//                //[defaults setObject:user.user_id forKey:KEY_USER_ID];
//                
//                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
//                [defaults setObject:data forKey:KEY_KD_USER];
//                [defaults synchronize];
//                [self removeUser];
//                self.userDto = user;
                
                //                UIImage * img = [CommonTools readImageWithUrl:self.userDto.userImage imgData:nil];
                //                if (img) {
                //                    self.img_head = img;
                //                }else{
                //                    [self saveImgWithUrl:self.userDto.userImage];
                //                }
                //if (self.navViewCtrl) {
                // if ([self.navViewCtrl.topViewController isKindOfClass:[LoginViewController class]]) {
                //LoginViewController *vc = (LoginViewController*)self.navViewCtrl.topViewController;
                //if (self.relo == 1) {
                //}else{
                
                               // if (self.relo == 1) {
                    //[self.slider showRight];
                    //[self.navViewCtrl popToRootViewControllerAnimated:YES];
                    // [self.navViewCtrl popToViewController:[self.navViewCtrl.viewControllers objectAtIndex:0] animated:YES];
                    //[self.navViewCtrl popToRootViewControllerAnimated:YES];
                
               // [self loginEaseWithName:user.mobilePhone pwd:user.password];
                
            }else if ([SocketFailed isEqualToString:user.msgCode]){
                
                [SVProgressHUD showErrorWithStatus:@"登录失败!" duration:1.0];
            }else if ([@"2" isEqualToString:user.msgCode]){
                
                [SVProgressHUD showErrorWithStatus:@"用户密码错误!" duration:1.2];
            }else if ([@"3" isEqualToString:user.msgCode]){
                
                [SVProgressHUD showErrorWithStatus:@"号码为手环号码!" duration:1.2];
            }else if ([@"-1" isEqualToString:user.msgCode]){
                NSLog(@"32313131");
            }
        }
    }else if ([WJDataType_SMS isEqualToString:type]){
        //短信验证码返回
        NSDictionary *dict_data = [dict objectForKey:@"data"];
        NSString *msgCode = [dict_data objectForKey:@"msgCode"];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            [self hideHud];
            NSLog(@"测试，通信成功");
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[LoginViewController class]]) {
//                    LoginViewController *vc = (LoginViewController*)self.navViewCtrl.topViewController;
//                    [vc getSMSResult:dict];
//                }
//            }
        }else if ([SocketFailed isEqualToString:msgCode]){
            [self hideHud];
            [SVProgressHUD showErrorWithStatus:@"获取失败!" duration:1.0];
        }else if ([@"2" isEqualToString:msgCode]){
            [self hideHud];
            [SVProgressHUD showErrorWithStatus:@"获取次数超过3次，请明天再试!" duration:1.6];
            
        }
        //else if ([@"3" isEqualToString:msgCode]){
        //            [self hideHud];
        //            [SVProgressHUD showErrorWithStatus:@"用户已经注册!" duration:1.3];
        //        }
        else if ([@"3" isEqualToString:msgCode]){
            [self hideHud];
            [SVProgressHUD showErrorWithStatus:@"用户不存在!" duration:1.2];
        }
    }else if ([WJDataType_YUYIN isEqualToString:type]){
        //语音验证码返回
        NSDictionary *dict_data = [dict objectForKey:@"data"];
        NSString *msgCode = [dict_data objectForKey:@"msgCode"];
        
        if ([SocketSuccessed isEqualToString:msgCode]) {
            [self hideHud];
            
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[LoginViewController class]]) {
//                    LoginViewController *vc = (LoginViewController*)self.navViewCtrl.topViewController;
//                    [vc getYUYINResult:dict];
//                }
//            }
        }else if ([SocketFailed isEqualToString:msgCode]){
            [self hideHud];
            [SVProgressHUD showErrorWithStatus:@"获取失败!" duration:1.0];
        }else if ([@"2" isEqualToString:msgCode]){
            [self hideHud];
            [SVProgressHUD showErrorWithStatus:@"获取次数超过3次，请明天再试!" duration:1.6];
            
        }
        //else if ([@"3" isEqualToString:msgCode]){
        //            [self hideHud];
        //            [SVProgressHUD showErrorWithStatus:@"用户已经注册!" duration:1.3];
        //        }
        else if ([@"3" isEqualToString:msgCode]){
            [self hideHud];
            [SVProgressHUD showErrorWithStatus:@"用户不存在!" duration:1.2];
        }
    }else if ([WJDataType_Register isEqualToString:type]){
        //注册返回
        NSString *msgCode = [dict objectForKey:@"data"];
        [self hideHud];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[SetPwdViewController class]]) {
//                    SetPwdViewController *vc = (SetPwdViewController*)self.navViewCtrl.topViewController;
//                    [vc getResult:dict];
//                }
//            }
        }
        //else if ([SocketFailed isEqualToString:msgCode]){
        //
        //            [SVProgressHUD showErrorWithStatus:@"注册失败!" duration:1.0];
        //        }
        else if ([@"2" isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"验证码错误！" duration:1.0];
        }else if ([@"3" isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"昵称重复!" duration:1.0];
        }
    }else if ([WJDataType_ResetPwd isEqualToString:type]){
        //重置密码返回
        NSString *msgCode = [dict objectForKey:@"data"];
        [self hideHud];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[ResetPwdViewController class]]) {
//                    ResetPwdViewController *vc = (ResetPwdViewController*)self.navViewCtrl.topViewController;
//                    [vc getResult:dict];
//                }
//            }
        }else if ([SocketFailed isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"重置密码失败!" duration:1.0];
        }else if ([@"2" isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"验证码错误！" duration:1.0];
        }
    }else if ([WJDataType_ModifyAlias isEqualToString:type]){
        //修改昵称 返回
        NSString *msgCode = [dict objectForKey:@"data"];
        [self hideHud];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功！" duration:1.0];
            NSLog(@"--->");
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[ModifyViewController class]]) {
//                   	
//                    ModifyViewController *vc = (ModifyViewController*)self.navViewCtrl.topViewController;
//                    
//                    [vc getResult];
//                    //                    [UIView animateWithDuration:1.8 animations:^{
//                    //
//                    //                    } completion:^(BOOL finished) {
//                    //
//                    //                    }];
//                }
//            }
        }else if ([SocketFailed isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"修改失败!" duration:1.0];
        }else if ([@"2" isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"昵称重复！" duration:1.0];
        }
    }else if ([WJDataType_ModifyPwd isEqualToString:type]){
        //修改昵称 返回
        NSString *msgCode = [dict objectForKey:@"data"];
        [self hideHud];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            
            [SVProgressHUD showSuccessWithStatus:@"修改成功！" duration:1.0];
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[ModifyPwdViewController class]]) {
//                    ModifyPwdViewController *vc = (ModifyPwdViewController*)self.navViewCtrl.topViewController;
//                    [vc getResult];
//                    
//                }
//            }
            
            
        }else if ([SocketFailed isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"修改失败!" duration:1.0];
        }else if ([@"2" isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"用户密码错误！" duration:1.2];
        }else if ([@"3" isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"用户不存在！" duration:1.0];
        }
    }else if ([WJDataType_Feedback isEqualToString:type]){
        //修改昵称 返回
        NSString *msgCode = [dict objectForKey:@"data"];
        [self hideHud];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            
            [SVProgressHUD showSuccessWithStatus:@"提交成功！" duration:1.0];
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[FeedbackViewController class]]) {
//                    FeedbackViewController *vc = (FeedbackViewController*)self.navViewCtrl.topViewController;
//                    [vc getResult];
//                    
//                }
//            }
            
            
        }else if ([SocketFailed isEqualToString:msgCode]){
            
            [SVProgressHUD showErrorWithStatus:@"提交失败!" duration:1.0];
        }
    }else if ([WJDataType_StudentList isEqualToString:type]){
        //设备列表 返回
        NSString *msgCode = [dict objectForKey:@"data"];
        [self hideHud];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[DeviceViewController class]]) {
//                    NSArray *arr = [dict objectForKey:@"arr"];
//                    DeviceViewController *vc = (DeviceViewController*)self.navViewCtrl.topViewController;
//                    [vc getResult:arr];
//                    
//                }
//            }
            
            
        }else{
            // if ([SocketFailed isEqualToString:msgCode])
            [SVProgressHUD showErrorWithStatus:@"网络异常!" duration:1.0];
        }
    }else if ([WJDataType_VedioList isEqualToString:type]){
        //设备列表 返回
        NSString *msgCode = [dict objectForKey:@"data"];
        [self hideHud];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[MediaListViewController class]]) {
//                    NSArray *arr = [dict objectForKey:@"arr"];
//                    MediaListViewController *vc = (MediaListViewController*)self.navViewCtrl.topViewController;
//                    [vc getResult:arr];
//                    
//                }
//            }
            
            
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"网络异常!" duration:1.0];
        }
    }else if ([WJDataType_SetDev isEqualToString:type]){
        //设备列表 返回
        NSString *msgCode = [dict objectForKey:@"data"];
        [self hideHud];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            
//            if (self.navViewCtrl) {
//                if ([self.navViewCtrl.topViewController isKindOfClass:[DeviceViewController class]]) {
//                    DeviceViewController *vc = (DeviceViewController*)self.navViewCtrl.topViewController;
//                    [SVProgressHUD showSuccessWithStatus:@"设置成功！" duration:1.0];
//                    [vc getDevResult];
//                    
//                }
//            }
        }else {
            
            [SVProgressHUD showErrorWithStatus:@"网络异常!" duration:1.0];
        }
    }else if ([WJDataType_APPVERSION isEqualToString:type]){
        //版本 返回
        NSDictionary* dicts = [dict objectForKey:@"data"];
        NSString *msgCode = [dicts objectForKey:@"msgCode"];
        NSLog(@"--->dict = %@",dict);
        //[self hideHud];
        if ([SocketSuccessed isEqualToString:msgCode]) {
            
//            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//            NSString *html = [defaults objectForKey:KEY_APP_HTML];
//            
//            NSString *htmlVersion = [dicts objectForKey:@"description"];
//            if(html){
//                if ([html isEqualToString:htmlVersion]) {
//                    //和原来一样 不做操作
//                }else{
//                    //不一样
//                    [self removeCache];//清除缓存
//                }
//            }else{
//                [self removeCache];
//            }
//            
//            [defaults setObject:htmlVersion forKey:KEY_APP_HTML];
//            [defaults synchronize];
//            
//            NSString *code = [dicts objectForKey:@"code"];
//            NSLog(@"code = %@",code);
//            NSDictionary *localDic =[[NSBundle mainBundle] infoDictionary];
//            NSString *localVersion =[localDic objectForKey:@"CFBundleShortVersionString"];
//            NSLog(@"%@",localVersion);
//            if (![localVersion isEqualToString:code]) {
//                int now = [self intValueFromString:code];
//                int local = [self intValueFromString:localVersion];
//                NSLog(@"%d",now);
//                NSLog(@"%d",local);
//                //                if (now<local) {
//                //                    self.versionUrl = [dicts objectForKey:@"url"];
//                //                    self.versionUrl = @"https://itunes.apple.com/us/app/xiaoerlang/id977916076?mt=8&uo=4";
//                //                    NSString *msg = GetVersionMsg(@"小儿郎");
//                //                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"小儿郎" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
//                //                    alertView.tag = 11;
//                //                    [alertView show];
//                //                }
//                
//            }
//        }else {
//            
//            
//        }
    }
    
    }
}
#pragma mark 是否有网络
-(BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = NO;
    ZReachability *reach = [ZReachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            NSLog(@"WIFI");
            //self.appDelegate.dingwei = 1;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            NSLog(@"3G");
            break;
    }
    return isExistenceNetwork;
}
#pragma 监测网络的可链接性
+ (BOOL)ZciotNetWorkReachabilityWithURLString:(NSString *)strUrl
{
    __block BOOL netState = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    
    if ([AFdanli shareInstance].manager) {
        
    }else{
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        [AFdanli shareInstance].manager = manager;
    }
    
    NSOperationQueue *operationQueue = [AFdanli shareInstance].manager.operationQueue;
    
    [[AFdanli shareInstance].manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [[AFdanli shareInstance].manager.reachabilityManager startMonitoring];
    
    return netState;
}


/***************************************
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 ******************************/

#pragma --mark GET请求方式
+ (void) ZciotRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    if ([AFdanli shareInstance].manager) {
        
    }else{
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        [AFdanli shareInstance].manager = manager;
    }
    AFHTTPRequestOperation *op = [[AFdanli shareInstance].manager GET:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DDLog(@"%@", dic);
        
        block(dic);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error description]);
        failureBlock();
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
    
}

#pragma --mark POST请求方式

+ (void) ZciotRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock
{
    if ([AFdanli shareInstance].manager) {
        
    }else{
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
        [AFdanli shareInstance].manager = manager;
    }
    
    AFHTTPRequestOperation *op = [[AFdanli shareInstance].manager POST:requestURLString parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        DDLog(@"%@", dic);
        
        block(dic);
        /***************************************
         在这做判断如果有dic里有errorCode
         调用errorBlock(dic)
         没有errorCode则调用block(dic
         ******************************/
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
    }];
    
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op start];
    
}
//上传图片到服务器
+ (void)sendPhotoToDevDiv:(NSData *)imageData userId:(NSString *)userId;
{
 
    [SVProgressHUD showWithStatus:@"正在上传头像..." maskType:SVProgressHUDMaskTypeBlack];
    if (!imageData)
    {
        return;
    }
    
    
    //  Create devdiv photo post request
    NSURLRequest *urlRequest = [self createDevDivPostRequest:imageData userId:userId];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    zciotNetRequest *weakSelf = (zciotNetRequest *)self;
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error){
         zciotNetRequest *strongSelf = weakSelf;
         [SVProgressHUD dismiss];
         if (strongSelf)
         {
             if ([data length] >0 && error == nil){
                 strongSelf.responseData = [[NSString alloc] initWithData:data
                                                                 encoding:NSUTF8StringEncoding];
                 NSLog(@"strongSelf.responseData = %@",strongSelf.responseData);
                 
                 //[strongSelf performSelectorOnMainThread:@selector(updateRemotePic) withObject:nil waitUntilDone:NO];
                 NSData* jsonData = [strongSelf.responseData dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
                 if (resultsDictionary) {
                     NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
                     if ([@"0" isEqualToString:msgCode]) {
                         [SVProgressHUD showSuccessWithStatus:@"上传成功" duration:1.0];
                         NSString *url = [resultsDictionary objectForKey:@"url"];
                         NSLog(@"%@",url);
//                         self.appDelegate.userDto.userImage = url;
//                         //保存图片到本地
//                         self.portraitImage = [UIImage imageWithData:imageData];
//                         
//                         
//                         [CommonTools readImageWithUrl:url imgData:imageData];
//                         [self performSelectorOnMainThread:@selector(reloadTableRow) withObject:nil waitUntilDone:NO];
//                         //[self.tableView reloadData];
                     }
                 }
                 
                 
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"Nothing was downloaded.");
                 [SVProgressHUD showErrorWithStatus:@"上传失败!" duration:1];
             }
             else if (error != nil){
                 NSLog(@"Error happened = %@", error);
                 [SVProgressHUD showErrorWithStatus:@"上传失败!" duration:1];
             }
         }
         else
         {
             NSLog(@"Controller is released before block is executed!");
             [SVProgressHUD showErrorWithStatus:@"上传失败!" duration:1];
         }
         
     }];

}
#pragma mark ----------封装请求数据----------
+(NSURLRequest *)createDevDivPostRequest:(NSData *)data userId:(NSString *)userId
{
    //  Create the URL POST Request to DevDiv
    
    NSURL *url = [NSURL URLWithString:API_BASE_URL(@"uploadUserImage.do")];
    NSMutableURLRequest *urlPost = [NSMutableURLRequest requestWithURL:url];
    [urlPost setHTTPMethod:@"POST"];
    
    //  Add the header
    NSString *stringBoundary = @"-----------------------------devdivpostrequest";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [urlPost addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    NSData *leadingData1 = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";\r\nContent-Type: Content-Type: text/plain; charset=UTF-8;\r\nContent-Transfer-Encoding: 8bit\r\n\r\n%@\r\n",stringBoundary, @"userId",userId] dataUsingEncoding:NSUTF8StringEncoding];
    [postBody appendData:leadingData1];
    //  Write leading
    //  Leading data
    NSData *leadingData = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@.jpeg\";\r\nContent-Type: application/octet-stream\r\n\r\n",stringBoundary, @"HelloDevDiv", @"HelloDevDiv"]dataUsingEncoding:NSUTF8StringEncoding];
    [postBody appendData:leadingData];
    
    
    //  Write file data
    [postBody appendData:[NSData dataWithData:data]];
    
    
    //  Write trailing
    NSData *trailingData = [[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding];
    [postBody appendData:trailingData];
    
    //  Add the body to the post
    [urlPost setHTTPBody:postBody];
    
    return urlPost;
}

//上传图片到服务器
//NSData* data= [NSData dataWithContentsOfFile:voice.localPath];//环信语音
+ (void)sendVoiceToDevDiv:(NSData *)voiceData userId:(NSString *)userId mobilePhone:(NSString *)mobilePhone Sbimei:(NSString *)Sbimei;
{
    
    [SVProgressHUD showWithStatus:@"正在上传语音..." maskType:SVProgressHUDMaskTypeBlack];
    if (!voiceData)
    {
        return;
    }
    
    
    //  Create devdiv photo post request
    NSURLRequest *urlRequest = [self createVoicePostRequest:voiceData userId:userId mobilePhone:mobilePhone Sbimei:Sbimei];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    zciotNetRequest *weakSelf = (zciotNetRequest *)self;
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error){
         zciotNetRequest *strongSelf = weakSelf;
         [SVProgressHUD dismiss];
         if (strongSelf)
         {
             if ([data length] >0 && error == nil){
                 strongSelf.responseData = [[NSString alloc] initWithData:data
                                                                 encoding:NSUTF8StringEncoding];
                 NSLog(@"strongSelf.responseData = %@",strongSelf.responseData);
                 
                 //[strongSelf performSelectorOnMainThread:@selector(updateRemotePic) withObject:nil waitUntilDone:NO];
                 NSData* jsonData = [strongSelf.responseData dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
                 if (resultsDictionary) {
                     NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
                     if ([@"0" isEqualToString:msgCode]) {
                         [SVProgressHUD showSuccessWithStatus:@"上传成功" duration:1.0];
                         NSString *url = [resultsDictionary objectForKey:@"url"];
                         NSLog(@"%@",url);
                         //                         self.appDelegate.userDto.userImage = url;
                         //                         //保存图片到本地
                         //                         self.portraitImage = [UIImage imageWithData:imageData];
                         //
                         //
                         //                         [CommonTools readImageWithUrl:url imgData:imageData];
                         //                         [self performSelectorOnMainThread:@selector(reloadTableRow) withObject:nil waitUntilDone:NO];
                         //                         //[self.tableView reloadData];
                     }
                 }
                 
                 
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"Nothing was downloaded.");
                 [SVProgressHUD showErrorWithStatus:@"上传失败!" duration:1];
             }
             else if (error != nil){
                 NSLog(@"Error happened = %@", error);
                 [SVProgressHUD showErrorWithStatus:@"上传失败!" duration:1];
             }
         }
         else
         {
             NSLog(@"Controller is released before block is executed!");
             [SVProgressHUD showErrorWithStatus:@"上传失败!" duration:1];
         }
         
     }];
    
}
#pragma mark ----------封装请求数据----------
+(NSURLRequest *)createVoicePostRequest:(NSData *)data userId:(NSString *)userId mobilePhone:(NSString *)mobilePhone Sbimei:(NSString *)Sbimei
{
    //  Create the URL POST Request to DevDiv
    //[self readNSUserDefaults];
    NSURL *url2 = [NSURL URLWithString:API_BASE_URL(@"uploadDeviceImage.do")];
    NSMutableURLRequest *urlPost = [NSMutableURLRequest requestWithURL:url2];
    [urlPost setHTTPMethod:@"POST"];
    
    //  Add the header
    NSString *stringBoundary = @"-----------------------------devdivpostrequest";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    [urlPost addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    NSData *leadingData1 = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";\r\nContent-Type: Content-Type: text/plain; charset=UTF-8;\r\nContent-Transfer-Encoding: 8bit\r\n\r\n%@\r\n",stringBoundary, @"userId", userId] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *leadingData2 = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";\r\nContent-Type: Content-Type: text/plain; charset=UTF-8;\r\nContent-Transfer-Encoding: 8bit\r\n\r\n%@\r\n",stringBoundary, @"userPhone", mobilePhone] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *leadingData3 = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";\r\nContent-Type: Content-Type: text/plain; charset=UTF-8;\r\nContent-Transfer-Encoding: 8bit\r\n\r\n%@\r\n",stringBoundary, @"imei",Sbimei] dataUsingEncoding:NSUTF8StringEncoding];
    
    [postBody appendData:leadingData1];
    [postBody appendData:leadingData2];
    [postBody appendData:leadingData3];
    
    //  Write leading
    //  Leading data
    NSData *leadingData = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@.amr\";\r\nContent-Type: application/octet-stream\r\n\r\n",stringBoundary, @"HelloDevDiv", @"HelloDevDiv"]dataUsingEncoding:NSUTF8StringEncoding];
    [postBody appendData:leadingData];
    
    
    //  Write file data
    [postBody appendData:[NSData dataWithData:data]];
    
    
    //  Write trailing
    NSData *trailingData = [[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding];
    [postBody appendData:trailingData];
    
    //  Add the body to the post
    [urlPost setHTTPBody:postBody];
    
    return urlPost;
}
@end
