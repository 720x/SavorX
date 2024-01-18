//  NoNetWorkView.m
//  TuanChe
//
//  Created by 家伟 李 on 14-6-26.
//  Copyright (c) 2014年 家伟 李. All rights reserved.
//

#import "NoNetWorkView.h"

@interface NoNetWorkView(){
    BOOL _isLastNoNetwork; //上次是否无网
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *touchScrrenLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@end
@implementation NoNetWorkView

#pragma ib method

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = VCBackgroundColor;
    _descLabel.textColor = UIColorFromRGB(0x595757);
    _descLabel.font = kPingFangLight(15);
}
- (IBAction)reloadBtnClicked:(id)sender
{

    if (_reloadDataBlock) {
        _reloadDataBlock();
    }else if(_delegate && [_delegate respondsToSelector:@selector(retryToGetData)]){
        [_delegate retryToGetData];
    }
}
#pragma mark public method

-(void)showInView:(UIView*)superView style:(NoNetWorkViewStyle)style
{
    if (!self.superview) {
        [superView addSubview:self];
        self.height = superView.height;
        self.width = superView.width;
    }
    if (style==NoNetWorkViewStyle_No_NetWork) {
        _flagImageView.image =[UIImage imageNamed:@"kong_wlyc"];
        _descLabel.text = RDLocalizedString(@"RDString_NetFailedWithNoNet");
        _touchScrrenLabel.text = @"";
    }else if(style==NoNetWorkViewStyle_Load_Fail){
        _flagImageView.image = [UIImage imageNamed:@"kong_wlyc"];

        _descLabel.text = RDLocalizedString(@"RDString_NetFailedWithNoNet");
        _touchScrrenLabel.text = @"";
    }
    
    //如果上次无网络，则闪烁文字
    if(_isLastNoNetwork){
        _descLabel.alpha = 0;
        _touchScrrenLabel.alpha = 0;
        [UIView animateWithDuration:.1 animations:^{
            _descLabel.alpha = 1.0;
            _touchScrrenLabel.alpha = 1.0;
        }];
    }
    _isLastNoNetwork = YES;
}
-(void)hide
{
    _isLastNoNetwork = NO;
    [self removeFromSuperview];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
