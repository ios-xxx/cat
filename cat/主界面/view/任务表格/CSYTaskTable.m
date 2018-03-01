//
//  CSYTaskTable.m
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYTaskTable.h"

@implementation CSYTaskTable

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib {
    
    NSArray * columnTitleArr = @[@"任务 ID",@"乘车-到达",@"日期",@"乘车人",@"席别",@"车次",@"任务状态"];
    NSInteger i = 0;
    
    for (NSTableColumn * column in _tableColumns) {
        
        [column setTitle:columnTitleArr[i++]];
        [column.headerCell setAlignment:NSTextAlignmentCenter];
        
        DLog(@"--%@ -- %@",column.title,column.headerCell.title);
    }
}

@end
