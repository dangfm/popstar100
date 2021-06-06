//
//  UIImage+Category.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "UIImage+Category.h"
#import <CoreServices/UTCoreTypes.h>
@implementation UIImage (Category)


+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case GradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case GradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case GradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case GradientTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    UIGraphicsBeginImageContextWithOptions(newsize, NO, [UIScreen mainScreen].scale);
    // 创建一个bitmap的baicontext
    // 并把它设置成du为当前正在使用的context
    //UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode WithImageObject:(UIImage*)image
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [image drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

+ (UIImage *)snapshot:(UIView *)view scale:(float)scale{
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale); // [UIScreen mainScreen].scale
    //CGRect rec = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
//    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return theImage;
}

+(NSString*)creatGifWithImages:(NSArray*)images sec:(float)sec{
    //  图片 数组
    
    //创建gif文件
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucmentStr =[document objectAtIndex:0];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *textDic = [doucmentStr stringByAppendingString:@"/gif"];  //文件夹
    [filemanager createDirectoryAtPath:textDic withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [textDic stringByAppendingString:[NSString stringWithFormat:@"%.f.gif",[fn getTimestamp]]];
    NSLog(@"-----%@",path);   // GIF 的保存路径
    
    //配置gif属性
    CGImageDestinationRef destion;
    //    路径url，图片类型，图片数，
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);
    destion = CGImageDestinationCreateWithURL(url,kUTTypeGIF, images.count,NULL);
    
    //帧 时间间隔
    NSDictionary *frameDic = [NSDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:sec],(NSString*)kCGImagePropertyGIFDelayTime, nil] forKey:(NSString*)kCGImagePropertyGIFDelayTime];
    
    //git参数：颜色空间，颜色模式，深度，循环次数
    NSMutableDictionary *gifParmdict = [NSMutableDictionary dictionaryWithCapacity:2];
    [gifParmdict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
    [gifParmdict setObject:(NSString*)kCGImagePropertyColorModelRGB forKey:(NSString*)kCGImagePropertyColorModel];
    [gifParmdict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
    [gifParmdict setObject:[NSNumber numberWithInt:0] forKey:(NSString*)kCGImagePropertyGIFLoopCount];
    NSDictionary *gifProperty = [NSDictionary dictionaryWithObject:gifParmdict forKey:(NSString*)kCGImagePropertyGIFDictionary];
    
    for (UIImage *dimage in images) {
        // 遍历图片，附带GIF参数，生成GIF图
        //NSData *data = [dimage sd_imageData];
        
        CGImageDestinationAddImage(destion, dimage.CGImage, (__bridge CFDictionaryRef)frameDic);
    }
    // 添加GIF属性
    CGImageDestinationSetProperties(destion,(__bridge CFDictionaryRef)gifProperty);
    CGImageDestinationFinalize(destion);   // 最终确定 生成
    CFRelease(destion);  // 释放资源
    CFRelease(url);
    gifProperty = nil;
    frameDic = nil;
    filemanager = nil;
    document = nil;
    
    
    return path;
}


#pragma mark 合并图片（竖着合并，以第一张图片的宽度为主）
+ (UIImage *)combine:(UIImage *)oneImage otherImage:( UIImage * _Nullable)otherImage frame:(CGRect)frame{
    
    //计算画布大小
    CGFloat width = oneImage.size.width;
    CGFloat height = oneImage.size.height;
    CGSize resultSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(resultSize);
    
    //放第一个图片
    CGRect oneRect = CGRectMake(0, 0, resultSize.width, oneImage.size.height);
    [oneImage drawInRect:oneRect];
    
    //放第二个图片
    if (otherImage) {
        CGRect otherRect = frame;
        [otherImage drawInRect:otherRect];
    }
    
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

/*
 *maxLengthKB 压缩到的大小
 *image 准备压缩的图片
 */
+(void)compressWithMaxLengthKB:(NSUInteger)maxLengthKB image:(UIImage *)image Block :(void (^)(NSData *imageData))block{
    if (maxLengthKB <= 0 || [image isKindOfClass:[NSNull class]] || image == nil) block(nil);
    
    maxLengthKB = maxLengthKB*1024;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CGFloat compression = 1;
        NSData *data = UIImageJPEGRepresentation(image, compression);
        NSLog(@"初始 : %ld KB",data.length/1024);
        if (data.length < maxLengthKB){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"压缩完成： %zd kb", data.length/1024);
                block(data);
            });
            return;
        }
        
        //质量压缩
        CGFloat scale = 1;
        CGFloat lastLength=0;
        for (int i = 0; i < 7; ++i) {
            compression = scale / 2;
            data = UIImageJPEGRepresentation(image, compression);
            NSLog(@"质量压缩中： %ld KB", data.length / 1024);
            if (i>0) {
                if (data.length>0.95*lastLength) break;//当前压缩后大小和上一次进行对比，如果大小变化不大就退出循环
                if (data.length < maxLengthKB) break;//当前压缩后大小和目标大小进行对比，小于则退出循环
            }
            scale = compression;
            lastLength = data.length;
            
        }
        NSLog(@"压缩图片质量后: %ld KB", data.length / 1024);
        if (data.length < maxLengthKB){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"压缩完成： %zd kb", data.length/1024);
                block(data);
            });
            return;
        }
        
        //大小压缩
        UIImage *resultImage = [UIImage imageWithData:data];
        NSUInteger lastDataLength = 0;
        while (data.length > maxLengthKB && data.length != lastDataLength) {
            lastDataLength = data.length;
            CGFloat ratio = (CGFloat)maxLengthKB / data.length;
            NSLog(@"Ratio = %.1f", ratio);
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
            UIGraphicsBeginImageContext(size);
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            data = UIImageJPEGRepresentation(resultImage, compression);
            NSLog(@"绘图压缩中： %ld KB", data.length / 1024);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"压缩完成： %ld kb", data.length/1024);
            block(data);
        });return;
    });
    
}

+ (NSData *)zipGIFWithData:(NSData *)data duration:(float)duration per:(float)per{
    if (!data) {
    return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage = nil;
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval durations = 0.0f;
    for (size_t i = 0; i < count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        durations += duration;
        UIImage *ima = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        NSData *data = [ima sd_imageData];
        ima = [UIImage compressToByte:ima maxLength:data.length*per];
        [images addObject:ima];
        CGImageRelease(image);
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
    }
    animatedImage = [UIImage animatedImageWithImages:images duration:durations];
    CFRelease(source);
    return [animatedImage sd_imageData];
}

+(UIImage *)compressToByte:(UIImage *)image maxLength:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;

    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;

    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;

        CGSize size = image.size;
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    resultImage = [UIImage imageWithData:data];
    return resultImage;
}


@end
