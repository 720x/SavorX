//
//  ShowPhotoCollectionViewCell.m
//  SavorX
//
//  Created by 郭春城 on 16/8/9.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "ShowPhotoCollectionViewCell.h"

@implementation ShowPhotoCollectionViewCell

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
        make.edges.equalTo(self.contentView);
    }];
}

@end
