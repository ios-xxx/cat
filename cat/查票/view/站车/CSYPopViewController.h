//
//  CSYPopViewController.h
//  cat
//
//  Created by hongchen on 2018/3/7.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/** 返回选中行的数据 */
typedef void(^PopCloseComplete)(NSArray * data,NSString * popTag);

@interface CSYPopViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate>
/** 表数据 */
@property (strong,nonatomic) NSArray * dataArr;
/** 数据标识 */
@property (strong,nonatomic) NSString * popTag;

/** pop 表格 */
@property (weak) IBOutlet NSTableView *table;

/** 执行返回块 */
@property (nonatomic,copy) PopCloseComplete closeBlock;
@end
