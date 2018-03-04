//
//  CSYMainWindowController.m
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYMainWindowController.h"
#import "CSYQueryViewController.h"
#import "CSYPopViewController.h"

#import "CSYLoginView.h"
#import "CSYMsg.h"

@interface CSYMainWindowController ()
{
    CSYQueryViewController * query;
}

@property (weak) IBOutlet NSView *bgView;

@end

@implementation CSYMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in cookies) {
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    [CSYMsg msgInView:_bgView];
    
 
    
}


/** 响应创建任务 */
- (IBAction)createTask:(id)sender {
    
    [CSYMsg hideMsgView];
    
    query = [[CSYQueryViewController alloc]initWithWindowNibName:@"CSYQueryViewController"];
    [query.window center];
    [query.window orderFront:nil];
//    [self.window orderOut:nil];
    [query becomeFirstResponder];

}


/** 响应添加账户 */
- (IBAction)lgoinUserClick:(id)sender {
    
    CSYLoginView *loginView = [CSYLoginView new];
    loginView.wantsLayer = YES;
    [loginView.layer setCornerRadius:2.5];
    [loginView.layer setBorderWidth:1];
    [loginView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
    [loginView.layer setBorderColor:[NSColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor];
    [_bgView addSubview:loginView];
    
    [loginView makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_bgView);
        make.size.equalTo(CGSizeMake(293, 235));
    }];  
    
}
@end
