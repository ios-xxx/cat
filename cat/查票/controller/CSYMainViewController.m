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
#import "CSYQueryTableView.h"

#import "CSYDatePopViewController.h"


@interface CSYMainViewController ()<NSTableViewDelegate,NSTableViewDataSource,NSTextFieldDelegate>
{
    /** 车站 pop */
    NSPopover * pop;
    /** 日期 pop */
    NSPopover * datePop;
}

/** 出发地 */
@property (strong) IBOutlet NSTextField *formAddress;
 /** 目的地 */
@property (weak) IBOutlet NSTextField *toAddress;

@property (weak) IBOutlet CSYQueryTableView *tableView;


@property (weak) IBOutlet NSView *bgView;
/** 数据 */
@property (strong,nonatomic) NSMutableArray * dataArr;
/** 选中数据 */
@property (strong,nonatomic) NSMutableArray * selectDataArr;
/** 城市数据 */
@property (strong,nonatomic) NSMutableArray * cityArrs;
/** 当前城市数据 */
@property (strong,nonatomic) NSArray * currentCityArr;
/** 城市交换数据 */
@property (strong,nonatomic) NSMutableArray * exchangeCityArrs;

/** 车站弹窗视图控制器 */
@property (strong,nonatomic) CSYPopViewController * popViewController;
/** 日期弹窗视图控制器 */
@property (strong,nonatomic)  CSYDatePopViewController * datePopViewController;

/** 当前乘车日期 */
@property (weak) IBOutlet NSButton *currentDate;

/** 保存未来60天的日期 */
@property (strong,nonatomic) NSMutableArray * saveDateArrs;

@end

@implementation CSYMainViewController


- (void)windowDidLoad {
    [super windowDidLoad];
    
    
    pop = [NSPopover new];
    pop.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    pop.behavior = NSPopoverBehaviorTransient;
    _popViewController = [[CSYPopViewController alloc]initWithNibName:@"CSYPopViewController" bundle:nil];
    pop.contentViewController = _popViewController;
    pop.behavior = NSPopoverBehaviorTransient;
    
    datePop = [NSPopover new];
    datePop.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    datePop.behavior = NSPopoverBehaviorTransient;
    _datePopViewController = [[CSYDatePopViewController alloc]initWithNibName:@"CSYDatePopViewController" bundle:nil];
    datePop.contentViewController = _datePopViewController;
    datePop.behavior = NSPopoverBehaviorTransient;
    
    [self.formAddress setDelegate:self];
    [self.toAddress setDelegate:self];
    
    [self.formAddress resignFirstResponder];
    [self.toAddress resignFirstResponder];
    [self.formAddress setIdentifier:@"formAddress"];
    [self.toAddress setIdentifier:@"toAddress"];
 
    
//  获取所有的车站
    [self getAllStation];
//  响应选择城市内容回调
    [self selectCityComplete];
//  初始化日期方法
    [self initWithDate];
    
}



#pragma mark - query method
- (IBAction)query:(NSButton *)sender {
    

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/json", @"text/javascript",@"text/html",@"application/text", nil];

    NSString * url = @"https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=2018-02-30&leftTicketDTO.from_station=IZQ&leftTicketDTO.to_station=BOP&purpose_codes=0X00";

    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         [self tableReload:json];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"%@",error);
    }];
    
//    [self tableReload:nil];

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
    
    [self.dataArr removeAllObjects];
    [self.selectDataArr removeAllObjects];
    
    for (NSString * str in dict[@"result"]) {


        NSArray * objArr = [str componentsSeparatedByString:@"|"];

        [_dataArr addObject:objArr];
        [_selectDataArr addObject:@(0)];

    }
    
    _tableView.dataArr = _dataArr;
    _tableView.selectDataArr = _selectDataArr;

    [_tableView reloadData];
}


/** 获取所有车站 */
-(void)getAllStation {
    
    AFHTTPSessionManager * manager = [ AFHTTPSessionManager  manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/json",@"text/html",@"text/javascript", nil]];
    
    [manager GET:url(@"/otn/resources/js/framework/station_name.js?station_version=1.9047") parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * responseStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (responseStr.length < 1) return ;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filePath = [path stringByAppendingPathComponent:@"city.txt"];
        
        /** 判断文件是否存在 */
        if([self isFileExist:@"city.txt" context:responseStr]){
        
            /** 写入内容 */
            [self writeFile:filePath context:responseStr];
            
        }else { //不存在
            
            /** 创建文件并写入内容 */
            NSFileManager * fileManger = [NSFileManager defaultManager];
            BOOL isFile =    [fileManger createFileAtPath:filePath contents:nil attributes:nil];
            
            /** 新建成功  */
            if (isFile) {
                
                /** 写入内容 */
                [self writeFile:filePath context:responseStr];
            }
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        DLog(@"error = %@",error);
    }];
    
}


//判断文件是否已经在沙盒中已经存在？
-(BOOL) isFileExist:(NSString *)fileName context:(NSString *)context
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
   
    return result;
}


/**
 写入文件

 @param path 文件路径
 @param context 内容
 */
