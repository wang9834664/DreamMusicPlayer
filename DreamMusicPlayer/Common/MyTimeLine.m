//
//  MyTimeLine.m
//  TestHighLightLabel
//
//  Created by 1 on 12-12-18.
//  Copyright (c) 2012年 cienet. All rights reserved.
//

#import "MyTimeLine.h"

@implementation MyTimeLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    {
        //线宽
        CGContextSetLineWidth(context, 1);
        
        //颜色
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        
        //圆长宽
        float ellipseWidth = rect.size.height - 2;
        float ellipseHeight = rect.size.height - 2;
        
        //画圆
        CGContextAddEllipseInRect(context, CGRectMake(0, 1, ellipseWidth, ellipseHeight));
        CGContextAddEllipseInRect(context, CGRectMake(rect.size.width - ellipseWidth, 1, ellipseWidth, ellipseHeight));
        
        //画线
        CGContextMoveToPoint(context, rect.origin.x + rect.size.height - 2, rect.origin.y + rect.size.height / 2);
        CGContextAddLineToPoint(context, rect.size.width - rect.size.height + 2, rect.origin.y + rect.size.height / 2);
        
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}


@end
