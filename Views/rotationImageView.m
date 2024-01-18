//
//  rotationImageView.m
//  SavorX
//
//  Created by 郭春城 on 16/9/13.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "rotationImageView.h"

@interface rotationImageView ()

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) CGFloat angle;

@end

@implementation rotationImageView

- (instancetype)init
{
    if (self = [super init]) {
        [self createRotation];
    }
    return self;
}

- (void)createRotation
{
    [self setImage:[UIImage imageNamed:@"play"]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(imageAnimating) userInfo:nil repeats:YES];
}

- (void)imageAnimating
{
    self.angle += 5;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.angle * (M_PI /180.0f));
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform = endAngle;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)startLayerAnimation
{
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stopLayerAnimation
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)shouldBeDealloc
{
    [self stopLayerAnimation];
    [self.timer invalidate];
    self.timer = nil;
}

@end
