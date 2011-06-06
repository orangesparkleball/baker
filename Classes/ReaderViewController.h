//
//  ReaderViewController.h
//  Baker
//
//  Created by David Haslem on 6/6/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BakerReaderWindow, Shelf, RootViewController, ShelfViewController;


@interface ReaderViewController : UINavigationController {
    
}
@property (nonatomic, retain) BakerReaderWindow* readerWindow;
@property (nonatomic, retain) RootViewController* bookViewController;
@property (nonatomic, retain) ShelfViewController* shelfViewController;

@property (nonatomic, retain) Shelf* shelf;
- (id)initWithWindow:(BakerReaderWindow*) oldreaderWindow;
- (UIView*) currentTargetView;
- (void)userDidTap:(UITouch *)touch;
- (void)userDidScroll:(UITouch *)touch;
- (void)windowSetStatusBarTo:(BOOL)status;
- (BOOL)bookViewActive;
- (void)windowHidStatusBar;
- (void)extractBookAt:(NSString*)path;
@end
