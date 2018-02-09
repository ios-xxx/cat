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
    
    [self.window setContentSize:CGSizeMake(800, 600)];


   // NSRect wndFrame = [self.window frameRectForContentRect：viewScreenFrame];
   // [_window setFrame：wndFrame display：YES animate：YES];
    
    
    // create a table view and a scroll view
    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, self.bgView.frame.size.width - 20, 200)];
    tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, 364, 200)];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView reloadData];
    // embed the table view in the scroll view, and add the scroll view to our window.
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller:true];
    [tableContainer setHasHorizontalScroller:true];
    [_bgView addSubview:tableContainer];
    NSLog(@"add done");
    
   
}


//控件以此判断要显示多少行
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [_dataArr count];
}

//加载数据的时候每个单元格数据都从此获取
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}


- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    NSString *identifier = [tableColumn identifier];
    
    
    NSTextFieldCell *textCell = cell;
    NSArray * rowArr = _dataArr[row];
    
    NSString *  rowStr = [identifier substringFromIndex:identifier.length-1];
    NSString *  rowStr1 = [identifier substringFromIndex:identifier.length-2];

    NSInteger count = [rowStr1 integerValue] > 0 ? [rowStr1 integerValue] : [rowStr integerValue];
    
//    NSLog(@"--%ld",count);
    [textCell setTitle:rowArr[count]];
    
    
    
}





- (IBAction)query:(id)sender {
    
//    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=2018-02-15&leftTicketDTO.from_station=BJP&leftTicketDTO.to_station=SHH&purpose_codes=0X00"]];
//
//    NSURLSession * session = [NSURLSession sharedSession];
//
//    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//
//
//
//    }];
//
//    [dataTask resume];
    
    [self tableReload];
}

-(void)tableReload {
    
    NSString * patch = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSString * str = [[NSString alloc]initWithContentsOfFile:patch encoding:NSUTF8StringEncoding error:nil];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    dict = dict[@"data"];
    
    int i = 0;
    
    for (NSString * str in dict[@"result"]) {
      
        i++;
        
        NSArray * objArr = [str componentsSeparatedByString:@"|"];
        
         [self.dataArr addObject:objArr];
        
        if(i > 1) continue ;
        for (int co=0; co < objArr.count; co++) {
            
            NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"part name %d",co]];
            [column1.headerCell setStringValue:@"name"];
            [column1.headerCell setTitle:[NSString stringWithFormat:@"part name %d",co]];
            [tableView addTableColumn:column1];
            [column1 setWidth:80];
            
        }
        
       
    }
    
    
    [tableView reloadData];
}

#pragma mark - 初始化全局属性

-(NSMutableArray *)dataArr {
    
    if (_dataArr)return _dataArr;
    return  _dataArr = [NSMutableArray new];
}
@end
