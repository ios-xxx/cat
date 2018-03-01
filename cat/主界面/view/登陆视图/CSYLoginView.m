//
//  CSYLoginView.m
//  cat
//
//  Created by hongchen on 2018/3/1.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYLoginView.h"

@interface CSYLoginView()
{
    /** 验证码图片 */
    NSImageView * codeImage;
    /** 判断是否进入监控区域 */
    BOOL isEntered;
}

@end

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
    
    codeImage = [NSImageView new];
    
    [codeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://kyfw.12306.cn/passport/captcha/captcha-image?login_site=E&module=login&rand=sjrand&0.%d",arc4random()%10000+10000000]]];
    [self addSubview:codeImage];
    
    [codeImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.size.equalTo(CGSizeMake(293, 190));
    }];
    
    
    NSArray * titleArr = @[@"刷新",@"确认"];
    NSInteger count = titleArr.count;
    for (int i = 0; i < count; i++) {
        
        NSButton * refreashBtn = [NSButton new];
        [refreashBtn setBezelStyle:NSBezelStyleTexturedSquare];
        [refreashBtn setTitle:titleArr[i]];
        [refreashBtn setTarget:self];
        [refreashBtn setAction:@selector(codeBtnTap:)];
        [refreashBtn setTag:i];
        [self addSubview:refreashBtn];
        
        [refreashBtn makeConstraints:^(MASConstraintMaker *make) {
           
            if (i == 0) {
                make.centerX.equalTo(self).multipliedBy(0.5);
            }else {
                make.centerX.equalTo(self).multipliedBy(1.5);
            }
            make.bottom.offset(-10);
            make.top.equalTo(codeImage.bottom).offset(10);
            make.width.equalTo(self.width).multipliedBy(0.2);
        }];
    }
    
    //    添加监视钩端螺旋体病
        NSTrackingArea * trackingArea = [[NSTrackingArea alloc]initWithRect:codeImage.bounds options:NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved |
                                         NSTrackingCursorUpdate |
                                         NSTrackingActiveWhenFirstResponder |
                                         NSTrackingActiveInKeyWindow |
                                         NSTrackingActiveInActiveApp |
                                         NSTrackingActiveAlways |
                                         NSTrackingAssumeInside |
                                         NSTrackingInVisibleRect |
                                         NSTrackingEnabledDuringMouseDrag
                                                                      owner:self
                                                                   userInfo:nil];
    
    
        [codeImage addTrackingArea:trackingArea ];
    
}


-(void)codeBtnTap:(NSButton *)sender {
    
    if (sender.tag == 0) {
        
        [codeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://kyfw.12306.cn/passport/captcha/captcha-image?login_site=E&module=login&rand=sjrand&0.%d",arc4random()%10000+10000000]]];
    }else {
        
        [self removeFromSuperview];
    }
}


// 鼠标进入监视区
- (void)mouseEntered:(NSEvent *)theEvent{
    
    isEntered = true;

}
// 鼠标在监视区内移动
- (void)mouseMoved:(NSEvent *)theEvent{


//    DLog(@" log...2");
}
// 鼠标推出监视区
- (void)mouseExited:(NSEvent *)theEvent{

    isEntered = false;
}

// 按下鼠标左键
- (void)mouseDown:(NSEvent *)event {
    
    NSWindow * win = [NSApplication sharedApplication].keyWindow;
    
    
    NSPoint point = [event locationInWindow];
    
    float x = point.x - CGRectGetMinX(self.frame);
    float y =CGRectGetMaxY(self.frame) -  point.y;

//    DLog(@"%@ --- %@",NSStringFromPoint(CGPointMake(x, y)),NSStringFromPoint(point));
   
    
//    创建一个实心圆
    [self loadCircualPiont:CGPointMake(x, y)];
    
}
// 松开鼠标左键
- (void)mouseUp:(NSEvent *)theEvent{


    DLog(@" log...5");
}
// 按下鼠标右键
- (void)rightMouseDown:(NSEvent *)theEvent{


    DLog(@" log...6");
}
// 松开鼠标右键
- (void)rightMouseUp:(NSEvent *)theEvent{


    DLog(@" log...7");
}

/** 响应鼠标左键单击（创建一个实心圆） */
-(void)loadCircualPiont:(NSPoint )point {
    
    
    DLog(@"point = %@",NSStringFromPoint(point));
    NSView * circual = [NSView new];
    circual.wantsLayer = YES;
    [circual.layer setBackgroundColor:[NSColor redColor].CGColor];
    [circual.layer setCornerRadius:7.5];
    [circual.layer setMasksToBounds:true];
    [codeImage addSubview:circual];
    
    [circual makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.offset(point.x-7.5);
        make.top.offset(point.y-7.5);
        make.size.equalTo(CGSizeMake(15, 15));
    }];
    
    
   
}

- (NSViewController *)getCurrentVCFrom:(NSViewController *)rootVC
{
    NSViewController *currentVC;
    
    if ([rootVC presentingViewController]) {
        // 视图是被presented出来的
        
        currentVC = [rootVC presentingViewController];
    }
    
    return currentVC;
}

@end
