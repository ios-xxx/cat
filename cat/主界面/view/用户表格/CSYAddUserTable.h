//
//  CSYAddUserTable.h
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/** 选择表格中的账户通过回调刷新联系人 */
typedef void(^SelectUserComplete) (NSInteger user);

@interface CSYAddUserTable : NSTableView<NSTableViewDelegate,NSTableViewDataSource>
/** 用户数据 */
@property (strong,nonatomic) NSArray * dataArr;
/** 选中账户返回 */
@property (copy,nonatomic) SelectUserComplete selectUserBlock;

@end
