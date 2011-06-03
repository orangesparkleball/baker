//
//  BakerReaderWindow.h
//  Baker
//
//  Created by David Haslem on 6/3/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RootViewController;

@interface BakerReaderWindow : UIWindow {
	BOOL scrolling;
    BOOL bookViewActive;
    RootViewController* bookViewController;
}
@property (nonatomic) BOOL bookViewActive;
@property (nonatomic, retain) RootViewController* bookViewController;

- (id)initWithFrame:(CGRect)frame andUseOpenBook:(BOOL)useOpenBook;
- (UIView*)currentTargetView;
- (void)forwardTap:(UITouch *)touch;
- (void)forwardScroll:(UITouch *)touch;

@end
