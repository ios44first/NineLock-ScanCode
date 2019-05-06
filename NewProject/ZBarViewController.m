//
//  ZBarViewController.m
//  NewProject
//
//  Created by mac on 14-8-14.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import "ZBarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Compression.h"

@interface ZBarViewController ()
{
    UISegmentedControl *shake;
}
@end

@implementation ZBarViewController

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
    // Do any additional setup after loading the view.
    
    [self scanBtnAction];
    
}

-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    
    reader = [[ZBarReaderView alloc] initWithImageScanner:[[ZBarImageScanner alloc] init]];
    reader.frame = self.view.bounds;
    ZBarImageScanner *scanner = reader.scanner;
    reader.readerDelegate = self;
    [scanner setSymbology:ZBAR_PARTIAL|ZBAR_EAN2|ZBAR_EAN5|ZBAR_EAN8|ZBAR_UPCE|ZBAR_ISBN10|ZBAR_UPCA|ZBAR_EAN13|ZBAR_ISBN13|ZBAR_COMPOSITE|ZBAR_I25|ZBAR_DATABAR|ZBAR_DATABAR_EXP|ZBAR_CODE39|ZBAR_PDF417|ZBAR_QRCODE|ZBAR_CODE93|ZBAR_CODE128|ZBAR_SYMBOL|ZBAR_ADDON2|ZBAR_ADDON5|ZBAR_ADDON config:ZBAR_CFG_ENABLE to:0];
    [self.view addSubview:reader];
    
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.isQR?65:85)];
    backView1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [reader addSubview:backView1];
    
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.isQR?375:355, 320, ScreenHeight-(self.isQR?375:355))];
    backView2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [reader addSubview:backView2];
    
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton setTitle:@"返回" forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [scanButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    scanButton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    scanButton.layer.cornerRadius = 5;
    scanButton.frame = CGRectMake(10, 30, 40, 20);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [reader addSubview:scanButton];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 270, 40)];
    if (self.isQR)
    {
        label.text = @"请将扫描的二维码置于下面的框内";
    }
    else
    {
        label.text = @"请将扫描的条形码置于下面的框内";
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [reader addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    if (self.isQR)
    {
        image.frame = CGRectMake(20, 80, 280, 280);
    }
    else
    {
        image.frame = CGRectMake(20, 120, 280, 200);
    }
    [reader addSubview:image];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    if (!self.isQR)
    {
        _line.frame = CGRectMake(30, 99, 220, 2);
    }
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:self.isQR?0.02:0.5 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    shake = [[UISegmentedControl alloc] initWithItems:@[@"关闭",@"震动"]];
    shake.frame = CGRectMake(27, 420, 120, 30);
    shake.selectedSegmentIndex = 0;
    [reader addSubview:shake];
    
    UISegmentedControl *sg = [[UISegmentedControl alloc] initWithItems:@[@"关灯",@"开灯"]];
    sg.frame = CGRectMake(174, 420, 120, 30);
    sg.selectedSegmentIndex = 0;
    [sg addTarget:self action:@selector(light:) forControlEvents:UIControlEventValueChanged];
    [reader addSubview:sg];
    
    //reader.scanCrop = CGRectMake(0.06, 0.17, 0.875, 0.61);
    [reader performSelector:@selector(start) withObject:nil afterDelay:0.1];
}

- (void)backAction
{
    [reader stop];
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [reader removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)animation1
{
    if (self.isQR)
    {
        if (upOrdown == NO) {
            num ++;
            _line.frame = CGRectMake(30, 10+2*num, 220, 2);
            if (2*num == 260) {
                upOrdown = YES;
            }
        }
        else {
            num --;
            _line.frame = CGRectMake(30, 10+2*num, 220, 2);
            if (num == 0) {
                upOrdown = NO;
            }
        }
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            if (_line.alpha == 0)
            {
                _line.alpha = 1;
            }
            else
            {
                _line.alpha = 0;
            }
        }];
    }
    
}

-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    [readerView stop];
    if ([symbols count]>2) {
        int quality = 0;
        ZBarSymbol *bestResult = nil;
        for(ZBarSymbol *sym in symbols) {
            int q = sym.quality;
            if(quality < q) {
                quality = q;
                bestResult = sym;
            }
        }
        [self performSelector: @selector(presentResult:) withObject: bestResult afterDelay: .001];
    }else {
        ZBarSymbol *symbol = nil;
        for(symbol in symbols)
            break;
        [self performSelector: @selector(presentResult:) withObject: symbol afterDelay: .001];
    }
    
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(50, 60, image.size.width/3.5, image.size.height/3.5);
    self.imageView.hidden = NO;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dataStr = [NSString stringWithFormat:@"%@\n",[df stringFromDate:[NSDate date]]];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Location"])
    {
        dataStr = [dataStr stringByAppendingString:[[NSUserDefaults standardUserDefaults] valueForKey:@"Location"]];
    }
    else
    {
        dataStr = [dataStr stringByAppendingString:@"暂无位置信息"];
    }
    
    UIImage *stringImage =[UIImage addText:image text:dataStr];
    UIImage *logoImage =[UIImage addImage:stringImage addMsakImage:[UIImage imageNamed:@"loginIcon"]];
    self.imageView.image = logoImage;
    
    
    
    //震动
    if (shake.selectedSegmentIndex)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    //声音
    SystemSoundID sound;
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Sound"],@"caf"];
    //NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:@"sq_alarm" ofType:@"caf"];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
    //NSURL *path = [[NSBundle mainBundle] URLForResource: @"Tock" withExtension:nil]; // 获取自定义的声音
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        if (error == kAudioServicesNoError) {//获取的声音的时候，出现错误
            AudioServicesPlaySystemSound(sound);
        }
    }
}

- (void) presentResult: (ZBarSymbol*)sym {
    if (sym) {
        NSString *tempStr = sym.data;
        if ([sym.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            tempStr = [NSString stringWithCString:[tempStr cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        NSLog(@"%@",tempStr);
        self.resultView.text = tempStr;
    }
    [reader removeFromSuperview];
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)light:(UISegmentedControl *)sender
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil)
    {
        NSLog(@"value changed");
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash])
        {
            [device lockForConfiguration:nil];
            if (sender.selectedSegmentIndex)
            {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                NSLog(@"on");
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                NSLog(@"off");
            } 
            [device unlockForConfiguration]; 
        } 
    }
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
