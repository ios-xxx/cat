//
//  CSYQueryTableView.m
//  cat
//
//  Created by hongchen on 2018/2/24.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYQueryTableView.h"
#import "CSYJQuryCell.h"

@implementation CSYQueryTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib {
    
    self.delegate = self;
    self.dataSource = self;
    
    NSArray * titleArr = @[@"选择车次",@"车次",@"出发/到达时间",@"历时",@"商务座",@"一等座",@"二等座",@"高级软卧",@"软卧",@"动卧",@"硬卧",@"软座",@"硬座",@"无座",@"其它"];
    NSArray * columsArr = [self tableColumns];
    
    for (int i = 0; i < columsArr.count; i++) {
        
        NSTableColumn * column = columsArr[i];
        [column.headerCell setTitle:titleArr[i]];
        [column.headerCell setAlignment:NSTextAlignmentCenter];
        [column setIdentifier:[NSString stringWithFormat:@"name%d",i]];
        [column setWidth:80];
        
    }
    
    [self setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
    
    
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [_dataArr count];
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    return 40;
}

//加载数据的时候每个单元格数据都从此获取
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    NSTextFieldCell * textCell = [tableColumn dataCellForRow:row];
    [textCell setDrawsBackground:true];
    
    if (row%2 == 0) {
        
        [textCell setBackgroundColor:[NSColor redColor]];
        
    }else {
        
        [textCell setBackgroundColor:[NSColor orangeColor]];
    }
   
    
    if (![[tableColumn identifier] isEqualToString:@"name0"]) return textCell;
    
    
    NSButtonCell * btnCell = [tableColumn dataCellForRow:row];
    [btnCell setState:[_selectDataArr[row] intValue]];
    return btnCell;
}


-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
   
    NSArray * rowArr = _dataArr[row];
    NSString * identifier = [tableColumn identifier];
    
        // 指定 cell 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name1" row:row title:rowArr[3]]) return ;
        // 指定 cell 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name2" row:row title:[NSString stringWithFormat:@"%@-%@",rowArr[8],rowArr[9]]]) return ;
        // 指定 cell 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name3" row:row title:rowArr[10]]) return ;
    
        // 指定 商务特登座 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name4" row:row title:rowArr[32]]) return ;
        // 指定 一等座 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name5" row:row title:rowArr[31]]) return ;
        // 指定 二等座 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name6" row:row title:rowArr[30]]) return ;
        // 指定 高级软卧 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name7" row:row title:rowArr[21]]) return ;
        // 指定 软卧 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name8" row:row title:rowArr[23]]) return ;
        // 指定 动卧 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name9" row:row title:rowArr[33]]) return ;
        // 指定 硬卧 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name10" row:row title:rowArr[28]]) return ;
        // 指定 软座 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name11" row:row title:rowArr[24]]) return ;
        // 指定 硬座 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name12" row:row title:rowArr[29]]) return ;
        // 指定 无座 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name13" row:row title:rowArr[26]]) return ;
        // 指定 其它 的内容
        if ([self cellContextIdentifier:identifier cell:cell  queryIdentifier:@"name14" row:row title:@"--"]) return ;
    
    
}

///**
// 在 cell 中显示要指定的内容
//
// @param identifier 当前 column 的 ID
// @param queryID 查询 column 的 ID
// @param row 要查询的行
// @param title 要查询 cell 的标题
// */
-(BOOL)cellContextIdentifier:(NSString *)identifier cell:(NSCell *)cell queryIdentifier:(NSString *)queryID row:(NSInteger )row title:(NSString *)title{

    if ([identifier isEqualToString:queryID]) {

        if ([title isEqualToString:@""]) title = @"--";
        [cell setStringValue:title];

        return true;
    }
    return false;
}


-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
   
    if ([_selectDataArr[row] intValue] == 0) {
        
        [_selectDataArr replaceObjectAtIndex:row withObject:@(1)];
        
    }else {
        
         [_selectDataArr replaceObjectAtIndex:row withObject:@(0)];
    }
}

-(BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    return false;
}

@end
