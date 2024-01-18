//
//  PhotoManyEditView.h
//  SavorX
//
//  Created by 郭春城 on 17/2/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseView.h"

@protocol PhotoManyEditViewDelegate <NSObject>

- (void)PhotoManyEditViewDidComposeImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail date:(NSString *)date;

@end

@interface PhotoManyEditView : BaseView

@property (nonatomic, assign) id<PhotoManyEditViewDelegate> delegate;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail date:(NSString *)date;

@end
