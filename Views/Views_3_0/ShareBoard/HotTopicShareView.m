//
//  HotTopicShareView.m
//  ShareBoard
//
//  Created by 王海朋 on 2017/7/4.
//  Copyright © 2017年 曹雪莹. All rights reserved.
//

#import "HotTopicShareView.h"
#import "ImageWithLabel.h"
#import "UMCustomSocialManager.h"
#import "RDLogStatisticsAPI.h"


#define ScreenWidth			[[UIScreen mainScreen] bounds].size.width
#define SELF_Height		    123
#define SHAREVIEW_BGCOLOR   [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1]
#define WINDOW_COLOR        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define LINE_HEIGHT         74
#define BUTTON_HEIGHT       30
#define LABEL_HEIGHT		30

@interface HotTopicShareView()

//	所有标题
@property (nonatomic, strong) NSArray  *shareBtnTitleArray;
//	所有图片
@property (nonatomic, strong) NSArray  *shareBtnImageArray;
//	所有类型
@property (nonatomic, strong) NSArray  *shareTypeArray;
//	整个底部分享面板的 backgroundView
@property (nonatomic, strong) UIView   *bgView;
//	分享面板取消按钮上部的 View
@property (nonatomic, strong) UIView   *topSheetView;
//	头部提示文字Label
@property (nonatomic, strong) UILabel  *proLbl;
@property (nonatomic, strong) UIView   *titleView;
//	头部提示文字
@property (nonatomic, copy)   NSString *protext;
//	所有的分享按钮
@property (nonatomic, copy) NSMutableArray *buttons;

@property(nonatomic ,strong) CreateWealthModel *model;

@property(nonatomic ,weak) UIViewController *VC;

@property (nonatomic, assign) NSInteger categoryID; //分类ID

@end

@implementation HotTopicShareView

- (instancetype)initWithModel:(CreateWealthModel *)model andVC:(UIViewController *)VC andCategoryID:(NSInteger )categoryID andY:(CGFloat)ory{
    
    self = [super init];
    if (self) {
        
        self.model = model;
        self.VC = VC;
        self.categoryID = categoryID;
        [self creatDatas];
        
        _protext = RDLocalizedString(@"RDString_ShareTo");
        self.frame = CGRectMake(0, ory, ScreenWidth, SELF_Height);
        //	背景，带灰度
        self.backgroundColor = UIColorFromRGB(0xf6f2ed);
        //	可点击
        self.userInteractionEnabled = YES;
        //	加载分享面板
        [self loadUIConfig];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, SELF_Height-8, ScreenWidth, 8)];
        lineView.backgroundColor = UIColorFromRGB(0xece6de);
        [self addSubview:lineView];
    }
    return self;
}

- (void)creatDatas{
    
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    
    NSMutableArray *titlearr = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *typeArr = [NSMutableArray arrayWithCapacity:5];
    
    if (hadInstalledWeixin) {
        [titlearr addObjectsFromArray:@[RDLocalizedString(@"RDString_WeChat"), RDLocalizedString(@"RDString_WeChatTimeLineAll")]];
        [imageArr addObjectsFromArray:@[@"WeChat",@"friends"]];
        [typeArr addObjectsFromArray:@[[NSNumber numberWithInteger:UMSocialPlatformType_WechatSession],[NSNumber numberWithInteger:UMSocialPlatformType_WechatTimeLine]]];
    }
    
    if (hadInstalledQQ) {
        [titlearr addObjectsFromArray:@[@"QQ"]];
        [imageArr addObjectsFromArray:@[@"qq"]];
        [typeArr addObjectsFromArray:@[[NSNumber numberWithInteger:UMSocialPlatformType_QQ]]];
    }
    
    [titlearr addObjectsFromArray:@[RDLocalizedString(@"RDString_WeiBo")]];
    [imageArr addObjectsFromArray:@[@"weibo"]];
    [typeArr addObject:[NSNumber numberWithInteger:UMSocialPlatformType_Sina]];
    
    _shareBtnTitleArray = titlearr;
    _shareBtnImageArray = imageArr;
    _shareTypeArray = typeArr;
}
/**
 加载自定义视图，按钮的tag依次为（200 + i）
 */
