//
//  NavBarController.h
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavBarController : UIViewController {
    
}
- (BOOL)isHidden;
- (void)setHidden:(BOOL)hidden withAnimation:(BOOL)animation;
- (void)willRotate;
- (void)resetFrameSize:(CGRect)frame;
- (void)fadeOut;
- (void)fadeIn;

@end
