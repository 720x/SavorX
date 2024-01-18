//
//  RDTabScrollViewPage.m
//  小热点3.0
//
//  Created by 郭春城 on 2017/7/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDTabScrollViewPage.h"
#import "UIView+LayerCurve.h"

@interface RDTabScrollViewPage ()

@property (nonatomic, assign) NSInteger currentNumber;
@property (nonatomic, assign) NSInteger totoalNumber;
@property (nonatomic, strong) UILabel * currentLabel;
@property (nonatomic, strong) UILabel * totalLabel;

@property (nonatomic, assign) RDTabScrollViewPageType type;
@property (nonatomic, assign) NSInteger index;

@end

@implementation RDTabScrollViewPage

- (instancetype)initWithFrame:(CGRect)frame totalNumber:(NSInteger)total type:(RDTabScrollViewPageType)type index:(NSInteger)index
{
    if (self = [super initWithFrame:frame]) {
        self.totoalNumber = total;
        self.type = type;
        self.index = index;
        [self createPageLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTotalNumber:(NSInteger)total withType:(RDTabScrollViewPageType)type withIndex:(NSInteger)index
{
    
    if (self = [super initWithFrame:frame]) {
        self.totoalNumber = total;
        self.type = type;
        self.index = index;
        [self createPageLabel];
        self.totalLabel.textColor = kThemeColor;
    }
    return self;
}

- (void)createPageLabel
{
    CGFloat width = self.frame.size.width / 2;
    CGFloat height = self.frame.size.height / 2;
    
    self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.currentLabel.text = [NSString stringWithFormat:@"%ld", self.index];
    self.currentLabel.textColor = kThemeColor;
    self.currentLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.currentLabel];
    
    self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - width, height, width, height)];
    self.totalLabel.textColor = [UIColor grayColor];
    self.totalLabel.text = [NSString stringWithFormat:@"%ld", self.totoalNumber];
    [self addSubview:self.totalLabel];
    
    if (self.type == RDTabScrollViewPageType_UPBIG) {
        self.currentLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13];
        self.totalLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:9];
    }else{
        self.currentLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:11];
        self.totalLabel.font = [UIFont fontWithName:@"STHeitiTC-Light" size:15];
    }
    
    CGPoint point1 = CGPointMake(self.frame.size.width / 2 + 5, 0);
    CGPoint point2 = CGPointMake(self.frame.size.width / 2 - 5, self.frame.size.height);
    [self layerSolidLinePoints:@[[NSValue valueWithCGPoint:point1], [NSValue valueWithCGPoint:point2]] Color:kThemeColor Width:.5f];
}

- (void)resetIndex:(NSInteger)index total:(NSInteger)total
{
    self.index = index;
    self.currentLabel.text = [NSString stringWithFormat:@"%ld", self.index];
    self.totoalNumber = total;
    self.totalLabel.text = [NSString stringWithFormat:@"%ld", self.totoalNumber];
}

@end