- (void)loadUIConfig {
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.topSheetView];
    [self.bgView addSubview:self.titleView];
    
    //	按钮
    for (NSInteger i = 0; i < self.shareBtnTitleArray.count; i++) {
        
        CGFloat x = self.bgView.bounds.size.width / 4 * ( i % 4);
        CGFloat y = LABEL_HEIGHT + (i / 4) * LINE_HEIGHT;
        CGFloat w = self.bgView.bounds.size.width / 4;
        CGFloat h = 70;
        
        CGRect frame =  CGRectMake(x, y, w, h);
        ImageWithLabel *item = [ImageWithLabel imageLabelWithFrame:frame Image:[UIImage imageNamed:self.shareBtnImageArray[i]] LabelText:@""];
        item.labelOffsetY = 0;
        UMSocialPlatformType type = [[self.shareTypeArray objectAtIndex:i] integerValue];
        item.tag = 200 + type;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
        [item addGestureRecognizer:tapGes];
        [self.topSheetView addSubview:item];
        
        [self.buttons addObject:item];
    }
}

#pragma mark ---分享按钮点击
- (void)itemClick:(UITapGestureRecognizer *)tapGes {
    
    NSString *categroyIDStr = [NSString stringWithFormat:@"%ld",self.categoryID];
    UMSocialPlatformType type = tapGes.view.tag - 200;
    switch (type) {
        case UMSocialPlatformType_WechatSession: {
            // 微信
            [RDLogStatisticsAPI RDShareLogModel:self.model categoryID:categroyIDStr volume:@"weixin"];
            [[UMCustomSocialManager defaultManager] sharedToPlatform:UMSocialPlatformType_WechatSession andController:self.VC withModel:self.model andUmKeyString:@"shortcut_share_weixin"];
            
        }
            break;
        case UMSocialPlatformType_WechatTimeLine: {
            // 微信朋友圈
            [RDLogStatisticsAPI RDShareLogModel:self.model categoryID:categroyIDStr volume:@"weixin_friends"];
            [[UMCustomSocialManager defaultManager] sharedToPlatform:UMSocialPlatformType_WechatTimeLine andController:self.VC withModel:self.model andUmKeyString:@"shortcut_share_weixin_friends"];
            
        }
            break;
        case UMSocialPlatformType_QQ: {
            // QQ
            [RDLogStatisticsAPI RDShareLogModel:self.model categoryID:categroyIDStr volume:@"qq_zone"];
            [[UMCustomSocialManager defaultManager] sharedToPlatform:UMSocialPlatformType_QQ andController:self.VC withModel:self.model andUmKeyString:@"shortcut_share_qq"];
            
        }
            break;
        case UMSocialPlatformType_Sina: {
            // 微博
            [RDLogStatisticsAPI RDShareLogModel:self.model categoryID:categroyIDStr volume:@"sina"];
            [[UMCustomSocialManager defaultManager] sharedToPlatform:UMSocialPlatformType_Sina andController:self.VC withModel:self.model andUmKeyString:@"shortcut_share_sina"];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark --------------------------- getter
- (UIView *)bgView {
    
    if (_bgView == nil) {
        
        _bgView = [[UIView alloc] init];
        //根据图标个数，计算行数，计算 backgroundView 的高度
        NSInteger index;
        if (_shareBtnTitleArray.count % 4 == 0) {
            
            index = _shareBtnTitleArray.count / 4;
            
        } else {
            
            index = _shareBtnTitleArray.count / 4 + 1;
        }
        _bgView.frame = CGRectMake(0, 0, ScreenWidth, BUTTON_HEIGHT + (_protext.length == 0 ? 0 : 30) + LINE_HEIGHT * index);
    }
    return _bgView;
}

- (UIView *)topSheetView {
    
    if (_topSheetView == nil) {
        
        _topSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame) - BUTTON_HEIGHT)];
        _topSheetView.backgroundColor = [UIColor clearColor];
    }
    return _topSheetView;
}

- (UIView *)titleView
{
    if (_titleView == nil) {
        
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), LABEL_HEIGHT)];
        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 14.5, ([UIScreen mainScreen].bounds.size.width - 60)/2, 1)];
        leftLine.backgroundColor = UIColorFromRGB(0xece6de);
        [_titleView addSubview:leftLine];
        
        _proLbl = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60)/2, 0, 60, LABEL_HEIGHT)];
        _proLbl.text = _protext;
        _proLbl.font = kPingFangRegular(15);
        _proLbl.textColor = UIColorFromRGB(0x922c3e);
        _proLbl.backgroundColor = [UIColor clearColor];
        _proLbl.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_proLbl];
        
        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60)/2 + 60, 14.5, ([UIScreen mainScreen].bounds.size.width - 60)/2, 1)];
        rightLine.backgroundColor = UIColorFromRGB(0xece6de);
        [_titleView addSubview:rightLine];
    }
    return _titleView;
}

- (NSArray *)buttons {
    
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:5];
    }
    return _buttons;
}

@end
