//
//  VideoGuidedTwoDimensionalCode.h
//  SavorX
//
//  Created by 王海朋 on 17/3/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseView.h"

typedef void(^ScreenProjectionSelectViewSelectBlock)(NSInteger selectIndex);

typedef enum _TTGState {
    FromScanGuide  = 0,
    FromDocumentGuide,
    FromLauchGuide
} FromGuide;

@interface VideoGuidedTwoDimensionalCode : BaseView

/**
 *  显示可选视图
 *
 *  @param items       数组，里面全是字符串
 *  @param selectBlock 回调block
 */
- (instancetype)showScreenProjectionTitle:(NSString *)guidType  fromStyle:(FromGuide)style block:(ScreenProjectionSelectViewSelectBlock)selectBlock;

@end
