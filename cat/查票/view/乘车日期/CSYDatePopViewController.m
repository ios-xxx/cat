//
//  CSYDatePopViewController.m
//  cat
//
//  Created by hongchen on 2018/2/27.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYDatePopViewController.h"

@interface CSYDatePopViewController ()
/** 保存选中行 */
@property (strong,nonatomic) NSMutableArray * selectRowArrs;
@end

@implementation CSYDatePopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _table.delegate = self;
    _table.dataSource = self;
    
    NSTableColumn * column = [_table tableColumns].firstObject;
    [column.headerCell setTitle:@"乘车日期"];
    [column.headerCell setAlignment:NSTextAlignmentCenter];
    
}


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [_dataArr count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSButtonCell * cell = [tableColumn dataCell];
    [cell setTitle:_dataArr[row]];
    [cell setState:[_selectDateArr[row] intValue]];
    

    return cell;
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
   
    
    if ([_selectDateArr[row] intValue]) {
        DLog(@" -- row = %ld dataArr = %@",row,_selectDateArr[row]);
        [_selectDateArr replaceObjectAtIndex:row withObject:@(0)];
    }else {
        DLog(@" --0 row = %ld dataArr = %@ count =%ld",row,_selectDateArr[row],_selectDateArr.count);
         [_selectDateArr replaceObjectAtIndex:row withObject:@(1)];
        
//        返回选中的日期
        _selectDateBlcok(_dataArr[row]);
    }
    
    
    
    
}


#pragma mark - 初始化全局属性
-(NSMutableArray *)selectRowArrs {
    
    if (_selectRowArrs) return _selectRowArrs;
    
    return  _selectRowArrs = [NSMutableArray new];
}
@end
