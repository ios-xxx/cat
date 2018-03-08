//
//  CSYLoginView.m
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYLoginView.h"
#import "CSYContactModel.h"
#import "NSTextFieldCellCenter.h"
#import "CSYNSSecureTextFieldCell.h"

@interface CSYLoginView()
{
    /** 验证码图片 */
    NSImageView * codeImage;
    /** 判断是否进入监控区域 */
    BOOL isEntered;
    
    /** 张号栏 */
    NSTextField * usText;
    /** 密码栏 */
    NSSecureTextField * psText;
}

/** 保存用户选中图片的坐标 */
@property (strong,nonatomic) NSMutableString * saveSelectPointStrs;

@end

@implementation CSYLoginView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    
    if ([super initWithFrame:frameRect]) {
        
        /** 初始化 UI */
        [self initWithUI];
    }
    return self;
}


/** 初始化 UI */
-(void)initWithUI {
    
    NSArray * titleUserArr = @[@"用户名 :",@"密 码 :"];
    NSArray * placeholderArr = @[@"输入12306账号",@"输入12306密码"];
    NSInteger usCount =titleUserArr.count;
    
    NSTextField * usLab;
    
    for (int i = 0; i < usCount; i ++) {
        
        usLab = [NSTextField new];
        [usLab setCell:[NSTextFieldCellCenter new]];
        [usLab setEnabled:false];
        [usLab setEditable:false];
        [usLab setStringValue:titleUserArr[i]];
        [self addSubview:usLab];
        
        [usLab makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.offset(10);
            make.top.offset(20+i*20+i*30);
            
            make.width.offset(60);
            make.height.offset(30);
        }];
        
    
        
        if (!i){
           
            usText = [NSTextField new];
            [usText setCell:[NSTextFieldCellCenter new]];
            [usText.cell setStringValue:@""];
            [usText setEditable:true];
            [usText setEnabled:true];
            
            usText.placeholderString = placeholderArr[i];
            [self addSubview:usText];
            
            [usText makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(usLab.right);
                make.right.equalTo(self.right).offset(-10);
                make.height.offset(30);
                make.top.offset(20+i*20+i*30);
            }];
            
            continue;
        }
        
        psText = [NSSecureTextField new];
        [psText setCell:[CSYNSSecureTextFieldCell new]];
        [psText setPlaceholderString:placeholderArr[i]];
        [psText.cell setStringValue:@""];
        [psText setEditable:true];
        [psText setEnabled:true];
        [self addSubview:psText];
        
        [psText makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(usLab.right);
            make.right.equalTo(self.right).offset(-10);
            make.height.offset(30);
            make.top.offset(20+i*20+i*30);
        }];

        
    }
    
    
    codeImage = [NSImageView new];
    codeImage.wantsLayer = true;
    [codeImage.layer setBorderColor:[NSColor colorWithHexString:@"3e3e3e"].CGColor];
    [codeImage.layer setBorderWidth:0.5];
    
    NSURL * imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://kyfw.12306.cn/passport/captcha/captcha-image?login_site=E&module=login&rand=sjrand&0.%d",arc4random()%10000+10000000]];
    
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:imageUrl options:SDWebImageHandleCookies progress:nil completed:^(NSImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
       
        if (finished) {
            
            [codeImage setImage:image];
        }
        
        NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        
        DLog(@"%@",cookies);
    }];
    
    [self addSubview:codeImage];
    
    [codeImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(usLab.bottom).offset(20);
        make.left.offset(10);
        make.size.equalTo(CGSizeMake(293, 190));
    }];
    
    
    NSArray * titleBtnArr = @[@"换一张",@"取消",@"登陆"];
    NSInteger count = titleBtnArr.count;
    for (int i = 0; i < count; i++) {
        
        NSButton * refreashBtn = [NSButton new];
        [refreashBtn setBezelStyle:NSBezelStyleTexturedSquare];
        [refreashBtn setTitle:titleBtnArr[i]];
        [refreashBtn setTarget:self];
        [refreashBtn setAction:@selector(codeBtnTap:)];
        [refreashBtn setTag:i];
        [self addSubview:refreashBtn];
        
        [refreashBtn makeConstraints:^(MASConstraintMaker *make) {
           
            if (i == 0) {
                make.top.equalTo(codeImage).offset(5);
                make.right.equalTo(codeImage).offset(-5);
                make.width.equalTo(self.width).multipliedBy(0.2);
            }else {
                
                if(i == 1){
                    make.centerX.equalTo(self).multipliedBy(0.5);
                }else {
                    make.centerX.equalTo(self).multipliedBy(1.5);
                }
                make.bottom.offset(-10);
                make.top.equalTo(codeImage.bottom).offset(10);
                make.width.equalTo(self.width).multipliedBy(0.25);
            }
            
        }];
    }
    
    //    添加监视钩端螺旋体病
        NSTrackingArea * trackingArea = [[NSTrackingArea alloc]initWithRect:codeImage.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved |
                                         NSTrackingCursorUpdate |
                                         NSTrackingActiveWhenFirstResponder |
                                         NSTrackingActiveInKeyWindow |
                                         NSTrackingActiveInActiveApp |
                                         NSTrackingActiveAlways |
                                         NSTrackingAssumeInside |
                                         NSTrackingInVisibleRect |
                                         NSTrackingEnabledDuringMouseDrag
                                                                      owner:self
                                                                   userInfo:nil];
    
    
        [codeImage addTrackingArea:trackingArea ];
    
}


