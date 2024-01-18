//
//  BaseView.h
//  Hands-Seller
//
//  Created by guobo on 14-4-18.
//  Copyright (c) 2014年 李 家伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

/**
 *  加载与类名相同名字的XIB文件
 *
 *  @return 返回一个视图对象
 */
+ (id)loadFromXib;

/**
 *  填充数据
 *
 *  @param object 数据对象
 */
- (void)fillViewWithObject:(id)object;

/**
 *  填充数据
 *
 *  @param data 数据对象
 */
- (void)viewLayoutWithData:(id)data;

/**
 *  返回视图的高度
 *
 *  @param object 数据对象
 *
 *  @return 视图高度
 */
+ (CGFloat)rowHeightForObject:(id)object;

/**
 *  根据填充的数据返回对应的尺寸和位置
 *
 *  @param object 数据对象
 *
 *  @return 视图的frame
 */
+ (CGRect)frameForObject:(id)object;

@end
