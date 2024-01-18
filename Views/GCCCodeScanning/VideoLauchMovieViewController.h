//
//  VideoLauchMovieViewController.h
//  SavorX
//
//  Created by 王海朋 on 17/3/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <AVKit/AVKit.h>

typedef void (^lauchClicked)(NSDictionary *parmDic);

// 视频lauch类
@interface VideoLauchMovieViewController : AVPlayerViewController

@property (nonatomic, copy)lauchClicked lauchClickedBack;

@property (nonatomic, strong) NSString *videoUrlString;

@end
