//
//  RDCellScrollView.h
//  小热点图片放大
//
//  Created by 郭春城 on 2017/6/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDCellScrollView : UIScrollView

@property (nonatomic, strong) UIImageView * photoImageView;

- (void)setImageWithURL:(NSURL *)url;

@end
