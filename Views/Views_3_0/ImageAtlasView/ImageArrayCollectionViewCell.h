//
//  ImageArrayCollectionViewCell.h
//  SavorX
//
//  Created by 郭春城 on 2017/8/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDCellScrollView.h"

@interface ImageArrayCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) RDCellScrollView * scrollView;
@property (nonatomic, assign) BOOL isScale;

- (void)setImageWithURL:(NSURL *)url;

- (void)addGestureForImage:(UIPanGestureRecognizer *)pan;
- (void)removeGestureForImage:(UIPanGestureRecognizer *)pan;

@end
