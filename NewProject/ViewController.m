//
//  ViewController.m
//  NewProject
//
//  Created by mac on 14-7-30.
//  Copyright (c) 2014年 于建祥. All rights reserved.
//

#import "ViewController.h"
#import "RootViewController.h"
#import "ZBarViewController.h"
#import "ASIFormDataRequest.h"

@interface ViewController ()
{
    UITextView *resultView;
    UIImageView *resultImageView;
    
    ASIFormDataRequest *request;
    NSURL *url;
}
@end

@implementation ViewController

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
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBack"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainBack"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, IOS7?30:20, 320, 40)];
    title.text = @"扫描条形码/二维码";
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor blueColor];
    [self.view addSubview:title];
    
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton setTitle:@"条形码" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont systemFontOfSize:15];
    scanButton.backgroundColor = [UIColor blueColor];
    scanButton.frame = CGRectMake(20, IOS7?100:80, 80, 40);
    scanButton.layer.cornerRadius = 5;
    [scanButton addTarget:self action:@selector(scanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    UIButton * scanButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton2 setTitle:@"二维码" forState:UIControlStateNormal];
    [scanButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanButton2.titleLabel.font = [UIFont systemFontOfSize:15];
    scanButton2.backgroundColor = [UIColor blueColor];
    scanButton2.frame = CGRectMake(120, IOS7?100:80, 80, 40);
    scanButton2.layer.cornerRadius = 5;
    [scanButton2 addTarget:self action:@selector(scanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    scanButton2.tag = 1;
    [self.view addSubview:scanButton2];
    
    UIButton * scanButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton1 setTitle:@"iOS7扫描" forState:UIControlStateNormal];
    [scanButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanButton1.titleLabel.font = [UIFont systemFontOfSize:15];
    scanButton1.backgroundColor = [UIColor blueColor];
    scanButton1.frame = CGRectMake(220, IOS7?100:80, 80, 40);
    scanButton1.layer.cornerRadius = 5;
    [scanButton1 addTarget:self action:@selector(setupCamera7:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton1];
    
    resultView = [[UITextView alloc] initWithFrame:CGRectMake(40, IOS7?170:150, 240, ScreenHeight-(IOS7?180:160)-30)];
    resultView.editable = NO;
    resultView.text = @"扫描结果";
    resultView.textAlignment = NSTextAlignmentCenter;
    resultView.layer.cornerRadius = 5;
    resultView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    [self.view addSubview:resultView];
    
    resultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 60, 100, 100)];
    resultImageView.userInteractionEnabled = YES;
    resultImageView.hidden = YES;
    [resultView addSubview:resultImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImage:)];
    tap.numberOfTapsRequired = 1;
    [resultImageView addGestureRecognizer:tap];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(140, ScreenHeight-30, 140, 30)];
    name.textAlignment = NSTextAlignmentRight;
    name.backgroundColor = [UIColor clearColor];
    name.textColor = [UIColor blackColor];
    name.font = [UIFont systemFontOfSize:12];
    name.text = @"2014-07-30 ©于建祥";
    [self.view addSubview:name];
    
    UIButton * sound = [UIButton buttonWithType:UIButtonTypeCustom];
    [sound setTitle:@"iOS系统声音" forState:UIControlStateNormal];
    [sound setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    sound.titleLabel.font = [UIFont systemFontOfSize:13];
    sound.backgroundColor = [UIColor clearColor];
    sound.frame = CGRectMake(40, ScreenHeight-30, 100, 30);
    sound.tag = 1;
    [sound addTarget:self action:@selector(setupCamera7:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sound];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"begin_record" forKey:@"Sound"];
    [ud synchronize];
    
}

-(void)setupCamera7:(UIButton *)sender
{
    if (sender.tag)
    {
        RootViewController * rt = [[RootViewController alloc]init];
        [self presentViewController:rt animated:YES completion:nil];
    }
    else
    {
        if (IOS7)
        {
            RootViewController * rt = [[RootViewController alloc]init];
            rt.resultView = resultView;
            [self presentViewController:rt animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本低" message:@"此功能要求系统版本为iOS7.0及其以上才能使用。" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
}

- (void)scanBtnAction:(UIButton *)sender
{
    ZBarViewController * zbar = [[ZBarViewController alloc]init];
    zbar.resultView = resultView;
    zbar.imageView = resultImageView;
    zbar.isQR = sender.tag;
    [self presentViewController:zbar animated:YES completion:nil];
}

#pragma mark -- 上传相关

- (NSString *)writeImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fullPath = [docDir stringByAppendingString:@"/uploadFileQR.png"];
    NSData *tempData = UIImagePNGRepresentation(resultImageView.image);
    if ([tempData writeToFile:fullPath atomically:YES])
    {
        return fullPath;
    }
    else
        return nil;
}

- (void)uploadImage:(UIPanGestureRecognizer *)tap
{
    NSLog(@"%s",__func__);
    NSString *path = [self writeImage];
    if (path)
    {
        NSString* s=@"上传扫描后的图片";
        url=[NSURL URLWithString:@"http://10.2.145.59:8080/UploadFile/UploadImage"];
        request = [ASIFormDataRequest requestWithURL:url];
        
        // 字符串使用 GBK 编码，因为 servlet 只识别GBK
        NSStringEncoding enc=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacChineseSimp);
        [request setStringEncoding:enc];
        [request setPostValue:s forKey:@"title"];
        [request setFile:path forKey:@"attach"];
        
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(responseComplete)];
        [request setDidFailSelector:@selector(respnoseFailed)];
        [request startSynchronous];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存图片失败！" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}

-(void)responseComplete{
    
    // 请求响应结束，返回responseString
    
    NSString*responseString = [request responseString];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"返回结果" message:responseString delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

-(void)respnoseFailed{
    
    //请求响应失败，返回错误信息
    
    NSError *error = [request error];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"返回结果" message:[error description] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
}

#pragma mark -- locationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [locationManager stopUpdatingLocation];
    NSLog(@"newLocation.description: %@", newLocation.description);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];// 创建地理编码对象geocoder，通过该对象可以把坐标转换成为地理信息的描述。
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         NSLog(@"%@",array);
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSString *city = placemark.locality;
             for (NSString *key in placemark.addressDictionary.allKeys)
             {
                 NSLog(@"%@:%@",key,[placemark.addressDictionary valueForKey:key]);
             }
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             [ud setObject:[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] objectAtIndex:0] forKey:@"Location"];
             [ud setObject:@(newLocation.coordinate.latitude) forKey:@"LocationLatitude"];
             [ud setObject:@(newLocation.coordinate.longitude) forKey:@"LocationLongitude"];
             [ud synchronize];
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}


//-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [timer invalidate];
//    _line.frame = CGRectMake(30, 10, 220, 2);
//    num = 0;
//    upOrdown = NO;
//    [picker dismissViewControllerAnimated:YES completion:^{
//        [picker removeFromParentViewController];
//    }];
//}
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [timer invalidate];
//    _line.frame = CGRectMake(30, 10, 220, 2);
//    num = 0;
//    upOrdown = NO;
//    
//    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    //初始化
//    ZBarReaderController * read = [ZBarReaderController new];
//    //设置代理
//    read.readerDelegate = self;
//    CGImageRef cgImageRef = image.CGImage;
//    ZBarSymbol * symbol = nil;
//    id <NSFastEnumeration> results = [read scanImage:cgImageRef];
//    for (symbol in results)
//    {
//        break;
//    }
//    NSString * result;
//    if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
//        
//    {
//        result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
//    }
//    else
//    {
//        result = symbol.data;
//    }
//    
//    resultView.text = result;
//    NSLog(@"%@",result);
//    
//    [picker dismissViewControllerAnimated:YES completion:^{
//        [picker removeFromParentViewController];
//    }];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
