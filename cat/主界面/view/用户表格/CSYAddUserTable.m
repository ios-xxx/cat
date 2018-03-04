//
//  CSYAddUserTable.m
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYAddUserTable.h"

@interface CSYAddUserTable()<NSTableViewDelegate,NSTableViewDataSource>

@end



@implementation CSYAddUserTable

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib {
    
    NSArray * columnTitleArr = @[@"账户",@"密码",@"状态",@"联系人"];
    NSInteger i = 0;

    for (NSTableColumn * column in _tableColumns) {
        
        [column setTitle:columnTitleArr[i++]];
        [column.headerCell setAlignment:NSTextAlignmentCenter];
        
    }
}



#pragma mark table delegate

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [_dataArrs count];
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
}




#pragma mark - 初始化全局属性
-(NSMutableArray *)dataArrs {
    
    if (_dataArrs) return _dataArrs;
    return _dataArrs = [NSMutableArray new];
}

@end
