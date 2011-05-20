//
//  ShelfViewController.h
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shelf.h"

@class NavBarController;

@interface ShelfViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    Shelf* shelf;
    NavBarController* navBarController;
}

@property (nonatomic,retain) Shelf* shelf;
@property (nonatomic,retain) NavBarController* navBarController;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (id) initWithShelf:(Shelf*) newShelf andNavBar:(NavBarController*)navBar;

@end
