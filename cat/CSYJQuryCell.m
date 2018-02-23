//
//  CSYJQuryCell.m
//  cat
//
//  Created by hongchen on 2018/2/17.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYJQuryCell.h"

@implementation CSYJQuryCell


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [super drawWithFrame:cellFrame inView:controlView];
    
    NSLog(@"mmm");
    //选中高亮色这种只能改变某个Cell的背景色不能整行改变
    if ([self isHighlighted]) {
        [self highlightColorWithFrame:cellFrame inView:controlView];
    }
    
    [controlView.layer setBackgroundColor:[NSColor orangeColor].CGColor];
    if (_isBackground)  {

        [controlView.layer setBackgroundColor:[NSColor orangeColor].CGColor];
        
            }
    else{
        
        [controlView.layer setBackgroundColor:[NSColor lightGrayColor].CGColor];

            }
    
    _cellTitle = @"fffff";
    
    NSColor* primaryColor   = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor textColor];
    
    NSDictionary* primaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: primaryColor, NSForegroundColorAttributeName,
                                           [NSFont systemFontOfSize:13], NSFontAttributeName, nil ,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_cellTitle attributes:primaryTextAttributes];
    [string setAttributes:@{NSForegroundColorAttributeName:[NSColor redColor]} range:NSMakeRange(0, 5)];
    //[string drawAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.height+10, cellFrame.origin.y+20)];
    //用下面这个可以使用省略属性
    
    NSMutableParagraphStyle *ps = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [ps setLineBreakMode:NSLineBreakByTruncatingTail];
    NSRange range = NSMakeRange(0, [string length]);
    [string addAttribute:NSParagraphStyleAttributeName value:ps range:range];
    
    CGSize size = [self getTitleWith:string.string];
    float x = size.width;
    x = cellFrame.size.width/2 - x/2+cellFrame.origin.x;
    float y = size.height;
    y = cellFrame.size.height/2 - y/2 +cellFrame.origin.y;

    [string drawInRect:NSMakeRect(x,y,size.width,size.height)];
    
}


/**
 获取字符串总大小

 @param str 要获取的字符
 @return 大小
 */
-(CGSize )getTitleWith:(NSString *)str {
    
    
    NSDictionary *dict = @{NSFontAttributeName : [NSFont systemFontOfSize:13.0]};
    CGSize size=[str boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size;
    
}

@end
