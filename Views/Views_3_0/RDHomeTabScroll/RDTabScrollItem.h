//
//  RDTabScrollItem.h
//  小热点切换
//
//  Created by 郭春城 on 2017/6/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"

@protocol RDTabScrollViewItemDelegate <NSObject>

- (void)RDTabScrollViewItemPhotoButtonDidClickedWithModel:(CreateWealthModel *)model index:(NSInteger)index;
- (void)RDTabScrollViewItemTVButtonDidClickedWithModel:(CreateWealthModel *)model index:(NSInteger)index;

@end

@interface RDTabScrollItem : UIView

@property (nonatomic, assign) id<RDTabScrollViewItemDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame info:(CreateWealthModel *)model index:(NSInteger)index total:(NSInteger)total;

- (void)configWithInfo:(CreateWealthModel *)model index:(NSInteger)index total:(NSInteger)total;

@end
