//
//  PhotoEditTextView.h
//  SavorX
//
//  Created by 郭春城 on 17/2/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTextLabel.h"

typedef enum : NSUInteger {
    PhotoEditTextStyleTitle,
    PhotoEditTextStyleDetail,
    PhotoEditTextStyleDate
} PhotoEditTextStyle;

@protocol PhotoTextLabelDelegate <NSObject>

- (void)PhotoTextLabelDidEndEditWith:(NSString *)text andStyle:(PhotoEditTextStyle)style;

@end

@interface PhotoEditTextView : UIView

@property (nonatomic, assign) id<PhotoTextLabelDelegate> delegate;

- (void)showWithEditStyle:(PhotoEditTextStyle)style onView:(UIView *)view withText:(NSString *)str;

@end
