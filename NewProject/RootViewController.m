
//
//  RootViewController.m
//  NewProject
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 于建祥. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
{
    UIButton *tempBut;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)playSound:(UIButton *)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:sender.titleLabel.text forKey:@"Sound"];
    [ud synchronize];
    
    SystemSoundID sound;
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",sender.titleLabel.text,@"caf"];
    if (path) {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
        if (error == kAudioServicesNoError) {//获取的声音的时候，出现错误
            AudioServicesPlaySystemSound(sound);
        }
    }
    
    if (sender != tempBut)
    {
        [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [tempBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tempBut = sender;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    if (!self.resultView)
    {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:scroll];
        
        NSArray *array = @[@"sms-received1",@"sms-received2",@"sms-received3",@"sms-received4",@"sms-received5",@"sms-received6",@"SentMessage",@"mail-sent",@"new-mail",@"dtmf-0",@"dtmf-1",@"dtmf-2",@"dtmf-3",@"dtmf-4",@"dtmf-5",@"dtmf-6",@"dtmf-7",@"dtmf-8",@"dtmf-9",@"dtmf-pound",@"dtmf-star",@"Voicemail",@"Tock",@"begin_record",@"begin_video_record",@"photoShutter",@"end_record",@"end_video_record",@"beep-beep",@"lock",@"shake",@"unlock",@"low_power",@"jbl_ambiguous",@"jbl_begin",@"jbl_cancel",@"jbl_confirm",@"jbl_no_match",@"alarm",@"sq_alarm",@"sq_beep-beep",@"sq_lock",@"sq_tock"];
        for (int i=0; i<array.count; i++)
        {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(70, 30+60*i, 200, 40);
            [but setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [but setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            but.layer.cornerRadius = 5;
            but.tag = i;
            [but addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:but];
            
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Sound"] isEqualToString:[array objectAtIndex:i]])
            {
                tempBut = but;
                [but setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
        }
        scroll.contentSize = CGSizeMake(320, 30+60*array.count);
        
    	UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanButton setTitle:@"<" forState:UIControlStateNormal];
        [scanButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        scanButton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        scanButton.layer.cornerRadius = 15;
        scanButton.frame = CGRectMake(10, 30, 30, 30);
        [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:scanButton];
    }
    else
    {
        UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanButton setTitle:@"返回" forState:UIControlStateNormal];
        [scanButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        scanButton.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        scanButton.layer.cornerRadius = 5;
        scanButton.frame = CGRectMake(100, 420, 120, 40);
        [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:scanButton];
        
        UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 40, 290, 50)];
        labIntroudction.backgroundColor = [UIColor clearColor];
        labIntroudction.textColor=[UIColor whiteColor];
        labIntroudction.textAlignment = NSTextAlignmentCenter;
        labIntroudction.text=@"将二维码图像置于矩形方框内";
        [self.view addSubview:labIntroudction];
        
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
        imageView.image = [UIImage imageNamed:@"pick_bg"];
        [self.view addSubview:imageView];
        
        upOrdown = NO;
        num =0;
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 110, 220, 2)];
        _line.image = [UIImage imageNamed:@"line.png"];
        [self.view addSubview:_line];
        
        
        [self setupCamera];
        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, 110+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([timer isValid]) {
            [timer invalidate];
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 二维码 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypePDF417Code];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = [[UIScreen mainScreen] bounds];
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    
    self.resultView.text = stringValue;
    for (UIView *vi in self.resultView.subviews)
    {
        if ([vi isKindOfClass:[UIImageView class]])
        {
            [vi removeFromSuperview];
        }
    }
    
   [self dismissViewControllerAnimated:YES completion:^
    {
        [timer invalidate];
        NSLog(@"%@",stringValue);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
