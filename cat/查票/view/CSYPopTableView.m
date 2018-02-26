//
//  CSYPopTableView.m
//  cat
//
//  Created by hongchen on 2018/2/23.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYPopTableView.h"

@implementation CSYPopTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib {
    
    
    self.delegate = self;
    self.dataSource = self;
    
    NSTableColumn * column = [self tableColumns].firstObject;
    column.title = @"车站";
    [column.headerCell setAlignment:NSTextAlignmentCenter];
    
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
//    NSButtonCell * textCell = [tableColumn dataCell];
//    [textCell setState:1];
//    [textCell setAction:@selector(cellClick:)];
//    [textCell setTarget:self];
//    [textCell setTag:row];
    
    return nil;
}


-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
     NSButtonCell * textCell = [tableColumn dataCell];
    NSString * titleStr = [_dataArr[row] objectAtIndex:1];
    [textCell setBackgroundColor:[NSColor whiteColor]];
    [textCell setTitle:titleStr];
    
}


- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    
     PopCloseComplete closeBlock = _closeBlock;
    closeBlock(_dataArr[rowIndex],_popTag);
    NSLog(@"%ld",rowIndex);
}

-(BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
    
    return true;
}
@end
