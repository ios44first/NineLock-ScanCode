//
//  NineLockView.m
//  NineLock
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 于建祥. All rights reserved.
//

#import "NineLockView.h"

@implementation NineLockView
@synthesize firstPointArray,selectPointArray,isRight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor clearColor];
        
        width = frame.size.width;
        height = frame.size.height;
        
        viewWidth = width / 3.0;
        radius = 0.6 * viewWidth;
        viewX = (viewWidth-radius)/2.0;
        
        lineWidth = 3.0;
        lineDefaultColor = [UIColor whiteColor];
        lineRightColor = [UIColor blueColor];
        lineWrongColor = [UIColor redColor];
        
        isRight = YES;
        isShowLine = YES;
        
    }
    return self;
}

- (void)hideLine
{
    isShowLine = NO;
}

- (void)showLine
{
    isShowLine = YES;
}

- (void)clearView
{
    [self.firstPointArray removeAllObjects];
    [self.selectPointArray removeAllObjects];
    tempPoint = nil;
    isRight = YES;
    [self setNeedsDisplay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!selectPointArray)
    {
        selectPointArray = [[NSMutableArray alloc] initWithCapacity:9];
    }
    else
    {
        [selectPointArray removeAllObjects];
    }
    
    tempPoint = nil;
    isRight = YES;
    
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    NSValue *tem = [self getAvailablePoint:point];
    if (tem && ![selectPointArray containsObject:tem])
    {
        [selectPointArray addObject:tem];
    }
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(point));
    NSValue *tem = [self getAvailablePoint:point];
    if (tem && ![selectPointArray containsObject:tem])
    {
        NSLog(@"center:%@",NSStringFromCGPoint([tem CGPointValue]));
        [selectPointArray addObject:tem];
    }
    else
    {
        tempPoint = [NSValue valueWithCGPoint:point];
        NSLog(@"tempPoint=%@",tempPoint);
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    tempPoint = nil;
    [self setNeedsDisplay];
    
    NSString *pString = @"";
    if (selectPointArray.count > 0)
    {
        for (NSValue *temValue in selectPointArray)
        {
            pString = [pString stringByAppendingFormat:@"%d",[self getCenterNumber:temValue]];
        }
    }
    
    [self.delegate lockFirst:self pointArray:selectPointArray  pointString:pString];
    
}

- (NSValue *)getAvailablePoint:(CGPoint)point
{
    float px = point.x;
    float py = point.y;
    
    if (px > viewWidth)
    {
        px -= viewWidth;
        if (px > viewWidth)
        {
            px -= viewWidth;
        }
    }
    if (py > viewWidth)
    {
        py -= viewWidth;
        if (py > viewWidth)
        {
            py -= viewWidth;
        }
    }
    
    if ((px>=viewX && px<=viewWidth-viewX) && (py>=viewX && py<=viewWidth-viewX))
    {
        CGPoint p = [self getCenter:point];
        return [NSValue valueWithCGPoint:p];
    }
    else
    {
        return nil;
    }
}

- (CGPoint)getCenter:(CGPoint)point
{
    return CGPointMake(viewWidth/2+(int)(point.x/viewWidth)*viewWidth, viewWidth/2+(int)(point.y/viewWidth)*viewWidth);
}

- (int)getCenterNumber:(NSValue *)value
{
    CGPoint point = [value CGPointValue];
    int n_X = roundf((point.x-viewWidth/2)/viewWidth);
    int n_Y = roundf((point.y-viewWidth/2)/viewWidth);
    return n_Y * 3 + n_X;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    //画线
    if (selectPointArray.count>0)
    {
        CGContextSetLineWidth(context, lineWidth);
        if (isRight)
        {
            CGContextSetStrokeColorWithColor(context, isShowLine?lineRightColor.CGColor:self.backgroundColor.CGColor);
        }
        else
        {
            CGContextSetStrokeColorWithColor(context, isShowLine?lineWrongColor.CGColor:self.backgroundColor.CGColor);
        }
        
        for (int j=0; j<selectPointArray.count-1; j++)
        {
            CGPoint pointA = [[selectPointArray objectAtIndex:j] CGPointValue];
            CGContextMoveToPoint(context, pointA.x, pointA.y);
            CGPoint pointB = [[selectPointArray objectAtIndex:j+1] CGPointValue];
            CGContextAddLineToPoint(context, pointB.x, pointB.y);
            
            CGContextStrokePath(context);
        }
        if (tempPoint)
        {
            CGPoint pointA = [[selectPointArray lastObject] CGPointValue];
            CGContextMoveToPoint(context, pointA.x, pointA.y);
            CGPoint p = [tempPoint CGPointValue];
            CGContextAddLineToPoint(context, p.x, p.y);
            
            CGContextStrokePath(context);
        }
    }

    //默认圈
    for (int i=0; i<9; i++)
    {
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(context, lineDefaultColor.CGColor);
        CGContextSetFillColorWithColor(context, lineDefaultColor.CGColor);
        
        CGContextAddEllipseInRect(context, CGRectMake(viewX+viewWidth*(i%3), viewX+viewWidth*(i/3), radius, radius));
        CGContextStrokePath(context);
    }
    
    //改变圈色
    for (int j=0; j<selectPointArray.count; j++)
    {
        CGContextSetLineWidth(context, lineWidth);
        
        CGPoint point = [[selectPointArray objectAtIndex:j] CGPointValue];
        
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextFillEllipseInRect(context, CGRectMake(point.x-radius/2.0, point.y-radius/2.0, radius, radius));
        CGContextStrokePath(context);
        
        if (isRight)
        {
            CGContextSetStrokeColorWithColor(context, isShowLine?lineRightColor.CGColor:lineDefaultColor.CGColor);
            CGContextSetFillColorWithColor(context, isShowLine?lineRightColor.CGColor:lineDefaultColor.CGColor);
        }
        else
        {
            CGContextSetStrokeColorWithColor(context, isShowLine?lineWrongColor.CGColor:lineDefaultColor.CGColor);
            CGContextSetFillColorWithColor(context, isShowLine?lineWrongColor.CGColor:lineDefaultColor.CGColor);
        }
        
        CGContextAddEllipseInRect(context, CGRectMake(point.x-radius/2.0, point.y-radius/2.0, radius, radius));
        CGContextStrokePath(context);
        
        if (isShowLine)
        {
            CGContextFillEllipseInRect(context, CGRectMake(point.x-radius/6.0, point.y-radius/6.0, radius/3.0, radius/3.0));
            CGContextStrokePath(context);
        }
    }
    
}


@end
