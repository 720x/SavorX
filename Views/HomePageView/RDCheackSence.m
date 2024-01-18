
//
//  RDCheackSence.m
//  SavorX
//
//  Created by 郭春城 on 17/3/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDCheackSence.h"
#import "RDAlertView.h"
#import "GCCDLNA.h"
#import "BaseNavigationController.h"
#import "LGSideMenuController.h"
#import "WMPageController.h"
#import "HSConnectViewController.h"
#import "RDHomeStatusView.h"

@interface RDCheackSence ()

@property (nonatomic, strong) RDAlertView * alertView;

@end

@implementation RDCheackSence

- (void)dealloc
{
    [[GCCDLNA defaultManager] removeObserver:self forKeyPath:@"isSearch" context:nil];
}

- (void)startCheckSence
{
    if ([GCCDLNA defaultManager].isSearch) {
        [self applicationIsSearchSence];
    }
    
    [[GCCDLNA defaultManager] addObserver:self forKeyPath:@"isSearch" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)applicationIsSearchSence
{
    
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[LGSideMenuController class]]) {
        LGSideMenuController * side = (LGSideMenuController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        BaseNavigationController * baseNa = (BaseNavigationController *)side.rootViewController;
        if ([baseNa.topViewController isKindOfClass:[HSConnectViewController class]]){
            [baseNa popViewControllerAnimated:NO];
        }
    }
    
    self.alertView = [[RDAlertView alloc] initWithTitle:RDLocalizedString(@"RDString_Alert") message:[RDLocalizedString(@"RDString_CheackingSence") stringByAppendingString:@"...."]];
    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:RDLocalizedString(@"RDString_IKnewIt") handler:^{
        
    } bold:NO];
    [self.alertView addActions:@[action]];
    [self.alertView show];
}

- (void)applicationEndSearchSence
{
    if (self.alertView.superview) {
        [self.alertView removeFromSuperview];
        if ([GlobalData shared].scene == RDSceneHaveRDBox) {
            [[RDHomeStatusView defaultView] callQRcodeFromPlatform];
        }else{
            RDAlertView * alert = [[RDAlertView alloc] initWithTitle:RDLocalizedString(@"RDString_Alert") message:RDLocalizedString(@"RDString_NotFoundTV")];
            RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:RDLocalizedString(@"RDString_IKnewIt") handler:^{
                
            } bold:YES];
            [alert addActions:@[action]];
            [alert show];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isSearch"]) {
        
        if (![GCCDLNA defaultManager].isSearch) {
            [self applicationEndSearchSence];
        }
        
    }
}

@end