-(void)codeBtnTap:(NSButton *)sender {
    
  
    if (sender.tag == 0) {
        
        /** 删除验证码上面的 View */
        [self deleteSubView];
        
    }else if (sender.tag == 1){
        
        [self removeFromSuperview];
        
    } else  {
        
        
        if (_saveSelectPointStrs.length < 1) return;
        [_saveSelectPointStrs deleteCharactersInRange:NSMakeRange(0, 1)];

        NSDictionary * paramterDict = @{
                                        @"answer":_saveSelectPointStrs,
                                        @"login_site":@"E",
                                        @"rand":@"sjrand",
                                        };


//        DLog(@"%@",paramterDict);
        
        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"]];
        NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie * cookie in cookies){
            [cookieStorage setCookie: cookie];
        }
        
        
        
        [CSYRequest requestPostUrl:url(@"passport/captcha/captcha-check") paramters:paramterDict cookie:^(AFHTTPSessionManager *manger) {

//            [manger.requestSerializer setValue:@"_passport_session=90d4e94a714b4e6f913ca7d570f80a1e6865; _passport_ct=6b2f648333bd4ad7a2438fdb0f91a686t8415; BIGipServerpassport=837288202.50215.0000" forHTTPHeaderField:@"Cookie"];
            
        } success:^(NSURLSessionDataTask * _Nonnull task,NSData *data) {

            NSDictionary * resaultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if ([CSYIsNull isNull:resaultDict] || ![resaultDict[@"result_code"] isEqualToString:@"4"]) {
                // 删除验证码上的 View,并重新获取验证码
                [self deleteSubView];
                return ;
            }
            
            /** 调用登陆方法 */
            [self loginUser];
//
//            NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
//            DLog(@"str = %@",str);
        } error:^(NSError *err) {

            DLog(@"err=%@",err);
        }];
        DLog(@"--- %@",_saveSelectPointStrs);
//                [self removeFromSuperview];
    }
}


// 鼠标进入监视区
- (void)mouseEntered:(NSEvent *)theEvent{
    
    isEntered = true;

}
// 鼠标在监视区内移动
- (void)mouseMoved:(NSEvent *)theEvent{


//    DLog(@" log...2");
}
// 鼠标推出监视区
- (void)mouseExited:(NSEvent *)theEvent{

    isEntered = false;
}

