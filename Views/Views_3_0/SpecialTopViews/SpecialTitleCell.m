//
//  SpecialTitleCell.m
//  SavorX
//
//  Created by 郭春城 on 2017/8/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SpecialTitleCell.h"

@interface SpecialTitleCell ()

@property (nonatomic, strong) UILabel * artTitleLabel;

@end


@implementation SpecialTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.artTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 30, 0)];
    self.artTitleLabel.backgroundColor = [UIColor clearColor];
    self.artTitleLabel.font = kPingFangRegular(16);
    self.artTitleLabel.textColor = UIColorFromRGB(0x922c3e);
    self.artTitleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.artTitleLabel];
    [self.artTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [attrString addAttribute:NSFontAttributeName value:kPingFangLight(16) range:NSMakeRange(0, length)];//设置所有的字体
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 0;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.lineBreakMode = NSLineBreakByWordWrapping;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
//    [attrString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, length)];//字符间距 2pt
    self.artTitleLabel.attributedText = attrString;
    
    // 计算富文本的高度
    CGFloat lab_h = [self.artTitleLabel sizeThatFits:self.artTitleLabel.bounds.size].height;
    
    [self.artTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lab_h);
    }];

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
