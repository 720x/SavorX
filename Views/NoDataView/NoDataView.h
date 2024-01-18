//  NoDataView.h
//  TuanChe
//
//  Created by 家伟 李 on 14-6-26.
//  Copyright (c) 2014年 家伟 李. All rights reserved.
//


#import "BaseView.h"

@protocol NoDataViewDelegate;

typedef enum{
    kNoDataType_Default      = 0,
    kNoDataType_Favorite  = 1,
    kNoDataType_Notification = 2,
    kNoDataType_Praise       = 3,   //我的点赞
    KNoDataType_CreditCard   = 4,
    kNoDataType_SalesRecords = 5,  //销售记录
    kNoDataType_ConsumptionRecords = 6, //消费记录
    KNoDataType_MessageList = 7,   //消息列表
    KNoDataType_Me = 8,            //我的
    kNoDataType_FindSearch = 9,    //发现搜索
    kNoDataType_ReconmentFriend = 10,//推荐好友
    kNoDataType_NotFound = 11
}NODataType;

@interface NoDataView : BaseView
@property (nonatomic,weak) id<NoDataViewDelegate> delegate;



-(void)showNoDataViewController:(UIViewController *)viewController noDataType:(NODataType)type;
-(void)hide;

-(void)showNoDataView:(UIView*)superView noDataType:(NODataType)type;
-(void)showNoDataBelowView:(UIView*)view noDataType:(NODataType)type;
-(void)setContentViewFrame:(CGRect)rect;
-(void)setColor:(UIColor*)color;

-(void)showNoDataView:(UIView*)superView noDataString:(NSString *)noDataString;

@end

@protocol NoDataViewDelegate <NSObject>

-(void)retryToGetData;

@end
