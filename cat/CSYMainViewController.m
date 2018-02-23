//
//  CSYMainViewController.m
//  cat
//
//  Created by hongchen on 2018/2/9.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYMainViewController.h"
#import "NSTextFieldCellCenter.h"
#import "CSYPopViewController.h"


@interface CSYMainViewController ()<NSTableViewDelegate,NSTableViewDataSource,NSTextFieldDelegate>
{
    NSPopover * pop;
}

/** 出发地 */
@property (strong) IBOutlet NSTextField *formAddress;
 /** 目的地 */
@property (weak) IBOutlet NSTextField *toAddress;

@property (weak) IBOutlet NSView *bgView;
/** 数据 */
@property (strong,nonatomic) NSMutableArray * dataArr;
@end

@implementation CSYMainViewController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    
    pop = [NSPopover new];
    pop.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    pop.behavior = NSPopoverBehaviorTransient;
    pop.contentViewController = [[CSYPopViewController alloc]initWithNibName:@"CSYPopViewController" bundle:nil];
    pop.behavior = NSPopoverBehaviorTransient;
    
    
    [self.formAddress setDelegate:self];
    
    [self.toAddress setDelegate:self];
    
    // create a table view and a scroll view
    NSScrollView * tableContainer = [NSScrollView new];
    [_bgView addSubview:tableContainer];
    
    [tableContainer makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.offset(80);
        make.left.offset(10);
        make.right.bottom.offset(-10);
    }];
    
    tableView = [NSTableView new];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView reloadData];
    // embed the table view in the scroll view, and add the scroll view to our window.
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller:true];
    [tableContainer setHasHorizontalScroller:true];
    
    
    NSArray * titleArrs = @[@"车次",@"出发/到达时间",@"历时",@"商务座",@"一等座",@"二等座",@"高级软卧",@"软卧",@"动卧",@"硬卧",@"软座",@"硬座",@"无座",@"其它",@"备注"];
    
    for (int i = 0; i < titleArrs.count; i++) {
        
        NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"name%d",i]];
        [column1.headerCell setStringValue:@"name"];
        [column1.headerCell setTitle:titleArrs[i]];
        [column1.headerCell setAlignment:NSTextAlignmentCenter];
        [tableView addTableColumn:column1];
        [column1 setWidth:80];

        
    }
    
    
    
   
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


//-(NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//
//
//    NSString *identifier = [tableColumn identifier];
//
//    if (![tableColumn.identifier isEqualToString:identifier]) return nil;
//
//    CSYJQuryCell * cell = [CSYJQuryCell new];
//
//    if (row%2 == 0) {
//
//        cell.isBackground = true;
//
//            }else {
//                cell.isBackground =false;
//
//            }
//
//
//        NSArray * rowArr = _dataArr[row];
//
//        // 指定 cell 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name0" cell:cell title:rowArr[3]]) return ;
////        // 指定 cell 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name1" cell:cell title:[NSString stringWithFormat:@"%@-%@",rowArr[8],rowArr[9]]]) return ;
////        // 指定 cell 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name2" cell:cell title:rowArr[10]]) return ;
////
////        // 指定 商务特登座 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name3" cell:cell title:rowArr[32]]) return ;
////        // 指定 一等座 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name4" cell:cell title:rowArr[31]]) return ;
////        // 指定 二等座 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name5" cell:cell title:rowArr[30]]) return ;
////        // 指定 高级软卧 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name6" cell:cell title:rowArr[21]]) return ;
////        // 指定 软卧 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name7" cell:cell title:rowArr[23]]) return ;
////        // 指定 动卧 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name8" cell:cell title:rowArr[33]]) return ;
////        // 指定 硬卧 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name9" cell:cell title:rowArr[28]]) return ;
////        // 指定 软座 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name10" cell:cell title:rowArr[24]]) return ;
////        // 指定 硬座 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name11" cell:cell title:rowArr[29]]) return ;
////        // 指定 无座 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name12" cell:cell title:rowArr[26]]) return ;
////        // 指定 其它 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name13" cell:cell title:@"--"]) return ;
////        // 指定 备注 的内容
////        if ([self cellContextIdentifier:identifier queryIdentifier:@"name14" cell:cell title:rowArr[1]]) return ;
////
////
//    return cell;
//
//}


- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    


    NSString *identifier = [tableColumn identifier];


    NSTextFieldCell *textCell = cell;

    [textCell setDrawsBackground:true];


    if (row%2 == 0) {
        textCell.backgroundColor = [NSColor lightGrayColor];
    }else {
        textCell.backgroundColor = [NSColor orangeColor];
    }

    [textCell setAlignment:NSTextAlignmentCenter];
    [textCell setLineBreakMode:NSLineBreakByCharWrapping];
    [textCell setSelectable:false];

    NSArray * rowArr = _dataArr[row];

    // 指定 cell 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name0" cell:cell title:rowArr[3]]) return ;
    // 指定 cell 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name1" cell:cell title:[NSString stringWithFormat:@"%@-%@",rowArr[8],rowArr[9]]]) return ;
    // 指定 cell 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name2" cell:cell title:rowArr[10]]) return ;

    // 指定 商务特登座 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name3" cell:cell title:rowArr[32]]) return ;
    // 指定 一等座 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name4" cell:cell title:rowArr[31]]) return ;
    // 指定 二等座 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name5" cell:cell title:rowArr[30]]) return ;
    // 指定 高级软卧 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name6" cell:cell title:rowArr[21]]) return ;
    // 指定 软卧 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name7" cell:cell title:rowArr[23]]) return ;
    // 指定 动卧 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name8" cell:cell title:rowArr[33]]) return ;
    // 指定 硬卧 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name9" cell:cell title:rowArr[28]]) return ;
    // 指定 软座 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name10" cell:cell title:rowArr[24]]) return ;
    // 指定 硬座 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name11" cell:cell title:rowArr[29]]) return ;
    // 指定 无座 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name12" cell:cell title:rowArr[26]]) return ;
    // 指定 其它 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name13" cell:cell title:@"--"]) return ;
    // 指定 备注 的内容
    if ([self cellContextIdentifier:identifier queryIdentifier:@"name14" cell:cell title:rowArr[1]]) return ;
    
    for (NSString * str in _dataArr[row])
        
        if ([str integerValue] > 0 ) {
            
            NSCell * tmpCell = cell;
            NSLog(@"....。");
            NSButton * btn = [[NSButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
            [btn setTitle:@"fffff"];
            [btn.layer setBackgroundColor:[NSColor redColor].CGColor];
            [tmpCell.controlView addSubview:btn];
            break;
            
            
        }
    

}



/**
 在 cell 中显示要指定的内容

 @param identifier cell 的 ID
 @param queryID 查询 cell 的 ID
 @param cell 要查询的 cell
 @param title 要查询 cell 的标题
 */
-(BOOL)cellContextIdentifier:(NSString *)identifier queryIdentifier:(NSString *)queryID cell:(NSCell *)cell title:(NSString *)title{

    if ([identifier isEqualToString:queryID]) {

        if ([title isEqualToString:@""]) title = @"--";
//        [cell setcellti:title];
        cell.title = title;
        return true;
    }
    return false;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {

    return 35;
}

-(BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {

    return true;
}

- (IBAction)query:(NSButton *)sender {
    

//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//
//    NSString * url = @"https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=2018-02-25&leftTicketDTO.from_station=IZQ&leftTicketDTO.to_station=BOP&purpose_codes=0X00";
//
//    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//         [self tableReload:responseObject];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        NSLog(@"%@",error);
//    }];
    [self tableReload:nil];

}

-(void)tableReload:(NSDictionary *)data {

//    NSLog(@"data = %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    
    NSDictionary * dict = data;
    
    if (data == nil) {

        NSString * patch = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"text/json"];
        NSString * str = [[NSString alloc]initWithContentsOfFile:patch encoding:NSUTF8StringEncoding error:nil];
        NSData *  tmpData = [str dataUsingEncoding:NSUTF8StringEncoding];
        dict = [NSJSONSerialization JSONObjectWithData:tmpData options:NSJSONReadingMutableLeaves error:nil];
    }

    
    //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    dict = dict[@"data"];
    for (NSString * str in dict[@"result"]) {


        NSArray * objArr = [str componentsSeparatedByString:@"|"];

         [self.dataArr addObject:objArr];


    }


    [tableView reloadData];
}
- (IBAction)fromAccress:(id)sender {
    
    
    [pop showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSRectEdgeMaxY];
    
   // [self createPopView];
    
}
- (IBAction)toAccress:(id)sender {
   
//   [self createPopView];
    [pop showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSRectEdgeMaxY];
    
}

-(BOOL)textField:(NSTextField *)textField textView:(NSTextView *)textView shouldSelectCandidateAtIndex:(NSUInteger)index {
    
    NSLog(@"ffffffff");
    return true;
}




/** 新建 pop */
-(void)createPopView {
    
    pop = [NSPopover new];
    pop.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    pop.behavior = NSPopoverBehaviorTransient;
//    pop.contentViewController = self.contentViewController;
    pop.behavior = NSPopoverBehaviorTransient;
    [pop showRelativeToRect:[_formAddress bounds] ofView:_bgView preferredEdge:NSRectEdgeMaxY];
}

#pragma mark - 初始化全局属性

-(NSMutableArray *)dataArr {
    
    if (_dataArr)return _dataArr;
    return  _dataArr = [NSMutableArray new];
}
@end
