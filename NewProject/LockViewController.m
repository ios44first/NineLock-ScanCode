//
//  LockViewController.m
//  NewProject
//
//  Created by mac on 14-9-2.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import "LockViewController.h"

@interface LockViewController ()

@end

@implementation LockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backView.image = [UIImage imageNamed:@"back.jpeg"];
    [self.view addSubview:backView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 320, 30)];
    title.text = @"九宫格锁屏";
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor purpleColor];
    title.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:title];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(230, 72, 100, 20)];
    name.text = @"©于建祥";
    name.backgroundColor = [UIColor clearColor];
    name.textColor = [UIColor purpleColor];
    name.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:name];
    
    float height = [[UIScreen mainScreen] bounds].size.height;
    nine = [[NineLockView alloc] initWithFrame:CGRectMake(10, 0.3*height, 300, 300)];
    nine.delegate = self;
    nine.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nine];
    
    result = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.3*height-30, 320, 20)];
    result.text = @"请绘制解锁图案";
    result.backgroundColor = [UIColor clearColor];
    result.textAlignment = NSTextAlignmentCenter;
    result.textColor = [UIColor blueColor];
    result.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:result];
    
    UIButton *reset = [UIButton buttonWithType:UIButtonTypeCustom];
    [reset addTarget:self action:@selector(reSetLock:) forControlEvents:UIControlEventTouchUpInside];
    [reset setTitle:@"忘记图案 重绘图案" forState:UIControlStateNormal];
    [reset setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    reset.frame = CGRectMake(100, nine.frame.origin.y+nine.frame.size.height, 120, 30);
    reset.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:reset];

}

- (void)reSetLock:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入密码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex && alertView.tag == 100)
    {
        UITextField *tf = [alertView textFieldAtIndex:0];
        if ([tf.text isEqualToString:@"admin"])
        {
            result.textColor = [UIColor blueColor];
            result.text = @"请绘制锁屏图案";
            [nine.selectPointArray removeAllObjects];
            nine.isRight = YES;
            [nine performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.2];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KLock];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"密码输入错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
}

-(void)lockFirst:(NineLockView *)nineLock pointArray:(NSMutableArray *)array pointString:(NSString *)pString
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud valueForKey:KLock])
    {
        NSArray *readArray = [ud valueForKey:KLock];
        NSMutableArray *firstArray = [NSMutableArray arrayWithCapacity:1];
        for (NSString *tem in readArray)
        {
            [firstArray addObject:[NSValue valueWithCGPoint:CGPointFromString(tem)]];
        }
        if (firstArray.count != nineLock.selectPointArray.count)
        {
            result.textColor = [UIColor redColor];
            result.text = @"图案错误，请重新绘制";
            
            nineLock.isRight = NO;
            [nineLock performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.2];
        }
        else
        {
            int i=0;
            for (; i<firstArray.count; i++)
            {
                NSValue *va = [firstArray objectAtIndex:i];
                NSValue *vb = [nineLock.selectPointArray objectAtIndex:i];
                if (![va isEqualToValue:vb])
                {
                    result.textColor = [UIColor redColor];
                    result.text = @"图案错误，请重新绘制";
                    
                    nineLock.isRight = NO;
                    [nineLock performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.2];
                    break;
                }
            }
            if (i == firstArray.count)
            {
                nineLock.isRight = YES;
                [nineLock.selectPointArray removeAllObjects];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
    else
    {
        if (nineLock.firstPointArray)
        {
            if (nineLock.firstPointArray.count != nineLock.selectPointArray.count)
            {
                result.textColor = [UIColor redColor];
                result.text = @"图案与上次不同，请重新绘制";
                
                nineLock.isRight = NO;
                [nineLock performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.2];
            }
            else
            {
                int i=0;
                for (; i<nineLock.firstPointArray.count; i++)
                {
                    NSValue *va = [nineLock.firstPointArray objectAtIndex:i];
                    NSValue *vb = [nineLock.selectPointArray objectAtIndex:i];
                    if (![va isEqualToValue:vb])
                    {
                        result.textColor = [UIColor redColor];
                        result.text = @"图案与上次不同，请重新绘制";
                        
                        nineLock.isRight = NO;
                        [nineLock performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.2];
                        break;
                    }
                }
                if (i == nineLock.firstPointArray.count)
                {
                    result.textColor = [UIColor blueColor];
                    result.text = @"解锁图案设置成功";
                    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:1];
                    for (NSValue *value in nineLock.firstPointArray)
                    {
                        [temp addObject:NSStringFromCGPoint([value CGPointValue])];
                    }
                    [ud setObject:temp forKey:KLock];
                    [ud synchronize];
                    
                    nineLock.isRight = YES;
                    [nineLock.firstPointArray removeAllObjects];
                    nineLock.firstPointArray = nil;
                    [nineLock.selectPointArray removeAllObjects];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
        }
        else
        {
            result.textColor = [UIColor blueColor];
            result.text = @"请再次绘制图案";
            nineLock.isRight = YES;
            nineLock.firstPointArray = [[NSMutableArray alloc] initWithArray:nineLock.selectPointArray];
            [nineLock.selectPointArray removeAllObjects];
            [nineLock performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.2];
        }
    }
}

-(void)lockSecond:(NineLockView *)nineLock pointArray:(NSMutableArray *)array
{
}

-(void)lockSuccess:(NineLockView *)nineLock pointArray:(NSMutableArray *)array
{
}

-(void)lockFail:(NineLockView *)nineLock pointArray:(NSMutableArray *)array
{
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
