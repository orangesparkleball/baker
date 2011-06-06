//
//  BakerReaderWindow.h
//  Baker
//
//  Created by David Haslem on 6/3/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RootViewController, Shelf, ReaderViewController;

@interface BakerReaderWindow : UIWindow {
	BOOL scrolling, discardNextStatusBarToggle;
}
@property (nonatomic, retain) ReaderViewController* readerViewController;
@property (nonatomic, retain) Shelf* shelf;

- (id)initWithFrame:(CGRect)frame andUseOpenBook:(BOOL)useOpenBook;
- (UIView*)currentTargetView;
- (void)forwardTap:(UITouch *)touch;
- (void)forwardScroll:(UITouch *)touch;

-(void)openBookAtPath:(NSString*)path;

// Status/Nav bar
- (void)toggleStatusBar;
- (void)hideStatusBar;
- (void)hideStatusBarDiscardingToggle:(BOOL)discardToggle;

@end
