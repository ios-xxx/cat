//
//  CSYPopViewController.h
//  cat
//
//  Created by hongchen on 2018/2/18.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSYPopTableView.h"


/** 返回选中行的数据 */
typedef void(^PopCloseComplete)(NSArray * data);

@interface CSYPopViewController : NSViewController
/** pop 表格 */
@property (strong,nonatomic) CSYPopTableView * table;

/** 执行返回块 */
@property (nonatomic,copy) PopCloseComplete closeBlock;

@end
