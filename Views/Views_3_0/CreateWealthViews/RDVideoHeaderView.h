//
//  RDVideoHeaderView.h
//  SavorX
//
//  Created by 郭春城 on 2017/7/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"

@interface RDVideoHeaderView : UIView

- (void)reloadWithModel:(CreateWealthModel *)model;

- (void)needRecommand:(BOOL)recommand;

@end
