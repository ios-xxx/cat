//
//  CSYPopTableView.h
//  cat
//
//  Created by hongchen on 2018/2/23.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/** 返回选中行的数据 */
typedef void(^PopCloseComplete)(NSArray * data);

@interface CSYPopTableView : NSTableView<NSTableViewDataSource,NSTableViewDelegate>
/** 表数据 */
@property (strong,nonatomic) NSArray * dataArr;

/** 执行返回块 */
@property (nonatomic,copy) PopCloseComplete closeBlock;
@end
