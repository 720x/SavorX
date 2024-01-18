//
//  RDKeyBoard.m
//  GCCAVplayer
//
//  Created by 郭春城 on 17/3/24.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDKeyBoard.h"

@implementation RDKeyBoard

- (instancetype)initWithHeight:(CGFloat)height inView:(UIView *)view
{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)]) {
        [self showInView:view];
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    CGFloat height = self.frame.size.height;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];;
    [self createKeyBoard];
}

- (void)createKeyBoard
{
    CGFloat height = self.frame.size.height / 4;
    
    NSArray * textArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @" ", @"0", @" "];
    float distance = [Helper autoWidthWith:110];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setBackgroundColor:[UIColor whiteColor]];
            button.titleLabel.font = kPingFangThin(29);
            [button setTitleColor:UIColorFromRGB(0xece6de) forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"anxiaxiaoguo"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(numberButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 101 + i * 3 + j;
            
            if (button.tag == 112) {
                [button setImage:[UIImage imageNamed:@"qingchu"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"qingchuanxia"] forState:UIControlStateHighlighted];
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
            }
            
            [self addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(height);
                make.top.mas_equalTo(height * (i % 4));
                
                if (j == 0) {
                    make.centerX.mas_equalTo(-distance);
                }else if (j == 1){
                    make.centerX.mas_equalTo(0);
                }else{
                    make.centerX.mas_equalTo(distance);
                }
                
            }];
            [button setTitle:[textArray objectAtIndex:i * 3 + j] forState:UIControlStateNormal];
        }
    }
    
//    for (int i = 1; i < 4; i++) {
//        UIView * line = [[UIView alloc] initWithFrame:CGRectZero];
//        [self addSubview:line];
//        line.backgroundColor = [UIColor grayColor];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//            make.height.mas_equalTo(.5f);
//            make.top.mas_equalTo(height * (i / 4.f));
//        }];
//    }
//    
//    for (int i = 0; i < 2; i++) {
//        UIView * line = [[UIView alloc] initWithFrame:CGRectZero];
//        [self addSubview:line];
//        line.backgroundColor = [UIColor grayColor];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
//            make.width.mas_equalTo(.5f);
//            make.left.mas_equalTo([UIScreen mainScreen].bounds.size.width * ((i + 1) / 3.f));
//        }];
//    }
}

- (void)numberButtonDidClicked:(UIButton *)button
{
    if (button.tag == 110) {
        return;
    }else if (button.tag == 112) {
        if ([_delegate respondsToSelector:@selector(RDKeyBoradViewDidClickedWith:isDelete:)]) {
            [_delegate RDKeyBoradViewDidClickedWith:@" " isDelete:YES];
        }
    }else if (button.tag == 111) {
        if ([_delegate respondsToSelector:@selector(RDKeyBoradViewDidClickedWith:isDelete:)]) {
            [_delegate RDKeyBoradViewDidClickedWith:@"0" isDelete:NO];
        }
    }else {
        if ([_delegate respondsToSelector:@selector(RDKeyBoradViewDidClickedWith:isDelete:)]) {
            [_delegate RDKeyBoradViewDidClickedWith:[NSString stringWithFormat:@"%ld", button.tag - 100] isDelete:NO];
        }
    }
}

- (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
