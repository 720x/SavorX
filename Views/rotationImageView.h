//
//  rotationImageView.h
//  SavorX
//
//  Created by 郭春城 on 16/9/13.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rotationImageView : UIImageView

- (void)startLayerAnimation; //开始动画
- (void)stopLayerAnimation; //停止动画
- (void)shouldBeDealloc; //应该被释放

@end
