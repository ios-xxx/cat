//
//  CSYPopViewController.m
//  cat
//
//  Created by hongchen on 2018/2/18.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYPopViewController.h"


@interface CSYPopViewController ()<NSTableViewDelegate,NSTableViewDataSource>


@end

@implementation CSYPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    __weak CSYPopViewController * obj = self;
    
    _table.closeBlock = ^(NSArray *data,NSString * popTag) {
      
        PopCloseComplete closeBlock = obj.closeBlock;
        closeBlock(data,popTag);
    };
    
    

    
}


@end
