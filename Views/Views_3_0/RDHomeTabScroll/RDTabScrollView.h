//
//  RDTabScrollView.h
//  小热点切换
//
//  Created by 郭春城 on 2017/6/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"

@protocol RDTabScrollViewDelegate <NSObject>

- (void)RDTabScrollViewPhotoButtonDidClickedWithModel:(CreateWealthModel *)model index:(NSInteger)index;
- (void)RDTabScrollViewTVButtonDidClickedWithModel:(CreateWealthModel *)model index:(NSInteger)index;
- (void)RDTabScrollViewDidScrollToIndex:(NSInteger)index;

@end

@interface RDTabScrollView : UIView

@property (nonatomic, assign) id<RDTabScrollViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)array;

//- (void)reloadWith:(NSArray *)array;

@end
