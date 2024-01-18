//
//  PhotoManyCollectionViewCell.m
//  SavorX
//
//  Created by 郭春城 on 17/2/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "PhotoManyCollectionViewCell.h"

@interface PhotoManyCollectionViewCell ()

@property (nonatomic, strong) UIImageView * photoImage;

@property (nonatomic, strong) UIImage * realImage;
@property (nonatomic, strong) UIImage * currentImage;

@end

@implementation PhotoManyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createImageView];
    }
    return self;
}

- (void)createImageView
{
    self.photoImage = [[UIImageView alloc] init];
    self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.photoImage];
    
    [self.photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.center.mas_equalTo(0);
    }];
}

- (void)setCellRealImage:(UIImage *)image
{
    self.hasEdit = NO;
    self.currentImage = nil;
    self.realImage = image;
    [self.photoImage setImage:image];
}

- (void)setCellEditImage:(UIImage *)image
{
    self.hasEdit = YES;
    self.currentImage = image;
    [self.photoImage setImage:image];
}

- (UIImage *)getCellRealImage
{
    return self.realImage;
}

- (UIImage *)getCellEditImage
{
    return self.currentImage;
}

@end
