//
//  ImageRecomendViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/8/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ImageRecomendViewCell.h"
#import "ImageAtlasCollectViewCell.h"

@interface ImageRecomendViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *recoLabel;
@property (nonatomic, strong) UIView *lineViewOne;
@property (nonatomic, strong) UIView *lineViewTwo;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isPortrait;

@end

@implementation ImageRecomendViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
        self.dataSource = [NSMutableArray new];
    }
    return self;
}

- (void)creatSubViews{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(45, 0, 5, 0);
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[ImageAtlasCollectViewCell class] forCellWithReuseIdentifier:@"imgCell"];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64));
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(0);
    }];
    
    _recoLabel = [[UILabel alloc]init];
    _recoLabel.backgroundColor = [UIColor clearColor];
    _recoLabel.font = kPingFangLight(16);
    _recoLabel.textColor = UIColorFromRGB(0x922c3e);
    _recoLabel.textAlignment = NSTextAlignmentCenter;
    _recoLabel.text = RDLocalizedString(@"RDString_imgAtRecommend");
    [self.collectionView addSubview:_recoLabel];
    [_recoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70,45));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kMainBoundsWidth/2 - 35);
    }];
    
    _lineViewOne = [[UIView alloc] initWithFrame:CGRectZero];
    _lineViewOne.backgroundColor = UIColorFromRGB(0x922c3e);
    [self.collectionView addSubview:_lineViewOne];
    [_lineViewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth/2 - 100, 1));
        make.top.mas_equalTo(0 + 22);
        make.right.mas_equalTo(_recoLabel.mas_left).offset(- 10);
    }];
    
    _lineViewTwo = [[UIView alloc] initWithFrame:CGRectZero];
    _lineViewTwo.backgroundColor = UIColorFromRGB(0x922c3e);
    [self.collectionView addSubview:_lineViewTwo];
    [_lineViewTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth/2 - 100, 1));
        make.top.mas_equalTo(0 + 22);
        make.left.mas_equalTo(_recoLabel.mas_right).offset(10);
    }];
   
    [self addObserver];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orieChanged) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)configModelData:(NSMutableArray *)modelArr andIsPortrait:(BOOL)isPortrait{
    
    self.dataSource = modelArr;
    self.isPortrait = isPortrait;
    
}

#pragma mark - UICollectionView 代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageAtlasCollectViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    CreateWealthModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell configModelData:tmpModel andIsPortrait:self.isPortrait];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block) {
        self.block([self.dataSource objectAtIndex:indexPath.row]);
    }
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (self.isPortrait == YES) {
        width = (kMainBoundsWidth-5) / 2;
        height = (kMainBoundsHeight - 64 - 45 - 5 - 5 - 5) / 3;
    }else{
        width = (kMainBoundsWidth-10) / 3;
        height = (kMainBoundsHeight - 64 - 45 - 5 - 5 - 5) / 2;
    }
    return CGSizeMake(width, height);
}

#pragma mark - 屏幕方向发生变化
- (void)orieChanged
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        
        self.isPortrait = YES;
        
    }else if (orientation == UIInterfaceOrientationLandscapeLeft ||
              orientation == UIInterfaceOrientationLandscapeRight){
    
        self.isPortrait = NO;
    }
    
    [_recoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70,45));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(kMainBoundsWidth/2 - 35);
    }];
    
    [_lineViewOne mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth/2 - 100, 1));
        make.top.mas_equalTo(0 + 22);
        make.right.mas_equalTo(_recoLabel.mas_left).offset(- 10);
    }];
    
    [_lineViewTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth/2 - 100, 1));
        make.top.mas_equalTo(0 + 22);
        make.left.mas_equalTo(_recoLabel.mas_right).offset(10);
    }];
    
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64 -5));
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(0);
    }];
    self.collectionView.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
    [self.collectionView reloadData];
}

- (void)addGestureForImage:(UIPanGestureRecognizer *)pan
{
    [self.collectionView addGestureRecognizer:pan];
}

- (void)removeGestureForImage:(UIPanGestureRecognizer *)pan
{
    [self.collectionView removeGestureRecognizer:pan];
}

- (void)dealloc{
    
    [self removeObserver];
    
}

@end
