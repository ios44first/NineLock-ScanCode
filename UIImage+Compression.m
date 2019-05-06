//
//  UIImage+Compression.m
//  space-time
//
//  Created by Mr.K on 13-12-11.
//  Copyright (c) 2013年 北京中云易通科技有限公司. All rights reserved.
//

#import "UIImage+Compression.h"

@implementation UIImage (Compression)
//A.传入的参数：1、生成图片的大小 2、压缩比 3、存放图片的路径
+ (void)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent toPath:(NSString *)thumbPath{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
//    [UIImage imageWithData:thumbImageData];
    [thumbImageData writeToFile:thumbPath atomically:NO];
}
+ (UIImage *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent imageNum:(NSInteger) num {
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"currentImage%d.jpg",num]];
//    [thumbImageData writeToFile:fullPath atomically:NO];
    
    NSLog(@"第%d thumbImageData.length = %d",num,thumbImageData.length/1000);
    return [UIImage imageWithData:thumbImageData];;

}

+ (UIImage *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGPoint thumbPoint = CGPointMake(0.0,0.0);
    CGFloat widthFactor = thumbSize.width / width;
    CGFloat heightFactor = thumbSize.height / height;
    if (widthFactor > heightFactor)  {
        scaleFactor = widthFactor;
    }
    else {
        scaleFactor = heightFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    if (widthFactor > heightFactor)
    {
        thumbPoint.y = (thumbSize.height - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor)
    {
        thumbPoint.x = (thumbSize.width - scaledWidth) * 0.5;
    }
    UIGraphicsBeginImageContext(thumbSize);
    CGRect thumbRect = CGRectZero;
    thumbRect.origin = thumbPoint;
    thumbRect.size.width  = scaledWidth;
    thumbRect.size.height = scaledHeight;
    [image drawInRect:thumbRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, percent);
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.jpg"];
    [thumbImageData writeToFile:fullPath atomically:NO];
    
    NSLog(@"thumbImageData.length = %d",thumbImageData.length);
    return [UIImage imageWithData:thumbImageData];;
}
//B.下面的这个方法适用于 对压缩后的图片的质量要求不高或者没有要求,因为这种方法只是压缩了图片的大小
+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *thumbImageData = UIImageJPEGRepresentation(scaledImage, 1);
    NSLog(@"第3 thumbImageData.length %d",thumbImageData.length/1000);
    return scaledImage;
}
//C.压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

/**
 加文字随意
 @param img 需要加文字的图片
 @param text1 文字描述
 @returns 加好文字的图片
 */
+(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    int w = img.size.width;
    int h = img.size.height;
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //create a graphic context with CGBitmapContextCreate
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
//    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
//    char* text = (char *)[text1 cStringUsingEncoding:NSUTF8StringEncoding];
//    CGContextSelectFont(context, "STHeitiSC-Medium", 18, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    CGContextSetRGBFillColor(context, 0, 255, 255, 0.8);
//    
//    NSLog(@"text1 = %@ \n text = %s",text1,text);
//    //位置调整
//    CGContextShowTextAtPoint(context, 5 , h-40, text, strlen(text));
//    
//    //Create image ref from the context
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];
    
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    CGSize sizeStr = [text1 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(w-10, INT16_MAX)];
    [[UIColor cyanColor] set];
    [text1 drawInRect:CGRectMake(5, h-sizeStr.height-5, w-10, sizeStr.height) withFont:[UIFont systemFontOfSize:15]];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

/**
 加图片水印
 @param img 需要加logo图片的图片
 @param logo logo图片
 @returns 加好logo的图片
 */
+(UIImage *)addImage:(UIImage *)img logoImage:(UIImage *)logo
{
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];//原图
    [logo drawInRect:CGRectMake(5, 5, logo.size.width, logo.size.height)];//logo
    //[logo drawAtPoint:CGPointMake(10, 50) blendMode:kCGBlendModeNormal alpha:0.5];//半透明
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
//    //get image width and height
//    int w = img.size.width;
//    int h = img.size.height;
//    int logoWidth = logo.size.width;
//    int logoHeight = logo.size.height;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //create a graphic context with CGBitmapContextCreate
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
//    CGContextDrawImage(context, CGRectMake(5, 5, logoWidth, logoHeight), [logo CGImage]);
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];
//    //  CGContextDrawImage(contextRef, CGRectMake(100, 50, 200, 80), [smallImg CGImage]);
}

/**
 加半透明水印
 @param useImage 需要加水印的图片
 @param addImage1 水印
 @returns 加好水印的图片
 */
+ (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage
{
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    //    [addImage1 drawInRect:CGRectMake(0, useImage.size.height-addImage1.size.height, addImage1.size.width, addImage1.size.height)];
    
    //四个参数为水印图片的位置
    [maskImage drawInRect:CGRectMake(5, 5, maskImage.size.width, maskImage.size.height) blendMode:kCGBlendModeNormal alpha:0.7];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
