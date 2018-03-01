//
//  CSYLoginView.m
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYLoginView.h"

@implementation CSYLoginView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(instancetype)initWithFrame:(NSRect)frameRect {
    
    if ([super initWithFrame:frameRect]) {
        
        /** 初始化 UI */
        [self initWithUI];
    }
    return self;
}


/** 初始化 UI */
-(void)initWithUI {
    
    NSImageView * codeImage = [NSImageView new];
    [codeImage sd_setImageWithURL:[NSURL URLWithString:@"https://kyfw.12306.cn/passport/captcha/captcha-image?login_site=E&module=login&rand=sjrand"]];
    [self addSubview:codeImage];
    
    [codeImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.size.equalTo(CGSizeMake(293, 190));
    }];
    
    NSArray * titleArr = @[@"刷新",@"确认"];
    for (int i = 0; i < 2; i++) {
        
        NSButton * refreashBtn = [NSButton new];
        [refreashBtn setBezelStyle:NSBezelStyleTexturedSquare];
        [refreashBtn setTitle:titleArr[i]];
    }
    
}

@end
