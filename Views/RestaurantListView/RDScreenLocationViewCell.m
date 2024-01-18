//
//  RDScreenLocationViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/6/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDScreenLocationViewCell.h"

@implementation RDScreenLocationViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = UIColorFromRGB(0x222222);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"餐厅名";
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.width - 100, 16));
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(15);
    }];
    
    _distanceLabel = [[UILabel alloc]init];
    _distanceLabel.font = [UIFont systemFontOfSize:13];
    _distanceLabel.textColor = UIColorFromRGB(0x444444);
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    _distanceLabel.text = @"100m";
    [self addSubview:_distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.text = @"";
    _addressLabel.font = [UIFont systemFontOfSize:14];
    _addressLabel.textColor = UIColorFromRGB(0x444444);
    _addressLabel.numberOfLines = 2;
    [self addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 34));
        make.top.equalTo(_titleLabel.mas_bottom).offset(7);
        make.left.mas_equalTo(15);
    }];
}

- (void)configModelData:(RestaurantListModel *)model{
    
    self.titleLabel.text = model.name;
    
    NSString *distanceStr;
    if (model.cid == [GlobalData shared].hotelId) {
        distanceStr = RDLocalizedString(@"RDString_CurrenRestaurant");
    }else{
        distanceStr = [NSString stringWithFormat:@"%@",model.dis];
    }
    self.distanceLabel.text = distanceStr;
    
    NSString * detailStr = model.addr;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [detailStr boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30, 34) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [_addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, size.height));
    }];

    
    self.addressLabel.text = detailStr;
        
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

