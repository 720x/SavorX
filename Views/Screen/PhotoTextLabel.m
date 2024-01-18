//
//  PhotoTextLabel.m
//  SavorX
//
//  Created by 郭春城 on 17/2/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "PhotoTextLabel.h"

@interface PhotoTextLabel ()

@property (nonatomic, strong) CAShapeLayer * dashLayer;

@end

@implementation PhotoTextLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customSelf];
    }
    return self;
}

- (void)customSelf
{
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
    self.textAlignment = NSTextAlignmentCenter;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
}

- (void)layoutSubviews
{
    if (self.dashLayer) {
        [self.dashLayer removeFromSuperlayer];
    }
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = self.bounds;
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:3].CGPath;
    borderLayer.lineWidth = 1;
    //虚线边框
    borderLayer.lineDashPattern = @[@4, @4];
    
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:borderLayer];
    self.dashLayer = borderLayer;
}

@end
