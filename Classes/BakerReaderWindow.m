//
//  BakerReaderWindow.m
//  Baker
//
//  Created by David Haslem on 6/3/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import "BakerReaderWindow.h"
#import "RootViewController.h"


@implementation BakerReaderWindow

@synthesize bookViewActive;
@synthesize bookViewController;

- (id)initWithFrame:(CGRect)aRect{
    return [self initWithFrame:aRect andUseOpenBook:YES];
}

- (id)initWithFrame:(CGRect)frame andUseOpenBook:(BOOL)useOpenBook{
    self = [super initWithFrame:frame];
    self.bookViewActive = true;
    self.bookViewController = [[RootViewController alloc] initWithAvailableBook:useOpenBook];
    
    [self addSubview:[self.bookViewController view]];
    
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
        [self.bookViewController userDidTap:touch];
    }
    else{
        
    }
}
- (void)forwardScroll:(UITouch *)touch {
    if(self.bookViewActive){
        [self.bookViewController userDidScroll:touch];
    }
    else{
        
    }
}


@end
