//
//  LockViewController.h
//  NewProject
//
//  Created by mac on 14-9-2.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NineLockView.h"
#import "ViewController.h"

@interface LockViewController : UIViewController<NineLockViewDelegate,UIAlertViewDelegate>
{
    NineLockView *nine;
    UILabel *result;
}

@end
