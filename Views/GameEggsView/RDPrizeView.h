//
//  RDPrizeView.h
//  SavorX
//
//  Created by 王海朋 on 2017/5/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSEggsResultModel.h"

@class RDPrizeView;
@protocol RDPrizeViewDelegate<NSObject>

- (void)RDPrizeClose;

@end

@interface RDPrizeView : UIView

@property (nonatomic ,assign) id<RDPrizeViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame withModel:(HSEggsResultModel *)model;

@end
