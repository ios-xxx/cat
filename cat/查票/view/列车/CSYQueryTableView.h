//
//  CSYQueryTableView.h
//  cat
//
//  Created by hongchen on 2018/2/24.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/** 选中列车返回KEY */
typedef void(^SelectTraniComplete)(NSString * secretStr) ;

@interface CSYQueryTableView : NSTableView<NSTableViewDelegate,NSTableViewDataSource>
/** 数据 */
@property (strong,nonatomic) NSMutableArray * dataArr;
/** 选中数据 */
@property (strong,nonatomic) NSMutableArray * selectDataArr;
/** 选中列车返回KEY */
@property(nonatomic,copy) SelectTraniComplete selectTraniBlock;
@end
