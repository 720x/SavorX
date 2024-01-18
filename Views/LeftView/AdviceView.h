//
//  AdviceView.h
//  SavorX
//
//  Created by lijiawei on 17/2/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseView.h"

@interface AdviceView : BaseView

@end


@protocol AdviceViewDelegate <NSObject>

-(void)adviceView:(AdviceView *)adviceView submitAction:(BOOL)isSelected;

@end
