//
//  CSYPopViewController.m
//  cat
//
//  Created by hongchen on 2018/2/18.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYPopViewController.h"


@interface CSYPopViewController ()


@end

@implementation CSYPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    _table.delegate = self;
    _table.dataSource = self;
    
    NSTableColumn * column = [_table tableColumns].firstObject;
    column.title = @"车站";
    [column.headerCell setAlignment:NSTextAlignmentCenter];
    
}



-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [_dataArr count];
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    return 30;
}

//加载数据的时候每个单元格数据都从此获取
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    return nil;
}


-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
        NSButtonCell * textCell = [tableColumn dataCell];
        NSString * titleStr = [_dataArr[row] objectAtIndex:1];
        [textCell setTitle:titleStr];
    
}


-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    
    PopCloseComplete closeBlock = _closeBlock;
    closeBlock(_dataArr[row],_popTag);
    
    return true;
}


@end

