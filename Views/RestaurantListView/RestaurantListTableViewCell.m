//
//  RestaurantListTableViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/5/23.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RestaurantListTableViewCell.h"

@implementation RestaurantListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 90));
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(15);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = UIColorFromRGB(0x222222);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"餐厅名";
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.width - 100, 35));
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
    }];
    
    _distanceLabel = [[UILabel alloc]init];
    _distanceLabel.font = [UIFont systemFontOfSize:13];
    _distanceLabel.textColor = UIColorFromRGB(0x444444);
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    _distanceLabel.text = @"100m";
    [_bgView addSubview:_distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 35));
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(_bgView.mas_right).offset(-10);
    }];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.text = @"";
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.textColor = UIColorFromRGB(0x444444);
    _addressLabel.numberOfLines = 2;
     [_bgView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 50, 34));
        make.top.mas_equalTo(_titleLabel.mas_bottom);
        make.left.mas_equalTo(10);
    }];
}

- (void)configModelData:(RestaurantListModel *)model{
    
    self.titleLabel.text = model.name;
    
    NSString *distanceStr;
    if (model.cid == [GlobalData shared].hotelId) {
        distanceStr = @"当前餐厅";
    }else{
        distanceStr = [NSString stringWithFormat:@"%@",model.dis];
    }
    self.distanceLabel.text = distanceStr;
    
    self.addressLabel.text = model.addr;
    
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
//    CGSize size = [model.addr boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 50, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    self.addressLabel.frame = CGRectMake(10, CGRectGetMaxY(_titleLabel.frame), size.width , size.height);
//    self.addressLabel.text = model.addr;
    
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
