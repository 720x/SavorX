//
//  ImageRecomendViewCell.h
//  SavorX
//
//  Created by 王海朋 on 2017/8/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageRecomendViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^block)(CreateWealthModel * model);

- (void)configModelData:(NSMutableArray *)modelArr andIsPortrait:(BOOL)isPortrait;

- (void)addGestureForImage:(UIPanGestureRecognizer *)pan;
- (void)removeGestureForImage:(UIPanGestureRecognizer *)pan;

@end
