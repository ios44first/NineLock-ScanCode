//
//  NineLockView.h
//  NineLock
//
//  Created by mac on 14-9-1.
//  Copyright (c) 2014年 于建祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NineLockViewDelegate;

@interface NineLockView : UIView
{
    float width;
    float height;
    
    float radius;
    float viewWidth;
    float viewX;
    
    float lineWidth;
    UIColor *lineDefaultColor;
    UIColor *lineRightColor;
    UIColor *lineWrongColor;
    BOOL isShowLine;

    NSValue * tempPoint;
}

@property (nonatomic,assign) id<NineLockViewDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *selectPointArray;
@property (nonatomic,strong) NSMutableArray *firstPointArray;
@property (nonatomic,assign) BOOL isRight;

- (void)clearView;
- (void)hideLine;
- (void)showLine;

@end


@protocol NineLockViewDelegate <NSObject>

@optional
//第一次设置
- (void)lockFirst:(NineLockView *)nineLock pointArray:(NSMutableArray *)array pointString:(NSString *)pString;

//第二次设置
- (void)lockSecond:(NineLockView *)nineLock pointArray:(NSMutableArray *)array;

//解锁失败
- (void)lockFail:(NineLockView *)nineLock pointArray:(NSMutableArray *)array;

//解锁成功
- (void)lockSuccess:(NineLockView *)nineLock pointArray:(NSMutableArray *)array;

@end
