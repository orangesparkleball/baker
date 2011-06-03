//
//  BakerReaderWindow.m
//  Baker
//
//  Created by David Haslem on 6/3/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import "BakerReaderWindow.h"
#import "Shelf.h"
#import "NavBarController.h"
#import "RootViewController.h"


@implementation BakerReaderWindow

@synthesize shelf;

@synthesize bookViewActive;
@synthesize bookViewController;
@synthesize navBarController;

- (id)initWithFrame:(CGRect)aRect{
    return [self initWithFrame:aRect andUseOpenBook:YES];
}

- (id)initWithFrame:(CGRect)frame andUseOpenBook:(BOOL)useOpenBook{
    self = [super initWithFrame:frame];
    
	discardNextStatusBarToggle = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    self.bookViewActive = true;
    self.bookViewController = [[RootViewController alloc] initWithAvailableBook:useOpenBook andReaderWindow:self];
    
    [self addSubview:[self.bookViewController view]];
    
    self.shelf = [[Shelf alloc] init];
    
    self.navBarController = [[NavBarController alloc] initWithShelf:self.shelf andReaderWindow:self];
    [self.navBarController setHidden:YES withAnimation:NO];
	[self addSubview:navBarController.view];
    
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
    if(self.bookViewActive){
        [self.bookViewController scrollView];
    }
    else{
        
    }
}


- (void)forwardTap:(UITouch *)touch {
    if(self.bookViewActive){
        if(touch.tapCount >= 2) 
            [self toggleStatusBar];
        [self.bookViewController userDidTap:touch];
    }
    else{
        
    }
}
- (void)forwardScroll:(UITouch *)touch {
    if(self.bookViewActive){
        NSLog(@"User did scroll");
        [self hideStatusBar];
        [self.bookViewController userDidScroll:touch];
    }
    else{
        
    }
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
        [self.bookViewController toggleIndexView];
        [self.navBarController setHidden:willHide withAnimation:YES];
	}
}

- (void)hideStatusBar {
	[self hideStatusBarDiscardingToggle:NO];
}

- (void)hideStatusBarDiscardingToggle:(BOOL)discardToggle {
	NSLog(@"HIDE status bar %@", (discardToggle ? @"discarding toggle" : @""));
	discardNextStatusBarToggle = discardToggle;
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.bookViewController hideIndexView];
    [navBarController setHidden:YES withAnimation:YES];
}


@end
