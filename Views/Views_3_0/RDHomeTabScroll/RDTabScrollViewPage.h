//
//  RDTabScrollViewPage.h
//  小热点3.0
//
//  Created by 郭春城 on 2017/7/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RDTabScrollViewPageType_UPBIG,
    RDTabScrollViewPageType_DOWNBIG,
} RDTabScrollViewPageType;

@interface RDTabScrollViewPage : UIView

- (instancetype)initWithFrame:(CGRect)frame totalNumber:(NSInteger)total type:(RDTabScrollViewPageType)type index:(NSInteger)index;

// 用于图集
- (instancetype)initWithFrame:(CGRect)frame withTotalNumber:(NSInteger)total withType:(RDTabScrollViewPageType)type withIndex:(NSInteger)index;

- (void)resetIndex:(NSInteger)index total:(NSInteger)total;

@end
