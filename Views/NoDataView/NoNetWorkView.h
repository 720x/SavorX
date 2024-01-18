//  NoNetWorkView.h
//  TuanChe
//
//  Created by 家伟 李 on 14-6-26.
//  Copyright (c) 2014年 家伟 李. All rights reserved.
//

#import "BaseView.h"

typedef enum
{
    NoNetWorkViewStyle_No_NetWork=0,
    NoNetWorkViewStyle_Load_Fail
}NoNetWorkViewStyle;
@protocol NoNetWorkViewDelegate ;
@interface NoNetWorkView : BaseView

@property (weak,nonatomic) id<NoNetWorkViewDelegate> delegate;
@property (nonatomic, copy) dispatch_block_t reloadDataBlock;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

-(void)showInView:(UIView*)superView style:(NoNetWorkViewStyle)style;
-(void)hide;
@end

@protocol NoNetWorkViewDelegate <NSObject>

-(void)retryToGetData;

@end