-(void)writeFile:(NSString *)path context:(NSString *)context{
    
    NSMutableString * contexts = [NSMutableString stringWithString:context];
    NSRange range = [context rangeOfString:@"="];
    [contexts deleteCharactersInRange:NSMakeRange(0, range.location+1)];
    [contexts deleteCharactersInRange:NSMakeRange(0, 2)];
    [contexts deleteCharactersInRange:NSMakeRange(contexts.length-2, 2)];
    
    
    NSError * err;
    BOOL isWrite = [contexts writeToFile: path atomically:true encoding:NSUTF8StringEncoding error:&err];
    
    if (isWrite) {  // 写入成功
        
//        取出所有车站转换为拼音
        NSArray * cityArr = [contexts componentsSeparatedByString:@"@"];
        [self.cityArrs removeAllObjects];
        
        for (NSString * str in cityArr){
            
            NSMutableArray * tmpArrs = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"|"]];
            [tmpArrs removeObject:tmpArrs.lastObject];
            [_cityArrs addObject:tmpArrs];
            
            DLog(@"%@",str);
        }
        
        DLog(@"write ok");
        
    }else {
        
        DLog(@"write error=%@",err);
    }
    
}


#pragma mark - nstextFiled delegate

-(BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    
    [pop showRelativeToRect:[control bounds] ofView:control preferredEdge:NSRectEdgeMaxY];
    _popViewController.table.popTag = control.identifier;
    [control becomeFirstResponder];
    
    return true;
}


-(void)controlTextDidChange:(NSNotification *)obj {
    
    NSTextField * object = obj.object;
    
    NSString * reg = [NSString stringWithFormat:@"^%@+$",object.stringValue];
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    //    [pop showRelativeToRect:[object bounds] ofView:object preferredEdge:NSRectEdgeMaxY];
    
    NSMutableArray * tmpCityArrs = [NSMutableArray array];
    
    for (NSArray * city in _cityArrs){
        
        if ([regextest evaluateWithObject:city[4]]) {
            
            [tmpCityArrs addObject:city];
        }
        
    }
    
    _currentCityArr = [NSArray arrayWithArray:tmpCityArrs];
    
    _popViewController.table.dataArr = [NSArray arrayWithArray:_currentCityArr];
    [_popViewController.table reloadData];
    
    //    NSLog(@"...= %@ title = %@",object.identifier, object.stringValue);
    
    
}

/** 交换车站  */
- (IBAction)exchange:(id)sender {
    
    NSString * fromAddress = _formAddress.stringValue;
    _formAddress.stringValue = _toAddress.stringValue;
    _toAddress.stringValue   = fromAddress;
}


#pragma mark - 日期方法

/** 初始化乘车日期 */
-(void)initWithDate {
    
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy/MM/dd"]];
    NSString * currentDateStr = [formatter stringFromDate:date];
    _currentDate.title = currentDateStr;
    
}

/** 响应日期栏被单击 */
- (IBAction)dateClick:(id)sender {
    
    [datePop showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSRectEdgeMaxY];
}





#pragma mark - 弹窗方法

/** 响应选择城市内容回调 */
-(void)selectCityComplete {
    
    __weak NSPopover * objPop = pop;
    __weak CSYMainViewController * main = self;
    
    _popViewController.closeBlock = ^(NSArray *data,NSString * popTag) {
        
        [objPop close];
        
        if ([popTag isEqualToString:main.formAddress.identifier]) {
            
            main.formAddress.stringValue = data[1];
        }else {
            
            main.toAddress.stringValue = data[1];
        }
        DLog(@"%@",data);
    };
    
}

#pragma mark - 初始化全局属性

-(NSMutableArray *)dataArr {
    
    if (_dataArr)return _dataArr;
    return  _dataArr = [NSMutableArray new];
}

-(NSMutableArray *)selectDataArr {
    
    if (_selectDataArr) return _selectDataArr;
    return _selectDataArr = [NSMutableArray new];
}

-(NSMutableArray *)cityArrs {
    
    if (_cityArrs) return _cityArrs;
    
    return  _cityArrs = [NSMutableArray new];
}

-(NSMutableArray *)saveDateArrs {
    
    if (_saveDateArrs) return _saveDateArrs;
    
    _saveDateArrs = [NSMutableArray new];
    
    for (int i = 0; i < 60; i++) {
        
        NSDateComponents * components2 = [[NSDateComponents alloc] init];
        components2.year = 0;
        components2.day = 60;
        NSCalendar *calendar3 = [NSCalendar currentCalendar];
        NSDate *currentDate = [NSDate date];
        
        NSDate *nextData = [calendar3 dateByAddingComponents:components2 toDate:currentDate options:NSCalendarMatchStrictly];
        NSDateFormatter * formatter1 = [[NSDateFormatter alloc] init];
        formatter1.dateFormat = @"yyyy/MM/dd";
        NSString * dateStr = [formatter1 stringFromDate:nextData];
        
        [_saveDateArrs addObject:dateStr];
    }
    
    return _saveDateArrs;
    
}

@end
