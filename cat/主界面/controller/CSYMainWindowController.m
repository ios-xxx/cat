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
#import "CSYAddUserTable.h"
#import "CSYContactsTable.h"


@interface CSYMainWindowController ()
{
    CSYQueryViewController * query;
}

@property (weak) IBOutlet NSView *bgView;
/** 用户表格 */
@property (weak) IBOutlet CSYAddUserTable *userTable;
 /** 联系人表格 */
@property (weak) IBOutlet CSYContactsTable *contactsTable;

@end

@implementation CSYMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie * cookie in cookies) {
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
//    初始化用户表格数据
    [self initWithUserTableData];
//    初始化联系人表格数据
    [self initWithContactsData];
    
}


/** 响应创建任务 */
- (IBAction)createTask:(id)sender {
    
    
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
        make.size.equalTo(CGSizeMake(313, 350));
    }];
    
  
    
//    刷新 数据
    loginView.refashBlock = ^{
        
        
        NSDictionary * tableDict = [self getLocalData];
        
        _userTable.dataArr = tableDict[@"user"];
        [_userTable reloadData];
        
    };
    
}

/** 初始化用户表格数据 */
-(void)initWithUserTableData {
    
    
    NSDictionary * tableDict = [self getLocalData];
    
    _userTable.dataArr = tableDict[@"user"];
    [_userTable reloadData];
}

/** 初始化联系人表格数据 */
-(void)initWithContactsData {
    
    NSDictionary * tableDict = [self getLocalData];
    _contactsTable.dataArr =tableDict[@"contacts"];
    
    [_contactsTable reloadData];
    
}

/** 获取持久化数据 */
-(NSDictionary *)getLocalData {
    
    NSArray * pathArr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true);
    return  [[NSDictionary alloc]initWithContentsOfFile:[pathArr[0] stringByAppendingPathComponent:@"/cat/user.plist"]];
    
}
@end
