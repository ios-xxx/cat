//
//  CSYQueryTableView.h
//  cat
//
//  Created by hongchen on 2018/2/24.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CSYQueryTableView : NSTableView<NSTableViewDelegate,NSTableViewDataSource>
/** 数据 */
@property (strong,nonatomic) NSMutableArray * dataArr;
/** 选中数据 */
@property (strong,nonatomic) NSMutableArray * selectDataArr;
@end
