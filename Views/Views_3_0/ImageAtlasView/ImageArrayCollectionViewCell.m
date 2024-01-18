//
//  ImageArrayCollectionViewCell.m
//  SavorX
//
//  Created by 郭春城 on 2017/8/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ImageArrayCollectionViewCell.h"

@interface ImageArrayCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer * pan;

@end

@implementation ImageArrayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createImageView];
    }
    return self;
}

- (void)createImageView
{
    self.scrollView = [[RDCellScrollView alloc] initWithFrame:self.frame];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    self.scrollView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[RDCellScrollView class]]) {
        RDCellScrollView * view = (RDCellScrollView *)scrollView;
        return view.photoImageView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[RDCellScrollView class]]) {
        RDCellScrollView * view = (RDCellScrollView *)scrollView;
        CGSize superSize = view.frame.size;
        CGPoint center = CGPointMake(superSize.width / 2, superSize.height / 2);
        CGSize size = view.photoImageView.frame.size;
        if (size.width > superSize.width) {
            center.x = size.width / 2;
        }
        if (size.height > superSize.height) {
            center.y = size.height / 2;
        }
        view.photoImageView.center = center;
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (self.scrollView.zoomScale <= 1.f) {
        
        self.isScale = NO;
        if (self.pan) {
            [self.scrollView addGestureRecognizer:self.pan];
        }
        
    }else{
        
        self.isScale = YES;
        if (self.pan) {
            [self.scrollView removeGestureRecognizer:self.pan];
        }
    }
}

- (void)addGestureForImage:(UIPanGestureRecognizer *)pan
{
    self.pan = pan;
    if (!self.isScale) {
        [self.scrollView addGestureRecognizer:pan];
    }
}

- (void)removeGestureForImage:(UIPanGestureRecognizer *)pan
{
    [self.scrollView removeGestureRecognizer:pan];
}

- (void)setImageWithURL:(NSURL *)url
{
    self.scrollView.zoomScale = 1.f;
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.contentOffset = CGPointZero;
    self.isScale = NO;
    [self.scrollView setImageWithURL:url];
}

@end
