//
//  NavBarController.m
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import "NavBarController.h"
#import "RootViewController.h"




@implementation NavBarController

@synthesize shelfViewController;
@synthesize rootViewController;
@synthesize shelf;

- (id) initWithShelf:(Shelf*) newShelf andRootView:(RootViewController*)rootView{
    self = [self initWithNibName:nil bundle:nil];
    self.shelf = newShelf;
    self.rootViewController = rootView;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        popoverShowing = NO;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    navBar.delegate = self;
    
    
    self.view = navBar;
    [self fadeOut];
    
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@"Baker"];
    bookmarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(togglePopover)];
    [navItem setRightBarButtonItem:bookmarkButton];
    [navBar pushNavigationItem:navItem animated:NO];
    [navBar release];
    
    self.shelfViewController = [[ShelfViewController alloc] initWithShelf:shelf
                                                                andNavBar:self];
    popover = [[UIPopoverController alloc] initWithContentViewController:self.shelfViewController];
    popover.popoverContentSize = CGSizeMake(300, 500);
    
}



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


- (BOOL)isHidden {
    return self.view.hidden;
}

- (void)setHidden:(BOOL)hidden withAnimation:(BOOL)animation {

    if (animation) {
        if(hidden){
            self.view.hidden = YES;
            [self fadeOut];
        }
        else{
            self.view.hidden = NO;
            [self fadeIn];
        }
    } else {
        if(hidden){
            self.view.hidden = YES;
            self.view.alpha = 0.0;
        }
        else{
            self.view.hidden = NO;
            self.view.alpha = 1.0;
        }
    }
    
}

- (void)fadeOut {
    [UIView beginAnimations:@"fadeOutIndexView" context:nil]; {
        [UIView setAnimationDuration:0.0];
        
        self.view.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void)fadeIn {
    [UIView beginAnimations:@"fadeInIndexView" context:nil]; {
        [UIView setAnimationDuration:0.2];
        
        self.view.alpha = 1.0;
    }
    [UIView commitAnimations];
}

- (void)willRotate {
    [self fadeOut];
    [self hidePopoverWithAnimation:NO];
}

- (void)resetFrameSize:(CGRect)frame {
    BOOL hidden = [self isHidden]; // cache hidden status before setting page size
    self.view.frame = frame;
    [self setHidden:hidden withAnimation:YES];
}

-(void)togglePopover{
    if(popoverShowing){
        [self hidePopoverWithAnimation:YES];
    }
    else{
        [self showPopover];
    }
}

-(void)showPopover{
    popoverShowing = YES;
    [popover presentPopoverFromBarButtonItem:bookmarkButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void)hidePopoverWithAnimation:(BOOL)anim{
    [popover dismissPopoverAnimated:anim];
    popoverShowing = NO;
}

-(void)openBookAtPath:(NSString*)path{
    [self hidePopoverWithAnimation:YES];
    [rootViewController hideStatusBar];
    [rootViewController extractWithDialog:path];
}

@end
