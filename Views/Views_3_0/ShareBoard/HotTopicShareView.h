//
//  HotTopicShareView.h
//  ShareBoard
//
//  Created by 王海朋 on 2017/7/4.
//  Copyright © 2017年 曹雪莹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"

@interface HotTopicShareView : UIView

//	点击按钮block回调
@property (nonatomic,copy) void(^btnClick)(NSInteger);

/**
 *  初始化
 *
 *  @param titleArray 标题数组
 *  @param imageArray 图片数组(如果不需要的话传空数组(@[])进来)
 *
 *  @return ShareView
 */

- (instancetype)initWithModel:(CreateWealthModel *)model andVC:(UIViewController *)VC  andCategoryID:(NSInteger )categoryID andY:(CGFloat)ory;

@end
