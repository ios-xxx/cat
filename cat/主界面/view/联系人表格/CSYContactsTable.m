//
//  CSYContactsTable.m
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYContactsTable.h"
#import "CSYContactModel.h"


@interface CSYContactsTable()<NSTableViewDataSource,NSTableViewDelegate>

@end

@implementation CSYContactsTable

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)awakeFromNib {
    
    self.delegate = self;
    self.dataSource = self;
    
    NSArray * columnTitleArr = @[@"姓名",@"身份证"];
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
    
    return nil;
}
-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSButtonCell * textCell = cell;
    [textCell setAlignment:NSTextAlignmentCenter];
    CSYContactModel * model = [CSYContactModel mj_objectWithKeyValues:_dataArr[row]];

    if ([[tableColumn identifier] isEqualToString:@"name"]) {

        textCell.title = model.passenger_name;

    }else if ([[tableColumn identifier] isEqualToString:@"numberID"]) {

        textCell.title = model.passenger_id_no;
    }
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    return 30;
}


-(BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    return false;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    
    DLog(@"row = %ld",row);
    return true;
}

@end
