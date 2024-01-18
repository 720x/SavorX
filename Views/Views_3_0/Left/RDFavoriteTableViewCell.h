//
//  RDFavoriteTableViewCell.h
//  SavorX
//
//  Created by 郭春城 on 2017/7/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWealthModel.h"

@interface RDFavoriteTableViewCell : UITableViewCell

- (void)configWithModel:(CreateWealthModel *)model;

- (void)reConfigWithTimeStr:(NSString *)timeStr;

//- (void)reloadWithUcreateTime:(NSString *)ucreateTime;

- (void)setLineViewHidden:(BOOL)hidden;

@end
