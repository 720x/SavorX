//
//  LeftCell.m
//  SavorX
//
//  Created by lijiawei on 17/1/17.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "LeftCell.h"

@interface LeftCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *RightMoreImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightLabelWidth;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation LeftCell


-(void)fillCellTitle:(NSString *)title content:(NSString*)content{
    
    self.titleLabel.text = title;
    self.titleLabel.font = kPingFangLight(15);
    self.textLabel.textColor = UIColorFromRGB(0xece6de);
    
    self.contentLabel.font = kPingFangLight(14);
    self.contentLabel.textColor = UIColorFromRGB(0xece6de);
    
    if(content.length == 0){
        self.rightLabelWidth.constant = 0;
        self.rightImageWidth.constant = 8;
    }else{
        self.contentLabel.text = content;
        self.rightImageWidth.constant = 0;
        self.rightLabelWidth.constant = 60;
    }
    self.bottomLine.backgroundColor = UIColorFromRGB(0xb45a6a);
}

- (void)bottomLineHidden:(BOOL)hidden
{
    self.bottomLine.hidden = hidden;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
