//
//  PhotoHandleView.m
//  SavorX
//
//  Created by 郭春城 on 17/2/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "PhotoHandleView.h"

@interface PhotoHandleView ()

@property (nonatomic, strong) UIView * toolView;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * label;

@end

@implementation PhotoHandleView

- (instancetype)initWithImage:(UIImage *)image andTitile:(NSString *)title
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 66, 66)]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
        self.layer.cornerRadius = 33;
        self.layer.masksToBounds = YES;
        [self.imageView setImage:image];
        self.label.text = title;
    }
    return self;
}

- (void)rotateImage
{
    
}

- (UIView *)toolView
{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _toolView.center = self.center;
        _toolView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        _toolView.layer.cornerRadius = 30;
        [self addSubview:_toolView];
    }
    return _toolView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 23)];
        _imageView.center = CGPointMake(30, 19);
        [self.toolView addSubview:self.imageView];
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 60, 30)];
        _label.textColor = FontColor;
        _label.font = [UIFont systemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.userInteractionEnabled = YES;
        [self.toolView addSubview:_label];
    }
    return _label;
}

@end
