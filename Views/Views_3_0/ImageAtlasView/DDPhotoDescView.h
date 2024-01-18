//
//  DDPhotoDescView.h
//  DDNews
//
//  Created by Dvel on 16/4/20.
//  Copyright © 2016年 Dvel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPhotoDescView : UIView

- (instancetype)initWithDesc:(NSString *)desc index:(NSInteger)index totalCount:(NSInteger)totalCount;

- (void) reConfigTextValueWithText:(NSString *)textStr index:(NSInteger)index totalCount:(NSInteger)totalCount;

@end
