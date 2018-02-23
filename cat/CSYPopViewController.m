//
//  CSYPopViewController.m
//  cat
//
//  Created by hongchen on 2018/2/18.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYPopViewController.h"



@interface CSYPopViewController ()<NSTableViewDelegate,NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *table;

@end

@implementation CSYPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
//    _table.delegate = self;
//    _table.dataSource = self;
    
    
}


@end
