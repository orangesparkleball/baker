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
- (BOOL)currentBookAvailable{
    return [[NSFileManager defaultManager] fileExistsAtPath:currentBookPath];
}
- (BOOL)bundledBookAvailable{
    return [[NSFileManager defaultManager] fileExistsAtPath:bundledBookPath];
}
- (BOOL)bookAvailable{
    return [self currentBookAvailable] || [self bundledBookAvailable];
}
- (NSString *)openBookPath{
    if([self currentBookAvailable]){
        return currentBookPath;
    }
    else{
        return bundledBookPath;
    }
}
- (Book *) openBook{
    return [[[Book alloc] initBookFromPath:[self openBookPath]] autorelease];
}
- (Book *) bundledBook{
    return [[[Book alloc] initBookFromPath:[self bundledBookPath]] autorelease];
}
- (void) trashBook:(Book*)book{
    [[NSFileManager defaultManager] removeItemAtPath:[book bookPath] error:NULL];
}
- (BOOL)handleDownloadedBookAtPath:(NSString *)targetPath{
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
		NSLog(@"File create successfully! Path: %@", targetPath);
		
		NSString *destinationPath = self.currentBookPath;
		NSLog(@"Book destination path: %@", destinationPath);
		
		// If a "book" directory already exists remove it (quick solution, improvement needed) 
		if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath])
			[[NSFileManager defaultManager] removeItemAtPath:destinationPath error:NULL];
		
		[SSZipArchive unzipFileAtPath:targetPath toDestination:destinationPath];
		
		NSLog(@"Book successfully unzipped. Removing .hpub file");
		[[NSFileManager defaultManager] removeItemAtPath:targetPath error:NULL];
		return YES;
		
	} else {
	   // Do something if it was not possible to write the book file on the iPhone/iPad file system...
        return NO;
    } 
}
@end