// 按下鼠标左键
- (void)mouseDown:(NSEvent *)event {
    
    if (!isEntered) return;
    
    NSPoint point = [event locationInWindow];
    
    float x = point.x - CGRectGetMinX(self.frame) -10;
    float y =CGRectGetMaxY(self.frame) -  point.y-120;

//    DLog(@"%@ --- %@",NSStringFromPoint(CGPointMake(x, y)),NSStringFromPoint(point));
    
//    创建一个实心圆
    [self loadCircualPiont:NSMakePoint(x, y)];
    [self.saveSelectPointStrs appendString:[NSString  stringWithFormat:@",%.f,%.f",x,y]];
//    self.saveSelectPointStrs = [NSMutableString  stringWithFormat:@",%f,%f",x,y]];
    
}
// 松开鼠标左键
- (void)mouseUp:(NSEvent *)theEvent{


    DLog(@" log...5");
}
// 按下鼠标右键
- (void)rightMouseDown:(NSEvent *)theEvent{


    DLog(@" log...6");
}
// 松开鼠标右键
- (void)rightMouseUp:(NSEvent *)theEvent{


    DLog(@" log...7");
}

/** 响应鼠标左键单击（创建一个实心圆） */
-(void)loadCircualPiont:(NSPoint )point {
    
    NSView * circual = [NSView new];
    circual.wantsLayer = YES;
    [circual.layer setBackgroundColor:[NSColor redColor].CGColor];
    [circual.layer setCornerRadius:7.5];
    [circual.layer setMasksToBounds:true];
    [codeImage addSubview:circual];
    
    [circual makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(point.x-7.5);
        make.top.offset(point.y-7.5);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
}

/** 删除验证图片上面的 view */
-(void)deleteSubView {
    
    while (codeImage.subviews.count > 1) {
        
        for (int i = 0; i < codeImage.subviews.count; i++) {
            
            if ([NSStringFromClass([codeImage.subviews[i] class]) isEqualToString:@"NSView"] )[codeImage.subviews[i] removeFromSuperview];
            
        }
    }
    
    [_saveSelectPointStrs deleteCharactersInRange:NSMakeRange(0, _saveSelectPointStrs.length)];
    
//    刷新验证码
    NSURL * imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://kyfw.12306.cn/passport/captcha/captcha-image?login_site=E&module=login&rand=sjrand&0.%d",arc4random()%10000+10000000]];
    
    SDWebImageManager * manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:imageUrl options:SDWebImageHandleCookies progress:nil completed:^(NSImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
        if (finished) {
            
            [codeImage setImage:image];
        }
        
//        NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//
//        DLog(@"%@",cookies);
    }];
  
}


/** 登陆方法 */
-(void)loginUser {
    
    NSString * user = usText.stringValue;
    NSString * pass = psText.stringValue;
    NSDictionary * paramterDict = @{
                                    @"username":user,
                                    @"password":pass,
                                    @"appid":@"otn",
                                    };
    
    [CSYRequest requestPostUrl:url(@"passport/web/login") paramters:paramterDict cookie:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData *data) {

        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

        DLog(@"%@",str);

        [CSYRequest requestPostUrl:url(@"passport/web/auth/uamtk") paramters:@{@"appid":@"otn"} cookie:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData *data) {
            
            NSDictionary * resaultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if ([CSYIsNull isNull:resaultDict] || [resaultDict[@"newapptk"] isEqualToString:@""]) {
                // 删除验证码上的 View,并重新获取验证码
                [self deleteSubView];
                return ;
            }
            //
            //            NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //
            //            DLog(@"data = \n%@",str);
            
            [CSYRequest requestPostUrl:url(@"otn/uamauthclient") paramters:@{@"tk":resaultDict[@"newapptk"]} cookie:^(AFHTTPSessionManager *manger) {
                
            }  success:^(NSURLSessionDataTask * _Nonnull task, NSData *data) {
                
                //                NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                //
                //                DLog(@"%@",str);
                
                [CSYRequest requestPostUrl:url(@"otn/index/initMy12306") paramters:@{@"appid":@"otn"} cookie:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData *data) {

                                        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    
                                        DLog(@"data = \n%@",str);
                    
                    [CSYRequest requestPostUrl:url(@"otn/confirmPassenger/getPassengerDTOs") paramters:@{@"tk":@""} cookie:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData *data) {
                        
                        NSDictionary * resaultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                        
                        resaultDict = resaultDict[@"data"];
                        DLog(@"%@",resaultDict[@"exMsg"]);
                        if ([CSYIsNull isNull:resaultDict] || ![resaultDict[@"exMsg"] isEqualToString:@""]) {
                            // 删除验证码上的 View,并重新获取验证码
                            [self deleteSubView];
                            
                            DLog(@"获取联系人失败");
                            return ;
                        }
                        
                        //                    持久化处理
                        [self writeUserInfoData:resaultDict user:user pass:pass];
                        
                        
                    } error:^(NSError *err) {
                        
                        
                        DLog(@"%@",err);
                    }];
                    
                } error:^(NSError *err) {


                    DLog(@"%@",err);
                }];
            
            } error:^(NSError *err) {
                
                
                DLog(@"%@",err);
            }];
            
        } error:^(NSError *err) {
            
            DLog(@"%@",err);
        }];

    } error:^(NSError *err) {

        DLog(@"登陆出错了....");
    }];

}


