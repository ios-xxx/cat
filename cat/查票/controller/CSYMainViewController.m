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
/** 车站数据 */
@property (strong,nonatomic) NSMutableArray * dataArr;
/** 选中车站数据 */
@property (strong,nonatomic) NSMutableArray * selectDataArr;
/** 城市数据 */
@property (strong,nonatomic) NSMutableArray * cityArrs;
/** 当前城市数据 */
@property (strong,nonatomic) NSArray * currentCityArr;

/** 当前选择出发城市数据 */
@property (strong,nonatomic) NSArray * currentSelectFromCityArr;
/** 当前选择目的地城市数据 */
@property (strong,nonatomic) NSArray * currentSelectToCityArr;

/** 车站弹窗视图控制器 */
@property (strong,nonatomic) CSYPopViewController * popViewController;
/** 日期弹窗视图控制器 */
@property (strong,nonatomic)  CSYDatePopViewController * datePopViewController;

/** 当前乘车日期 */
@property (weak) IBOutlet NSButton *currentDate;
/** 学生票 */
@property (weak) IBOutlet NSButton *studentCheck;

/** 成人票 */
@property (weak) IBOutlet NSButton *adultCheck;

/** 保存未来60天的日期 */
@property (strong,nonatomic) NSMutableArray * saveDateArrs;

/** 出发日期 */
@property (strong,nonatomic) NSString * trainDateStr;
/** 出发地车站码 */
@property (strong,nonatomic) NSString * fromStationStr;
/** 目的地车站码 */
@property (strong,nonatomic) NSString * toStation;
/** 车票类型 */
@property (strong,nonatomic) NSString * purposeCodesStr;

@end

@implementation CSYMainViewController


- (void)windowDidLoad {
    [super windowDidLoad];
    
    /** 初始化车站 Pop */
    [self initWithStationPop];
    /** 初始化日期 Pop */
    [self initWithDatePop];
    
    
    [self.formAddress setDelegate:self];
    [self.toAddress setDelegate:self];
    
    [self.formAddress resignFirstResponder];
    [self.toAddress resignFirstResponder];
    [self.formAddress setIdentifier:@"formAddress"];
    [self.toAddress setIdentifier:@"toAddress"];
 
    
//  获取所有的车站
    [self getAllStation];
//  初始化日期方法
    [self initWithDate];
    
}



#pragma mark - query method
- (IBAction)query:(NSButton *)sender {
    

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/json", @"text/javascript",@"text/html",@"application/text", nil];
    
   
    NSError* error = NULL;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"/"
                                                                           options:0
                                                                             error:&error];
    NSString* sample = _currentDate.title;

    NSString * dateStr = [regex stringByReplacingMatchesInString:sample
                                                       options:0
                                                         range:NSMakeRange(0, sample.length)
                                                  withTemplate:@"-"];
    
    NSString * fromCityCodeStr = _currentSelectFromCityArr[2] == nil ? @"GZQ":_currentSelectFromCityArr[2];
    NSString * toCityCodeStr   = _currentSelectToCityArr[2]   == nil ? @"WHN": _currentSelectToCityArr[2];

    NSString * url = [NSString stringWithFormat:@"https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=%@&leftTicketDTO.from_station=%@&leftTicketDTO.to_station=%@&purpose_codes=%@",dateStr,fromCityCodeStr,toCityCodeStr,self.purposeCodesStr];
    
    
//    DLog(@"url = %@",url);
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString * currentUrl = task.currentRequest.URL.absoluteString;
        
        if ([currentUrl rangeOfString:@"error"].location != NSNotFound ) {
           
            DLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
            DLog(@"网络请求出错了---");
            return ;
        }
        
        
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        [self tableReload:json];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"%@",error);
    }];
}

-(void)tableReload:(NSDictionary *)data {

//    if (data == nil) {
//        
//        
//        DLog(@"网络访问出错了");
//        return;
//    }
//    
//    DLog(@"data = %@",data);
    
    
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

#pragma mark - 车站交换
/** 交换车站  */
- (IBAction)exchange:(id)sender {
    
    NSString * fromAddress = _formAddress.stringValue;
    _formAddress.stringValue = _toAddress.stringValue;
    _toAddress.stringValue   = fromAddress;
    
    /** 创建临时数组存放交换数据 */
    NSArray * tmpExchangeSelectCityArr  =  _currentSelectFromCityArr;
    _currentSelectFromCityArr =  _currentSelectToCityArr;
    _currentSelectToCityArr   =  tmpExchangeSelectCityArr;
}


#pragma mark - 响应选择车票类型（学生，成人）

/** 响应成人单选框被选中 */
- (IBAction)adultClick:(NSButton *)sender {
    
    _studentCheck.state = 0;
    sender.state = 1;
    _purposeCodesStr = @"ADULT";
}

/** 响应学生单选框被选中 */
- (IBAction)studentCheck:(NSButton *)sender {
    
    sender.state = 1;
    _adultCheck.state = 0;
    _purposeCodesStr = @"0X00";
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
    [_datePopViewController.table reloadData];
    
}





#pragma mark - 弹窗方法
/** 初始化车站 pop */
-(void)initWithStationPop {
    
    pop = [NSPopover new];
    pop.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    pop.behavior = NSPopoverBehaviorTransient;
    _popViewController = [[CSYPopViewController alloc]initWithNibName:@"CSYPopViewController" bundle:nil];
    pop.contentViewController = _popViewController;
    pop.behavior = NSPopoverBehaviorTransient;
    
    /** 响应选择城市内容回调 */
    [self selectCityComplete];
}


/** 响应选择城市内容回调 */
-(void)selectCityComplete {
    
    __weak NSPopover * objPop = pop;
    __weak CSYMainViewController * main = self;
    
    _popViewController.closeBlock = ^(NSArray *data,NSString * popTag) {
        
        [objPop close];
        
        if ([popTag isEqualToString:main.formAddress.identifier]) {
            
            main.currentSelectFromCityArr = data;
            main.formAddress.stringValue = data[1];
        }else {
            
            main.currentSelectToCityArr = data;
            main.toAddress.stringValue = data[1];
        }
    };
    
}

/** 初始化日期 pop */
-(void)initWithDatePop {
    
    datePop = [NSPopover new];
    datePop.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    datePop.behavior = NSPopoverBehaviorTransient;
    _datePopViewController = [[CSYDatePopViewController alloc]initWithNibName:@"CSYDatePopViewController" bundle:nil];
    
    datePop.contentViewController = _datePopViewController;
    datePop.behavior = NSPopoverBehaviorTransient;
    
   NSMutableArray * tmpSelectDateArrs = [NSMutableArray new];
    
    NSInteger count =self.saveDateArrs.count;
    for (int i = 0; i < count; i++) {
        
        [tmpSelectDateArrs addObject:@(0)];
    }
    
    _datePopViewController.dataArr = [NSArray arrayWithArray:_saveDateArrs];
    _datePopViewController.selectDateArr = tmpSelectDateArrs;
    
//    响应选中日期回调
    [self selectDateComplete];
    
}

/** 响应选中日期回调 */
-(void)selectDateComplete {
    
    __weak    CSYMainViewController * main = self;
    _datePopViewController.selectDateBlcok = ^(NSString *dateStr) {
      
        main.currentDate.title = dateStr;
        
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
        components2.day = i;
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

-(NSString *)purposeCodesStr {
    
    if (_purposeCodesStr != nil) return _purposeCodesStr;
    
    return _purposeCodesStr = @"ADULT";
}

@end
