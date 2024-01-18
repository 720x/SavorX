//
//  RDCellScrollView.m
//  小热点图片放大
//
//  Created by 郭春城 on 2017/6/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDCellScrollView.h"
#import "UIImageView+WebCache.h"

@implementation RDCellScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.maximumZoomScale = 2.0f;
        self.minimumZoomScale = 1.0f;
    }
    return self;
}

- (void)setImageWithURL:(NSURL *)url
{
    self.maximumZoomScale = 1.0f;
    [self.photoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"zanwu"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGFloat scale = self.frame.size.width / self.frame.size.height;
        CGFloat imageScale = image.size.width / image.size.height;
        
        CGRect frame;
        if (imageScale > scale) {
            CGFloat width = self.frame.size.width;
            CGFloat height = self.frame.size.width / image.size.width * image.size.height;
            frame = CGRectMake(0, 0, width, height);
        }else{
            CGFloat height = self.frame.size.height;
            CGFloat width = self.frame.size.height / image.size.height * image.size.width;
            frame = CGRectMake(0, 0, width, height);
        }
        self.photoImageView.frame = frame;
        self.photoImageView.center = self.center;
        
        self.maximumZoomScale = 2.0f;
    }];
}

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoImageView.userInteractionEnabled = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_photoImageView];
    }
    return _photoImageView;
}

@end