#pragma mark 持久化处理

/** 持久化处理 */
-(void)writeUserInfoData:(NSDictionary *)data user:(NSString *)user pass:(NSString *)pass{
    
    NSArray * contactsArr = data[@"normal_passengers"];

    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray * pathArr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true);
    NSString * path = [pathArr[0] stringByAppendingPathComponent:@"cat"];
    
    if (![self isFileExist:@"user.plist"]) {

        NSError * err;
        BOOL isFile = [fileManger createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:&err];

        if (!isFile) {
            
            DLog(@"创建用户数据失败1%@",err);
            return;
        }
        
        
        isFile = [fileManger createFileAtPath:[path stringByAppendingString:@"/user.plist"] contents:nil attributes:nil];
        if (!isFile) {
            
            DLog(@"创建用户数据失败2");
            return;
        }
    }
    
    NSDictionary * localData = [self getLocalData];
    
    NSDictionary * userDict;
    
    
    
    if ([CSYIsNull isNull:localData]) {

        userDict = @{
                     @"user":[NSArray arrayWithObject:@{
                                                        @"user":user,
                                                        @"pass":pass,
                                                        @"userState":@"登陆成功",
                                                        @"count":@(contactsArr.count),
                                                        }],
                     @"contacts":[NSArray arrayWithObject:contactsArr],
                     
                     };
    }else {

        NSMutableArray * userDataArrs =[NSMutableArray arrayWithArray: localData[@"user"]];

        [userDataArrs addObject:@{
                                  @"user":user,
                                  @"pass":pass,
                                  @"userState":@"登陆成功",
                                  @"count":@(contactsArr.count),
                                  }];

        NSMutableArray * contactDataArrs = [NSMutableArray arrayWithArray:localData[@"contacts"]];
        [contactDataArrs addObject:contactsArr];
        
        userDict = @{
                     @"user":userDataArrs,
                     @"contacts":contactDataArrs,
                     };
    }
    
   
    
    
    
    
    
//    NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:userInfoArr];
    
//    DLog(@"%@",[path stringByAppendingPathComponent:@"/cat/user.plist"]);
//    return;
    BOOL isWrite = [userDict writeToFile:[path stringByAppendingPathComponent:@"/user.plist"] atomically:true];

    if (isWrite) {

        DLog(@"写入成功");
//        刷新块
        _refashBlock();
        [self removeFromSuperview];
        
    } else {

        DLog(@"写入失败");
    }


}

//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"cat/%@",fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    
    return result;
}

/** 获取持久化数据 */
-(NSDictionary *)getLocalData {
    
    NSArray * pathArr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true);
    return  [[NSDictionary alloc]initWithContentsOfFile:[pathArr[0] stringByAppendingPathComponent:@"/cat/user.plist"]];
    
}
    

#pragma mark - 初始化全局属性变量
    
-(NSMutableString *)saveSelectPointStrs {
    
    if (_saveSelectPointStrs != nil)  return _saveSelectPointStrs;
    return _saveSelectPointStrs = [NSMutableString new];
    
}
@end
