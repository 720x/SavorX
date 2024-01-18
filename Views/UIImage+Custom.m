//
//  UIImage+Custom.m
//  SavorX
//
//  Created by 郭春城 on 16/9/9.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "UIImage+Custom.h"

@implementation UIImage (Custom)

- (UIImage *)ScalingToSize:(CGSize)size
{
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = size.width;
    thumbnailRect.size.height = size.height;
    
    [self drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}

@end
