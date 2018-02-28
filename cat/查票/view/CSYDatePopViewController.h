//
//  CSYDatePopViewController.h
//  cat
//
//  Created by hongchen on 2018/2/27.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/// 返回指定选中的日期
typedef void(^SelectDateComplete) (NSString * dateStr);

@interface CSYDatePopViewController : NSViewController<NSTableViewDelegate,NSTableViewDataSource>

/** 表格数据 */
@property (strong,nonatomic) NSArray * dataArr;
/** 选中数据 */
@property (strong,nonatomic) NSMutableArray * selectDateArr;
/** 日期表格 */
@property (weak) IBOutlet NSTableView *table;

@property(copy,nonatomic) SelectDateComplete selectDateBlcok;

@end
