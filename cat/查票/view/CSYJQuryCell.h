//
//  CSYJQuryCell.h
//  cat
//
//  Created by hongchen on 2018/2/17.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CSYJQuryCell;

/** 修改 Cell 属性 */
typedef void(^ChangeCell)(CSYJQuryCell * cell,NSRect rect);

@interface CSYJQuryCell : NSCell

@property(nonatomic,copy) ChangeCell cellBlock;

@end
