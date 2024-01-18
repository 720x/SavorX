//
//  RDDemandTableViewCell.h
//  SavorX
//
//  Created by 郭春城 on 2017/8/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RDDemandCellClicked) (BOOL isLeftClick, CreateWealthModel * model);

@interface RDDemandTableViewCell : UITableViewCell

@property (nonatomic, copy) RDDemandCellClicked clickHandel;

- (void)configWithInfo:(CreateWealthModel *)model;

@end
