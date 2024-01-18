//
//  BadView.h
//  SavorX
//
//  Created by 郭春城 on 16/9/10.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BadView;
@protocol BadViewDelegate <NSObject>

- (void)BadViewDidBeClicked:(BadView *)view;

@end


@interface BadView : UIView

@property (nonatomic, assign) id<BadViewDelegate> delegate;

- (instancetype)initBadNetWorkView;
- (instancetype)initBadServerView;

@end