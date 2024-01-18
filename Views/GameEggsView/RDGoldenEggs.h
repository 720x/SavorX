//
//  RDGoldenEggs.h
//  金蛋晃动效果
//
//  Created by 郭春城 on 2017/5/9.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDGoldenEggs;
@protocol RDGoldenEggsDelegate <NSObject>

//当金蛋被点击的时候执行的代理回调
- (void)RDGoldenEggs:(RDGoldenEggs *)eggsView didSelectEggWithIndex:(NSInteger)index;

@end

@interface RDGoldenEggs : UIView

@property (nonatomic, assign) id<RDGoldenEggsDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andEggImage:(UIImage *)image;

//开始执行动画
- (void)startShakeAnimation;

//停止执行动画
- (void)stopShakeAnimation;

@end
