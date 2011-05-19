//
//  NavBarController.h
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelfViewController.h"

@interface NavBarController : UIViewController {
    BOOL popoverShowing;
    ShelfViewController* shelf;
    UIPopoverController* popover;
    UIBarButtonItem* bookmarkButton;
}

@property (nonatomic,retain) ShelfViewController* shelf;

- (BOOL)isHidden;
- (void)setHidden:(BOOL)hidden withAnimation:(BOOL)animation;
- (void)willRotate;
- (void)resetFrameSize:(CGRect)frame;
- (void)fadeOut;
- (void)fadeIn;
- (void)togglePopover;
- (void)showPopover;
- (void)hidePopoverWithAnimation:(BOOL)anim;

@end
