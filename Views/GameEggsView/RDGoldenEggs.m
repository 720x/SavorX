//
//  RDGoldenEggs.m
//  金蛋晃动效果
//
//  Created by 郭春城 on 2017/5/9.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDGoldenEggs.h"

@interface RDGoldenEggs ()

@property (nonatomic, assign) BOOL animationEnable;

@end

@implementation RDGoldenEggs

- (instancetype)initWithFrame:(CGRect)frame andEggImage:(UIImage *)image
{
    if (self = [super initWithFrame:frame]) {
        [self createGoldenEggsWith:image];
    }
    return self;
}

- (void)createGoldenEggsWith:(UIImage *)image
{
    CGFloat eggWidth = self.frame.size.width / 3;
    CGFloat eggHeight = self.frame.size.height;
    
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(eggWidth * i, 0, eggWidth, eggHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 10 + i;
        imageView.userInteractionEnabled = YES;
        [imageView setExclusiveTouch:YES];
        [imageView setImage:image];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eggDidBeClicked:)];
        tap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tap];
        
        [self addSubview:imageView];
    }
}

- (void)startShakeAnimation
{
    self.animationEnable = YES;
    
    //创建动画
    [self createAnimation];
}

- (void)stopShakeAnimation
{
    self.animationEnable = NO;
    
    //取消当前下一次动画创建的动作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(createAnimation) object:nil];
    
    //取消所有正在执行的动画
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView * imageView = [self viewWithTag:10 + i];
        [imageView.layer removeAllAnimations];
    }
}

- (void)createAnimation
{
    if (!self.animationEnable) {
        return;
    }
    
    CGFloat eggWidth = self.frame.size.width / 3;
    CGFloat eggHeight = self.frame.size.height;
    
    CGFloat duration = 1.f; //设置一个金蛋动画的时长
    
    for (NSInteger i = 0; i < 3; i++) {
        CABasicAnimation* shake1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //设置由起始位置向左偏移0.25弧度的动画
        shake1.fromValue = [NSNumber numberWithFloat:0];
        shake1.toValue = [NSNumber numberWithFloat:-0.25];
        shake1.duration = duration / 4;
        shake1.beginTime = 0 + i * duration;
        
        CABasicAnimation* shake2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //设置由向左偏移0.25弧度至向右偏移0.25弧度的动画
        shake2.fromValue = [NSNumber numberWithFloat:-0.25];
        shake2.toValue = [NSNumber numberWithFloat:+0.25];
        shake2.duration = duration / 2;
        shake2.beginTime = shake1.beginTime + shake1.duration;
        
        CABasicAnimation* shake3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //设置由向右偏移0.25弧度至起始位置的动画
        shake3.fromValue = [NSNumber numberWithFloat:+0.25];
        shake3.toValue = [NSNumber numberWithFloat:0];
        shake3.duration = duration / 4;
        shake3.beginTime = shake2.beginTime + shake2.duration;
        
        CAAnimationGroup * group = [CAAnimationGroup animation];
        //创建动画组，将以上动画进行组合
        group.animations = @[shake1, shake2, shake3];
        group.duration = shake3.beginTime + shake3.duration;
        group.repeatCount = 1;
        
        UIImageView * imageView = [self viewWithTag:10 + i];
        imageView.layer.anchorPoint = CGPointMake(0.5, 1);
        imageView.layer.position = CGPointMake(eggWidth * 0.5 + i * eggWidth, eggHeight);
        //为相应的视图添加动画
        [imageView.layer addAnimation:group forKey:@"com.eggs.animation"];
    }
    
    //当三组动画全部执行完毕的时候，进行下一次动画创建
    [self performSelector:@selector(createAnimation) withObject:nil afterDelay:duration * 3 + .5f];
}

- (void)eggDidBeClicked:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - 10;
    if (_delegate && [_delegate respondsToSelector:@selector(RDGoldenEggs:didSelectEggWithIndex:)]) {
        [_delegate RDGoldenEggs:self didSelectEggWithIndex:index];
    }
}

@end
