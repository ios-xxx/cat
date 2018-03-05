//
//  CSYLoginView.h
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void(^RefashComplete)();
@interface CSYLoginView : NSView
@property(copy,nonatomic)RefashComplete refashBlock;
@end
