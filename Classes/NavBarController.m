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
    
    navItem = [[UINavigationItem alloc] initWithTitle:@"Shelf"];
    [navBar pushNavigationItem:navItem animated:NO];
    
    navItem = [[UINavigationItem alloc] initWithTitle:@"Book"];
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

-(void)setNavTitle:(NSString*)title{
    [navItem setTitle:title];
}
- (void)setHidden:(BOOL)hidden withAnimation:(BOOL)animation andFade:(BOOL)fade{
    if (animation) {
        if(hidden){
            self.view.hidden = YES;
            [self fadeOut];
        }
        else{
            self.view.hidden = NO;
            if(fade) [self fadeIn];
            else [self slideIn];
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

- (void)setHidden:(BOOL)hidden withAnimation:(BOOL)animation {
    [self setHidden:hidden withAnimation:animation andFade:NO];
}

- (void)fadeOut {
    [UIView beginAnimations:@"fadeOutNavBar" context:nil]; {
        [UIView setAnimationDuration:0.1];
        
        self.view.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void)fadeIn {
    [UIView beginAnimations:@"fadeInNavBar" context:nil]; {
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:0.3];
        
        self.view.alpha = 1.0;
    }
    [UIView commitAnimations];
}

- (void)slideIn {
    CGRect original_frame = self.view.frame;
    CGRect frame = original_frame;
    frame.origin.y = original_frame.origin.y - 20;
    self.view.frame = frame;
    self.view.alpha = 0.0;
    [UIView beginAnimations:@"slideInNavBar" context:nil]; {
        [UIView setAnimationDuration:0.35];
        self.view.frame = original_frame;
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
    [self setHidden:hidden withAnimation:YES andFade:YES];
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

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item{
    if([item hidesBackButton]){
        NSLog(@"This is the shelf");
    }
    else{
        NSLog(@"Book was %@", [item title]);
    }
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item{
    
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    return !([[item title] isEqualToString:@"Shelf"]);
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    return YES;
}

@end
