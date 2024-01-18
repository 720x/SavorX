//
//  LeftCell.h
//  SavorX
//
//  Created by lijiawei on 17/1/17.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseCell.h"

@interface LeftCell : BaseCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void)fillCellTitle:(NSString *)title content:(NSString*)content;

- (void)bottomLineHidden:(BOOL)hidden;

@end
