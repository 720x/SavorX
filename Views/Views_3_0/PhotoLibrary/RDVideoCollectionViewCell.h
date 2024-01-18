//
//  RDVideoCollectionViewCell.h
//  SavorX
//
//  Created by 郭春城 on 2017/7/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDVideoCollectionViewCell : UICollectionViewCell

- (void)configWithPHAsset:(PHAsset *)asset;

- (void)changeChooseStatus:(Boolean)choose;

@end
