//
//  AppDelegate.h
//  cat
//
//  Created by hongchen on 2018/2/9.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSYMainWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

/** 主窗口 */
@property (strong,nonatomic) CSYMainWindowController * mainWindow;
@end

