//
//  CSYMainViewController.m
//  cat
//
//  Created by hongchen on 2018/2/9.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYMainViewController.h"

@interface CSYMainViewController ()<NSTableViewDelegate,NSTableViewDataSource>

@property (weak) IBOutlet NSView *bgView;
/** 数据 */
@property (strong,nonatomic) NSMutableArray * dataArr;
@end

@implementation CSYMainViewController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // create a table view and a scroll view
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, 380, 200)];
    tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, 364, 200)];
    // create columns for our table
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"part name"];
    //    NSTableColumn * column2 = [[NSTableColumn alloc] initWithIdentifier:@"part index"];
    //    NSTableColumn * column3 = [[NSTableColumn alloc] initWithIdentifier:@"part size"];
    
    [column1.headerCell setStringValue:@"name"];
    [column1 setWidth:80];
    //    [column2 setWidth:80];
    //    [column3 setWidth:80];
    // generally you want to add at least one column to the table view.
    [tableView addTableColumn:column1];
    //    [tableView addTableColumn:column2];
    //    [tableView addTableColumn:column3];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView reloadData];
    // embed the table view in the scroll view, and add the scroll view to our window.
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller:YES];
    [_bgView addSubview:tableContainer];
    NSLog(@"add done");
    
    
    NSUInteger      index = 0;
    
    partInfos = [NSMutableArray new];
    
    
    for (index = 0; index < 4; ++index)
    {
        [partInfos addObject:@(index)];
        
    }
    
    
    
    [tableView reloadData];
   
}


//控件以此判断要显示多少行
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [partInfos count];
}

//加载数据的时候每个单元格数据都从此获取
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}


- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    NSString *identifier = [tableColumn identifier];
    
    
    if ([identifier isEqualToString:@"part name"])
    {
        NSTextFieldCell *textCell = cell;
        [textCell setTitle:partInfos[row]];
    }
    
}





- (IBAction)query:(id)sender {
    
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=2018-02-15&leftTicketDTO.from_station=BJP&leftTicketDTO.to_station=SHH&purpose_codes=0X00"]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        dict = dict[@"data"];
        
        int i = 0;
        
        for (NSString * str in dict[@"result"]) {
            i++;
            
            if(i > 1) return ;
            
            NSArray * objArr = [str componentsSeparatedByString:@"|"];
            for (NSString * obj in objArr) {
                
                NSLog(@"res= %@",obj);
            }
            
            
        }
        
        
    }];
    
    [dataTask resume];
}



#pragma mark - 初始化全局属性

-(NSMutableArray *)dataArr {
    
    if (_dataArr)return _dataArr;
    return  _dataArr = [NSMutableArray new];
}
@end
