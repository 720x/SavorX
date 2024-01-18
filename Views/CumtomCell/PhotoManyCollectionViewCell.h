//
//  PhotoManyCollectionViewCell.h
//  SavorX
//
//  Created by 郭春城 on 17/2/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoManyCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL hasEdit;
@property (nonatomic, assign) NSInteger Orientation; //当前旋转的方向

@property (nonatomic, copy) NSString * firstText; //第一行文字
@property (nonatomic, copy) NSString * secondText; //第二行文字
@property (nonatomic, copy) NSString * thirdText; //第三行文字

- (void)setCellRealImage:(UIImage *)image; //设置原图
- (void)setCellEditImage:(UIImage *)image; //设置被添加文字的图片

- (UIImage *)getCellRealImage; //获取原图
- (UIImage *)getCellEditImage; //获取被添加文字的图片

@end
