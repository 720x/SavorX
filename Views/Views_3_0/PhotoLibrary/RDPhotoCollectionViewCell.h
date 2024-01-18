//
//  RDPhotoCollectionViewCell.h
//  SavorX
//
//  Created by 郭春城 on 2017/7/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

extern NSString * const RDPhotoLibraryChooseChangeNotification;
extern NSString * const RDPhotoLibraryAllChooseNotification;

typedef void (^PhotoCollectionViewCellClickedBlock)(PHAsset * asset, BOOL isSelect);
@interface RDPhotoCollectionViewCell : UICollectionViewCell

- (void)configWithPHAsset:(PHAsset *)asset completionHandle:(PhotoCollectionViewCellClickedBlock)block;

- (void)configSelectStatus:(BOOL)isSelect;

- (void)changeChooseStatus:(BOOL)isChoose;

@end
