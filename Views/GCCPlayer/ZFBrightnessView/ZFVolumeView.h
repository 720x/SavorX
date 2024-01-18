//
//  ZFVolumeView.h
//  SavorX
//
//  Created by 郭春城 on 17/3/9.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFVolumeView : UIView

/** 调用单例记录播放状态是否锁定屏幕方向*/
@property (nonatomic, assign) BOOL     isLockScreen;
/** 是否允许横屏,来控制只有竖屏的状态*/
@property (nonatomic, assign) BOOL     isAllowLandscape;

+ (instancetype)sharedVolumeView;

- (void)changeVolume:(CGFloat)sound;

@end
