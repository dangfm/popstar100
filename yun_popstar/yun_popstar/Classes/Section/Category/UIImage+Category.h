//
//  UIImage+Category.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YQImageCompressor-umbrella.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
    
};

@interface UIImage (Category)

/**  设置图片的渐变色(颜色->图片)
@param colors 渐变颜色数组  @param gradientType 渐变样式  @param imgSize 图片大小  @return 颜色->图片  */
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

/**
 修改图片大小
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;

+ (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode WithImageObject:(UIImage*)image;
// 视图截图
+ (UIImage *)snapshot:(UIView *)view scale:(float)scale;
// 生成gif图片
+(NSString*)creatGifWithImages:(NSArray*)images sec:(float)sec;
#pragma mark 合并图片（竖着合并，以第一张图片的宽度为主）
+ (UIImage *)combine:(UIImage *)oneImage otherImage:(UIImage * _Nullable)otherImage frame:(CGRect)frame;
/*
 *maxLengthKB 压缩到的大小
 *image 准备压缩的图片
 */
+(void)compressWithMaxLengthKB:(NSUInteger)maxLengthKB image:(UIImage *)image Block :(void (^)(NSData *imageData))block;
// 压缩gif图片
+ (NSData *)zipGIFWithData:(NSData *)data duration:(float)duration per:(float)per;
@end

NS_ASSUME_NONNULL_END
