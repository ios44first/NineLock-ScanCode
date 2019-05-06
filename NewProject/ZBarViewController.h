//
//  ZBarViewController.h
//  NewProject
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ZBarViewController : UIViewController<ZBarReaderViewDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    ZBarReaderView *reader;
}

@property (nonatomic, strong) UIImageView * line;
@property (nonatomic, retain) UITextView *resultView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) BOOL isQR;

@end
