//
//  RDHammer.m
//  金蛋晃动效果
//
//  Created by 郭春城 on 2017/5/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDHammer.h"

@interface RDHammer ()

@property (nonatomic, strong) UIImageView * hammer;
@property (nonatomic, strong) UIImageView * shadow;
@property (nonatomic, assign) BOOL animationEnable;

@end

@implementation RDHammer

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createHammer];
    }
    return self;
}

- (void)createHammer
{
    self.hammer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.hammer setImage:[UIImage imageNamed:@"shuizi"]];
    self.hammer.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.hammer];
    
    self.shadow = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.frame.size.height - 55, self.frame.size.width / 2, 35)];
    [self.shadow setImage:[UIImage imageNamed:@"shuiji"]];
    self.shadow.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.shadow];
    self.shadow.layer.opacity = 0.f;
}

- (void)startShakeAnimation
{
    self.animationEnable = YES;
    
    [self.hammer.layer removeAllAnimations];
    [self.shadow.layer removeAllAnimations];
    
    //创建动画
    [self createAnimation];
}

- (void)stopShakeAnimation
{
    self.animationEnable = NO;
    
    //取消当前下一次动画创建的动作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(createAnimation) object:nil];
}

- (void)createAnimation
{
    if (!self.animationEnable) {
        return;
    }
    
    CGFloat duration = 0.6;
    
    CABasicAnimation* shake1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置由起始位置向左偏移0.25弧度的动画
    shake1.fromValue = [NSNumber numberWithFloat:0];
    shake1.toValue = [NSNumber numberWithFloat:-0.1];
    shake1.duration = duration / 6;
    shake1.beginTime = 0;
    
    CABasicAnimation* shake2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置由向左偏移0.25弧度至向右偏移0.25弧度的动画
    shake2.fromValue = [NSNumber numberWithFloat:-0.1];
    shake2.toValue = [NSNumber numberWithFloat:+0.25];
    shake2.duration = duration / 2;
    shake2.beginTime = shake1.beginTime + shake1.duration;
    
    CABasicAnimation* shake3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置由向右偏移0.25弧度至起始位置的动画
    shake3.fromValue = [NSNumber numberWithFloat:+0.25];
    shake3.toValue = [NSNumber numberWithFloat:0];
    shake3.duration = duration / 3;
    shake3.beginTime = shake2.beginTime + shake2.duration;
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    //创建动画组，将以上动画进行组合
    group.animations = @[shake1, shake2, shake3];
    group.duration = shake3.beginTime + shake3.duration;
    group.repeatCount = 2;
    [self.hammer.layer addAnimation:group forKey:@"com.hammer.animation"];
    self.hammer.layer.anchorPoint = CGPointMake(1, 1);
    self.hammer.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    
    CABasicAnimation* shake4 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //设置透明度由0.5到1的动画
    shake4.fromValue = [NSNumber numberWithFloat:0.5];
    shake4.toValue = [NSNumber numberWithFloat:1];
    shake4.duration = duration / 6;
    shake4.beginTime = 0;
    
    CABasicAnimation* shake5 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //设置透明度由1到0的动画
    shake5.fromValue = [NSNumber numberWithFloat:1];
    shake5.toValue = [NSNumber numberWithFloat:0];
    shake5.duration = duration / 2;
    shake5.beginTime = shake1.beginTime + shake1.duration;
    
    CABasicAnimation* shake6 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    //设置透明度由0到0.5的动画
    shake6.fromValue = [NSNumber numberWithFloat:0];
    shake6.toValue = [NSNumber numberWithFloat:0.5];
    shake6.duration = duration / 3;
    shake6.beginTime = shake2.beginTime + shake2.duration;
    
    CAAnimationGroup * group2 = [CAAnimationGroup animation];
    //创建动画组，将以上动画进行组合
    group2.animations = @[shake4, shake5, shake6];
    group2.duration = shake3.beginTime + shake3.duration;
    group2.repeatCount = 2;
    [self.shadow.layer addAnimation:group2 forKey:@"com.shadow.animation"];
    
    [self performSelector:@selector(createAnimation) withObject:nil afterDelay:duration * 2];
}

@end
