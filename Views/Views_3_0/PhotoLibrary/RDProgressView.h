//
//  RDProgressView.h
//  SavorX
//
//  Created by 郭春城 on 2017/7/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RDProgressViewDelegate <NSObject>

- (void)uploadVideoDidCancle;

@end

@interface RDProgressView : UIView

@property (nonatomic, assign) id<RDProgressViewDelegate> delegate;

- (void)setTitle:(NSString *)title;

- (void)show;

- (void)hidden;

@end
