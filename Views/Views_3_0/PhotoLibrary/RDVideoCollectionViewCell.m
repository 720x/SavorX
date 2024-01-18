//
//  RDVideoCollectionViewCell.m
//  SavorX
//
//  Created by 郭春城 on 2017/7/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDVideoCollectionViewCell.h"
#import "RDPhotoCollectionViewCell.h"

@interface RDVideoCollectionViewCell ()

@property (nonatomic, strong) UIImageView * bgImageView; //背景图
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * maskView; //蒙层

@end

@implementation RDVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bgImageView = [[UIImageView alloc] init];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(45);
        }];
        self.timeLabel.layer.cornerRadius = 10;
        self.timeLabel.layer.masksToBounds = YES;
        
        self.maskView = [[UIView alloc] init];
        self.maskView.backgroundColor = UIColorFromRGB(0x393536);
        [self.contentView addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseStatusDidChange:) name:RDPhotoLibraryChooseChangeNotification object:nil];
    }
    return self;
}

- (void)chooseStatusDidChange:(NSNotification *)notification
{
    NSDictionary * userInfo = notification.userInfo;
    if (userInfo) {
        BOOL isChoose = [[userInfo objectForKey:@"value"] boolValue];
        [self changeChooseStatus:isChoose];
    }
}

- (void)changeChooseStatus:(Boolean)choose
{
    if (choose) {
        [UIView animateWithDuration:.2f animations:^{
            self.maskView.alpha = .6f;
        }];
    }else{
        [UIView animateWithDuration:.2f animations:^{
            self.maskView.alpha = .0f;
        }];
    }
}

- (void)configWithPHAsset:(PHAsset *)asset
{
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CollectionViewCellSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [self.bgImageView setImage:result];
    }];
    
    long long minute = 0, second = 0;
    second = asset.duration;
    minute = second / 60;
    second = second % 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%.2lld'%.2lld\"", minute, second];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDPhotoLibraryChooseChangeNotification object:nil];
}

@end
