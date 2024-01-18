//
//  RDHomeStatusView.h
//  SavorX
//
//  Created by 郭春城 on 2017/7/11.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RDHomeStatus_NoScene,
    RDHomeStatus_Normal,
    RDHomeStatus_Bind,
    RDHomeStatus_Photo,
    RDHomeStatus_Video,
    RDHomeStatus_File,
    RDHomeStatus_Demand
} RDHomeStatusType;

@interface RDHomeStatusView : UIView

@property (nonatomic, assign) RDHomeStatusType status;

+ (instancetype)defaultView;

- (void)startScreenWithViewController:(UIViewController *)viewController withStatus:(RDHomeStatusType)status;

- (void)stopScreenWithStatus:(RDHomeStatusType)type;

- (void)scanQRCode;

- (void)callQRcodeFromPlatform;

- (void)stopScreenWithEggGame;

@property (nonatomic, assign) BOOL isScreening; //是否正在投屏

@end
