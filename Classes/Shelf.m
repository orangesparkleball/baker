//
//  Shelf.m
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import "Shelf.h"


@implementation Shelf
@synthesize currentBookPath;
@synthesize bookStoragePath;
@synthesize bundledBookPath;

- (id) init{
    self = [super init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    // Initialize paths for books
    self.currentBookPath = [documentsPath stringByAppendingPathComponent:@"book"];
    self.bookStoragePath = [documentsPath stringByAppendingPathComponent:@"book-storage"];
	self.bundledBookPath = [[NSBundle mainBundle] pathForResource:@"book" ofType:nil];
    
    return self;
}
@end
