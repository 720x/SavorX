//
//  RD_MJRefreshFooter.m
//  SavorX
//
//  Created by 郭春城 on 2017/8/17.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RD_MJRefreshFooter.h"

@implementation RD_MJRefreshFooter

- (void)prepare
{
    [super prepare];
    self.mj_h += 60;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    CGRect frame = self.bounds;
    frame.size.height -= 60;
    self.stateLabel.frame = frame;
}

@end
