//
//  CSYAddUserTable.m
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYAddUserTable.h"
#import "CSYContactModel.h"

@interface CSYAddUserTable()

@end



@implementation CSYAddUserTable



- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
//    self.delegate = self;
//    self.dataSource = self;
    
    // Drawing code here.
}


-(void)awakeFromNib {
    
    self.delegate = self;
    self.dataSource = self;
    
    NSArray * columnTitleArr = @[@"账户",@"密码",@"状态",@"联系人"];
    NSInteger i = 0;

    for (NSTableColumn * column in _tableColumns) {
        
        [column.headerCell setTitle:columnTitleArr[i++]];
        [column.headerCell setAlignment:NSTextAlignmentCenter];
        
    }
    
}





#pragma mark table delegate


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {

    return [_dataArr count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

  
        return nil;
}
-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTextFieldCell * textCell = cell;
    [textCell setAlignment:NSTextAlignmentCenter];
    CSYContactModel * model = [CSYContactModel mj_objectWithKeyValues:_dataArr[row]];
    
    if ([[tableColumn identifier] isEqualToString:@"user"]) {
        
        textCell.stringValue = model.user;
        
    }else if ([[tableColumn identifier] isEqualToString:@"pass"]) {

        textCell.stringValue = model.pass;
    }else if ([[tableColumn identifier] isEqualToString:@"userStae"]) {
        
        textCell.stringValue = model.userState;
    }else if  ([[tableColumn identifier] isEqualToString:@"count"]) {

        textCell.stringValue = model.count;
    }
}


-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {

    /** 选中账户回调 */
    _selectUserBlock(row);
    
    return true;
}
@end
