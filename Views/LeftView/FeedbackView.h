//
//  FeedbackView.h
//  SavorX
//
//  Created by lijiawei on 17/2/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseView.h"

@protocol FeedbackViewDelegate;

@interface FeedbackView : BaseView

@property(nonatomic,weak) id<FeedbackViewDelegate>delegate;

@end


@protocol FeedbackViewDelegate <NSObject>

-(void)feedbackView:(FeedbackView *)fView adviceText:(NSString*)advice phoneText:(NSString *)phone;

@end

