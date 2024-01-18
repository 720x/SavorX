//
//  SpecialTextCell.m
//  SavorX
//
//  Created by 郭春城 on 2017/8/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SpecialTextCell.h"

@interface SpecialTextCell ()

@end

@implementation SpecialTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.artTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 30, 0)];
    self.artTextLabel.backgroundColor = [UIColor clearColor];
    self.artTextLabel.font = kPingFangLight(15);
    self.artTextLabel.textColor = UIColorFromRGB(0x575757);
    self.artTextLabel.numberOfLines = 0;
    [self.contentView addSubview:self.artTextLabel];
    [self.artTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(- 15);
        make.height.mas_equalTo(22.5);
    }];
}

- (void)configWithText:(NSString *)text
{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSUInteger length = [text length];
    [attrString addAttribute:NSFontAttributeName value:kPingFangLight(15) range:NSMakeRange(0, length)];//设置所有的字体
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 30;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    style.lineBreakMode = NSLineBreakByWordWrapping;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [attrString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, length)];//字符间距 2pt
    self.artTextLabel.attributedText = attrString;
    
    // 计算富文本的高度
    CGFloat lab_h = [self.artTextLabel sizeThatFits:self.artTextLabel.bounds.size].height;
    
    [self.artTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lab_h);
    }];
    
//    CGFloat textHeight = [self getAttrHeightByWidth:kMainBoundsWidth - 30 title:text font:kPingFangLight(15)];
//    NSLog(@"---%f",textHeight);
    
    NSLog(@"%f",lab_h);
    
}

- (CGFloat)getAttrHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger length = [title length];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 30;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    style.lineBreakMode = NSLineBreakByWordWrapping;
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [attrString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, length)];//字符间距 2pt
    label.attributedText = attrString;
    CGFloat height = [label sizeThatFits:label.bounds.size].height;
    
    return height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
