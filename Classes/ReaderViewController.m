//
//  ReaderViewController.m
//  Baker
//
//  Created by David Haslem on 6/6/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import "ReaderViewController.h"
#import "BakerReaderWindow.h"
#import "RootViewController.h"
#import "ShelfViewController.h"

@implementation ReaderViewController

@synthesize readerWindow;
@synthesize shelf;
@synthesize bookViewController;
@synthesize shelfViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithWindow:(BakerReaderWindow*) oldreaderWindow{
    self = [self initWithNibName:nil bundle:nil];
    if (self){
        self.readerWindow = oldreaderWindow;
        
        [self.navigationBar setBarStyle:UIBarStyleBlack];
        self.bookViewController = [[RootViewController alloc] initWithAvailableBook:YES andReaderWindow:oldreaderWindow];
        
        self.shelf = [[Shelf alloc] init];
        self.shelfViewController = [[ShelfViewController alloc] initWithShelf:self.shelf andReaderWindow:self.readerWindow];
        
        
        [self pushViewController:self.shelfViewController animated:NO];
        [self pushViewController:self.bookViewController animated:NO];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)bookViewActive{
    return ([self visibleViewController] == self.bookViewController);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (UIView*)currentTargetView{
    if([self bookViewActive]){
        [self.bookViewController scrollView];
    }
    else{
        
    }
}

- (void)userDidTap:(UITouch *)touch {
    if([self bookViewActive]){
        [self.bookViewController userDidTap:touch];
    }
    else{
        
    }

}
- (void)userDidScroll:(UITouch *)touch {
    if([self bookViewActive]){
        [self.bookViewController userDidScroll:touch];
    }
    else{
        
    }
    
}

- (void)windowSetStatusBarTo:(BOOL)status{
    [self.bookViewController toggleIndexView];
    [self setNavigationBarHidden:status animated:YES];
}
- (void)windowHidStatusBar{
    [self.bookViewController hideIndexView];
    [self setNavigationBarHidden:YES animated:YES];
}

- (void)extractBookAt:(NSString *)path{
    // eventually - hide popover if exists
    @try{
        [self pushViewController:bookViewController animated:YES];
    }
    @finally{
        [self.bookViewController performSelector:@selector(extractWithDialog:) withObject:path afterDelay:0.1];
    }
}
@end
