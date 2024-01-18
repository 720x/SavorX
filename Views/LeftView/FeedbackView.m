//
//  FeedbackView.m
//  SavorX
//
//  Created by lijiawei on 17/2/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "FeedbackView.h"
#import "HSSubmitFeedbackRequest.h"

@interface FeedbackView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (nonatomic, assign) BOOL hasAdvice; //用户是否输入了意见
@property (weak, nonatomic) IBOutlet UILabel *pLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;

@end

@implementation FeedbackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.adviceTextView.delegate = self;
    [self.submitButton setBackgroundColor:kThemeColor];
    [self.submitButton setTitleColor:UIColorFromRGB(0xede6de) forState:UIControlStateNormal];
    self.numLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.phoneTextField.placeholder = RDLocalizedString(@"RDString_AdvicePhone");
    self.pLabel.text = RDLocalizedString(@"RDString_AdviceP");
    self.titleLabel.text = [NSString stringWithFormat:@"    %@",RDLocalizedString(@"RDString_AdviceTitle")];
    self.connectLabel.text = [NSString stringWithFormat:@"    %@",RDLocalizedString(@"RDString_ConnectTitle")];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [self.pLabel setHidden:NO];
    }else{
        [self.pLabel setHidden:YES];
    }
    if (textView.text.length > 200) {
        textView.text = [textView.text substringToIndex:200];
        [MBProgressHUD showTextHUDwithTitle:RDLocalizedString(@"RDString_maxInput")];
    }
    self.numLabel.text = [NSString stringWithFormat:@"%ld/200", textView.text.length];
}


- (IBAction)submitAction:(id)sender {
    
    if(_delegate && [_delegate respondsToSelector:@selector(feedbackView:adviceText:phoneText:)])
    {
        [_delegate feedbackView:self adviceText:_adviceTextView.text phoneText:_phoneTextField.text];
    }
 
}

//若是4，4s用户，为保证绑定页的显示不影响用户操作，对键盘的收起作特定处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.adviceTextView isFirstResponder]) {
        [self.adviceTextView resignFirstResponder];
    }else if ([self.phoneTextField isFirstResponder]){
        [self.phoneTextField resignFirstResponder];
    }
}

@end
