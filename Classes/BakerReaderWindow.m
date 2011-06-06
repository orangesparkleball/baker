//
//  BakerReaderWindow.m
//  Baker
//
//  Created by David Haslem on 6/3/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import "BakerReaderWindow.h"
#import "Shelf.h"
#import "RootViewController.h"
#import "ReaderViewController.h"


@implementation BakerReaderWindow

@synthesize shelf;
@synthesize readerViewController;

- (id)initWithFrame:(CGRect)aRect{
    return [self initWithFrame:aRect andUseOpenBook:YES];
}

- (id)initWithFrame:(CGRect)frame andUseOpenBook:(BOOL)useOpenBook{
    self = [super initWithFrame:frame];
	discardNextStatusBarToggle = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.readerViewController = [[ReaderViewController alloc] initWithWindow:self];
    [self addSubview:[self.readerViewController view] ];
    
    [self hideStatusBar];
    
    return self;
}

- (void)sendEvent:(UIEvent *)event {
	// At the moment, all the events are propagated (by calling the sendEvent method
	// in the parent class) except single-finger multitaps.
	
	BOOL shouldCallParent = YES;
	UIView* target = [self currentTargetView];
	if (event.type == UIEventTypeTouches) {
		NSSet *touches = [event allTouches];		
		if (touches.count == 1) {
			UITouch *touch = touches.anyObject;
			
			if (touch.phase == UITouchPhaseBegan) {
				scrolling = NO;
			} else if (touch.phase == UITouchPhaseMoved) {
				scrolling = YES;
			}
			
			if (touch.tapCount > 1) {
				if (touch.phase == UITouchPhaseEnded && !scrolling) {
					// Touch is not the first of multiple subsequent touches
					NSLog(@"Multi Tap");
					[self performSelector:@selector(forwardTap:) withObject:touch];
				}
				shouldCallParent = NO;
			} else if ([touch.view isDescendantOfView:target] == YES) {
				if (scrolling) {
					NSLog(@"Scrolling");
					[self performSelector:@selector(forwardScroll:) withObject:touch];
				} else if (touch.phase == UITouchPhaseEnded) {
					// Touch was on the target view (or one of its descendants)
					// and a single tap has just been completed
					NSLog(@"Single Tap");
					[self performSelector:@selector(forwardTap:) withObject:touch];
				}
			}
		}
	}
	
	if (shouldCallParent) {
		[super sendEvent:event];
	}
}

- (UIView*)currentTargetView{
    return [self.readerViewController currentTargetView];
}


- (void)forwardTap:(UITouch *)touch {
    if(touch.tapCount >= 2) 
        [self toggleStatusBar];
    [self.readerViewController userDidTap:touch];
}
- (void)forwardScroll:(UITouch *)touch {
    NSLog(@"User did scroll");
    [self hideStatusBar];
    [self.readerViewController userDidScroll:touch];
}

- (void)toggleStatusBar {
	if (discardNextStatusBarToggle) {
		// do nothing, but reset the variable
		discardNextStatusBarToggle = NO;
	} else {
		NSLog(@"TOGGLE status bar");
		UIApplication *sharedApplication = [UIApplication sharedApplication];
        BOOL willHide = !sharedApplication.statusBarHidden;
		[sharedApplication setStatusBarHidden:willHide withAnimation:UIStatusBarAnimationSlide];
        [self.readerViewController windowSetStatusBarTo:willHide];
        //[self.navBarController setHidden:willHide withAnimation:YES];
	}
}


-(void)openBookAtPath:(NSString*)path{
    [self hideStatusBar];
    [self.readerViewController extractBookAt:path];
}

- (void)hideStatusBar {
	[self hideStatusBarDiscardingToggle:NO];
}

- (void)hideStatusBarDiscardingToggle:(BOOL)discardToggle {
	NSLog(@"HIDE status bar %@", (discardToggle ? @"discarding toggle" : @""));
	discardNextStatusBarToggle = discardToggle;
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.readerViewController windowHidStatusBar];
    //[navBarController setHidden:YES withAnimation:YES];
}


@end
