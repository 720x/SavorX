//
//  RDPrizeView.m
//  SavorX
//
//  Created by 王海朋 on 2017/5/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDPrizeView.h"
#import "GCCGetInfo.h"

@implementation RDPrizeView

- (instancetype)initWithFrame:(CGRect)frame withModel:(HSEggsResultModel *)model{
    
    if (self = [super initWithFrame:frame]) {
        
        [self creatSubViews:model];
    }
    return self;
}

- (void)creatSubViews:(HSEggsResultModel *)model{
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    bgImgView.image = [UIImage imageNamed:@"zjjg_bg"];
    [self addSubview:bgImgView];
    
    UILabel *congratueLab = [[UILabel alloc] init];
    congratueLab.font = [UIFont systemFontOfSize:22];
    congratueLab.textColor = UIColorFromRGB(0xfffaeb);
    congratueLab.backgroundColor = [UIColor clearColor];
    congratueLab.textAlignment = NSTextAlignmentCenter;
    congratueLab.text = RDLocalizedString(@"RDString_Congratue");
    [bgImgView addSubview:congratueLab];
    [congratueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 50));
        make.top.mas_equalTo(self.top).offset(5);
        make.centerX.equalTo(self);
    }];
    
    UILabel *phoneNameLab = [[UILabel alloc] init];
    phoneNameLab.font = [UIFont systemFontOfSize:14];
    phoneNameLab.textColor = UIColorFromRGB(0xe14d43);
    phoneNameLab.backgroundColor = [UIColor clearColor];
    phoneNameLab.textAlignment = NSTextAlignmentLeft;
    phoneNameLab.text = [NSString stringWithFormat:@"%@",[GCCGetInfo getIphoneName]];
    [bgImgView addSubview:phoneNameLab];
    CGFloat phoneNameLabWidth  = [Helper autoWidthWith:260];
    CGFloat phoneNameLabHeight  = [Helper autoHeightWith:20];
    NSUInteger distantToTopStr = 15;
    if (kMainBoundsWidth == 320) {
        distantToTopStr = 10;
    }
    [phoneNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(phoneNameLabWidth, phoneNameLabHeight));
        make.top.mas_equalTo(congratueLab.mas_bottom).offset(distantToTopStr);
        make.left.mas_equalTo(10);
    }];
    
    
    UIImageView *prizeLevelImg = [[UIImageView alloc] init];
    prizeLevelImg.contentMode = UIViewContentModeScaleAspectFit;
    [bgImgView addSubview:prizeLevelImg];
    [prizeLevelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(152, 36));
        make.center.equalTo(bgImgView);
    }];
    if (model.prize_level == 1) {
        prizeLevelImg.image = [UIImage imageNamed:@"yidj"];
        [SAVORXAPI postUMHandleWithContentId:@"game_page_result" key:@"game_page_result" value:@"prize_a"];
    }else if (model.prize_level == 2){
        prizeLevelImg.image = [UIImage imageNamed:@"erdj"];
        [SAVORXAPI postUMHandleWithContentId:@"game_page_result" key:@"game_page_result" value:@"prize_b"];
    }else if (model.prize_level == 3){
        prizeLevelImg.image = [UIImage imageNamed:@"sadj"];
        [SAVORXAPI postUMHandleWithContentId:@"game_page_result" key:@"game_page_result" value:@"prize_c"];
    }else{
        prizeLevelImg.image = [UIImage imageNamed:@"xxcy"];
        [SAVORXAPI postUMHandleWithContentId:@"game_page_result" key:@"game_page_result" value:@"prize_z"];
    }
    
    UILabel *getPriTimeLab = [[UILabel alloc] init];
    getPriTimeLab.font = [UIFont systemFontOfSize:12];
    if (kMainBoundsWidth == 320) {
        getPriTimeLab.font = [UIFont systemFontOfSize:11];
    }
    getPriTimeLab.textColor = UIColorFromRGB(0xe14d43);
    getPriTimeLab.backgroundColor = [UIColor clearColor];
    getPriTimeLab.textAlignment =  NSTextAlignmentCenter;
    NSString *timeStr;
    if (!isEmptyString(model.prize_time)) {
        NSTimeInterval time = [model.prize_time doubleValue] / 1000;
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        timeStr = [formatter stringFromDate:date];
    }else{
        timeStr = @"";
    }
    getPriTimeLab.text = [NSString stringWithFormat:@"(%@)",timeStr];
    [bgImgView addSubview:getPriTimeLab];
    CGFloat getPribHeight  = [Helper autoHeightWith:20];
    [getPriTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(prizeLevelImg.mas_bottom);
        make.height.mas_equalTo(getPribHeight);
    }];
    
    UILabel *prizeTimeLab = [[UILabel alloc] init];
    prizeTimeLab.font = [UIFont systemFontOfSize:14];
    if (kMainBoundsWidth == 320) {
        prizeTimeLab.font = [UIFont systemFontOfSize:11];
    }
    prizeTimeLab.textColor = UIColorFromRGB(0x676767);
    prizeTimeLab.backgroundColor = [UIColor clearColor];
    prizeTimeLab.textAlignment = NSTextAlignmentCenter;
    prizeTimeLab.text = RDLocalizedString(@"RDString_CongratueTimeAletPre");
    [bgImgView addSubview:prizeTimeLab];
    CGFloat prizeViewWidth  = [Helper autoWidthWith:294];
    CGFloat priAlertWidth  = [Helper autoWidthWith:260];
    CGFloat prTLabToLeft = [Helper autoHeightWith:(prizeViewWidth - priAlertWidth)/2];
    
    CGFloat prizeTimeWidth  = [Helper autoWidthWith:140];
    CGFloat prizeTimeHeight  = [Helper autoHeightWith:20];
    [prizeTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(prizeTimeWidth, prizeTimeHeight));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.left.mas_equalTo(bgImgView.mas_left).offset(prTLabToLeft);
    }];
    
    UILabel *alertLab = [[UILabel alloc] init];
    alertLab.font = [UIFont systemFontOfSize:14];
    if (kMainBoundsWidth == 320) {
        alertLab.font = [UIFont systemFontOfSize:11];
    }
    alertLab.textColor = UIColorFromRGB(0xe14d43);
    alertLab.backgroundColor = [UIColor clearColor];
    alertLab.textAlignment = NSTextAlignmentCenter;
    alertLab.text = RDLocalizedString(@"RDString_CongratueTimeAletSuf");
    [bgImgView addSubview:alertLab];
    CGFloat alertWidth  = [Helper autoWidthWith:120];
    CGFloat alertHeight  = [Helper autoHeightWith:20];
    [alertLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(alertWidth, alertHeight));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.left.mas_equalTo(prizeTimeLab.mas_right);
    }];
    
    UILabel *prizeFormLab = [[UILabel alloc] init];
    prizeFormLab.font = [UIFont systemFontOfSize:17];
    if (kMainBoundsWidth == 320) {
        prizeFormLab.font = [UIFont systemFontOfSize:15];
    }
    prizeFormLab.textColor = UIColorFromRGB(0x676767);
    prizeFormLab.backgroundColor = [UIColor clearColor];
    prizeFormLab.textAlignment = NSTextAlignmentCenter;
    prizeFormLab.text = RDLocalizedString(@"RDString_PrizeFrom");
    [bgImgView addSubview:prizeFormLab];
    CGFloat prizeFormToBottom  = [Helper autoHeightWith:4];
    [prizeFormLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(prizeViewWidth, 22));
        make.bottom.mas_equalTo(prizeTimeLab.mas_top).offset(- prizeFormToBottom);
        make.centerX.equalTo(self);
    }];
    
    if (model.win == 1) {
        congratueLab.text = RDLocalizedString(@"RDString_Congratue");
    }else if (model.win == 0){
        congratueLab.text = RDLocalizedString(@"RDString_NotCongratue");
        prizeFormLab.text = RDLocalizedString(@"RDString_GameShare");
        prizeTimeLab.text = @"";
        alertLab.text = @"";
        CGFloat prizeFormToBottom  = [Helper autoHeightWith:10];
        [prizeFormLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 40));
            make.bottom.mas_equalTo(self.mas_bottom).offset(- prizeFormToBottom);
            make.centerX.equalTo(self);
        }];
    }

}
@end
