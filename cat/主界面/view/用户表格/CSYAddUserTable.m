//
//  CSYAddUserTable.m
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYAddUserTable.h"
#import "CSYContactModel.h"

@interface CSYAddUserTable()<NSTableViewDelegate,NSTableViewDataSource>

@end



@implementation CSYAddUserTable



- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    self.delegate = self;
    self.dataSource = self;
    
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
    
   
    return [_dataArr count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    CSYContactModel * contact = [CSYContactModel mj_objectWithKeyValues:_dataArr[row]];
    
    DLog(@"name = %@",contact.user);
    return nil;
}
-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    
    DLog(@" log...");
    [CSYAutoProperty DictionaryCreaterPropertyCode:_dataArr[row]];
}

@end
