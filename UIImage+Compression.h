//
//  UIImage+Compression.h
//  space-time
//
//  Created by Mr.K on 13-12-11.
//  Copyright (c) 2013年 北京中云易通科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compression)
+ (void)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath;
+ (UIImage *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent imageNum:(NSInteger) num;
+ (UIImage *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent;
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

+(UIImage *)addText:(UIImage *)img text:(NSString *)text1;
+(UIImage *)addImage:(UIImage *)img logoImage:(UIImage *)logo;
+(UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage;

@end
