//
//  AppDelegate.m
//  cat
//
//  Created by hongchen on 2018/2/9.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _mainWindow = [[CSYMainWindowController alloc]initWithWindowNibName:@"CSYMainWindowController"];
    
    
    /** 居中显示 */
    [_mainWindow.window center];
    [_mainWindow.window cascadeTopLeftFromPoint:NSMakePoint(0, 0)];
  
    /** 显示到窗口 */
    [_mainWindow.window orderFront:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}



@end
