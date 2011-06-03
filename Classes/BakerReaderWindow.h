//
//  BakerReaderWindow.h
//  Baker
//
//  Created by David Haslem on 6/3/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RootViewController, Shelf, NavBarController;

@interface BakerReaderWindow : UIWindow {
	BOOL scrolling, discardNextStatusBarToggle;
}
@property (nonatomic) BOOL bookViewActive;
@property (nonatomic, retain) RootViewController* bookViewController;
@property (nonatomic, retain) NavBarController* navBarController;
@property (nonatomic, retain) Shelf* shelf;

- (id)initWithFrame:(CGRect)frame andUseOpenBook:(BOOL)useOpenBook;
- (UIView*)currentTargetView;
- (void)forwardTap:(UITouch *)touch;
- (void)forwardScroll:(UITouch *)touch;

// Status/Nav bar
- (void)toggleStatusBar;
- (void)hideStatusBar;
- (void)hideStatusBarDiscardingToggle:(BOOL)discardToggle;


@end
