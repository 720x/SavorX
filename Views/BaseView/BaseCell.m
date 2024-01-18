//
//  BaseCell.m
//  I500user
//
//  Created by lijiawei on 15/4/8.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.preservesSuperviewLayoutMargins = NO;
        // Initialization code
    }
    return self;
}

+(id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}

+(NSString*)cellIdentifier
{
    return NSStringFromClass(self);
}

+(id)loadFromCellStyle:(UITableViewCellStyle)cellStyle{
    
    return [[self alloc] initWithStyle:cellStyle reuseIdentifier:NSStringFromClass(self)];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.preservesSuperviewLayoutMargins = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (UINib *)cellNib {
    return [UINib nibWithNibName:[self cellIdentifier] bundle:[NSBundle mainBundle]];
}

+ (void)registerClassForTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:[self cellIdentifier]];
}

+ (void)registerNibForTableView:(UITableView *)tableView {
    [tableView registerNib:[self cellNib]  forCellReuseIdentifier:[self cellIdentifier]];
}


@end
