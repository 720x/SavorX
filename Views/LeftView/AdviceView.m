//
//  AdviceView.m
//  SavorX
//
//  Created by lijiawei on 17/2/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AdviceView.h"

@interface AdviceView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;
@property (weak, nonatomic) IBOutlet UITextView *phoneTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation AdviceView

-(void)awakeFromNib{
    
    [super awakeFromNib];
//    _adviceTextView.delegate = self;
}

- (IBAction)submitAction:(id)sender {
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
