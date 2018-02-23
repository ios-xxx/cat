//
//  CSYJQuryCell.h
//  cat
//
//  Created by hongchen on 2018/2/17.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CSYJQuryCell : NSCell
/** 是否要渲染背景色 */
@property (assign,nonatomic) BOOL isBackground;
/** title */
@property (strong,nonatomic) NSString * cellTitle;


@end
