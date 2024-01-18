//
//  RDPhotoCollectionViewCell.m
//  SavorX
//
//  Created by 郭春城 on 2017/7/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDPhotoCollectionViewCell.h"

NSString * const RDPhotoLibraryChooseChangeNotification = @"RDPhotoLibraryChooseChangeNotification";
NSString * const RDPhotoLibraryAllChooseNotification = @"RDPhotoLibraryAllChooseNotification";

@interface RDPhotoCollectionViewCell ()

@property (nonatomic, strong) UIButton * selectButton;
@property (nonatomic, strong) UIImageView * bgImageView; //背景图

@property (nonatomic, strong) PHAsset * asset;
@property (nonatomic, copy) PhotoCollectionViewCellClickedBlock block;

@end

@implementation RDPhotoCollectionViewCell

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
        
        
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectButton setImage:[UIImage imageNamed:@"xuantu"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
        [self.selectButton addTarget:self action:@selector(selectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.selectButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        self.selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.selectButton setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 2)];
        [self.selectButton.imageView setContentMode:UIViewContentModeCenter];
        [self.contentView addSubview:self.selectButton];
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseStatusDidChange:) name:RDPhotoLibraryChooseChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allChooseWith:) name:RDPhotoLibraryAllChooseNotification object:nil];
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

- (void)allChooseWith:(NSNotification *)notifition
{
    NSDictionary * userInfo = notifition.userInfo;
    if (userInfo) {
        NSArray * array = [userInfo objectForKey:@"objects"];
        [self configSelectStatus:[array containsObject:self.asset]];
    }
}

- (void)selectButtonDidClicked:(UIButton *)button
{
    
    [UIView animateWithDuration:.1f animations:^{
        button.imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1f animations:^{
            button.imageView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
    
    button.selected = !button.isSelected;
    self.block(self.asset, button.isSelected);
}

- (void)configWithPHAsset:(PHAsset *)asset completionHandle:(PhotoCollectionViewCellClickedBlock)block
{
    self.asset = asset;
    self.block = block;
    if (asset) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CollectionViewCellSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                [self.bgImageView setImage:result];
            }else{
                [self.bgImageView setImage:[UIImage imageNamed:@"tpysc"]];
            }
        }];
    }
}

- (void)configSelectStatus:(BOOL)isSelect
{
    self.selectButton.selected = isSelect;
}

- (void)changeChooseStatus:(BOOL)isChoose
{
    if (isChoose) {
        self.selectButton.alpha = 1.0;
    }else{
        self.selectButton.alpha = 0.f;
        [self configSelectStatus:NO];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDPhotoLibraryChooseChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDPhotoLibraryAllChooseNotification object:nil];
}

@end
