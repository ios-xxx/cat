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


@interface CSYMainViewController ()<NSTableViewDelegate,NSTableViewDataSource,NSTextFieldDelegate>
{
    NSPopover * pop;
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
    
    [self.formAddress resignFirstResponder];
    [self.toAddress resignFirstResponder];
    [self.formAddress setIdentifier:@"formAddress"];
    [self.toAddress setIdentifier:@"toAddress"];
    
    
    // 获取所有的车站
    [self getAllStation];
}





#pragma mark - query method
- (IBAction)query:(NSButton *)sender {
    

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    NSString * url = @"https://kyfw.12306.cn/otn/leftTicket/queryZ?leftTicketDTO.train_date=2018-02-25&leftTicketDTO.from_station=IZQ&leftTicketDTO.to_station=BOP&purpose_codes=0X00";

    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

         [self tableReload:responseObject];

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


-(void)controlTextDidBeginEditing:(NSNotification *)obj {
    
    NSTextField * object = obj.object;
    [pop showRelativeToRect:[object bounds] ofView:object preferredEdge:NSRectEdgeMaxY];
    NSLog(@"...= %@",object.identifier);
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
        if([self isFileExist:@"city.txt" context:responseStr]){
        
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *filePath = [path stringByAppendingPathComponent:@"city.txt"];
            
            [self writeFile:filePath context:responseStr];
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
    if (!result) {
        
     BOOL isFile =    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        if (isFile) {
            
            DLog(@"create file ok");
            /** 写入文件 */
            [self writeFile:path context:context];
        }
    }
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
    
    
    NSError * err;
    BOOL isWrite = [contexts writeToFile: path atomically:true encoding:NSUTF8StringEncoding error:&err];
    
    if (isWrite) {
        
        DLog(@"write ok");
    }else {
        
        DLog(@"write error=%@",err);
    }
    
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

-(NSMutableArray *)selectDataArr {
    
    if (_selectDataArr) return _selectDataArr;
    return _selectDataArr = [NSMutableArray new];
}

@end
