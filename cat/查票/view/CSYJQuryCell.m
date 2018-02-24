//
//  CSYJQuryCell.m
//  cat
//
//  Created by hongchen on 2018/2/17.
//  Copyright © 2018年 hongchen. All rights reserved.
//

#import "CSYJQuryCell.h"
#import "NSTextFieldCellCenter.h"

@implementation CSYJQuryCell




- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    ChangeCell cell = _cellBlock;
    cell(self,cellFrame);
    
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
