//
//  Shelf.m
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import "Shelf.h"
#import "SSZipArchive.h"
#import "Book.h"


@implementation Shelf
@synthesize currentBookPath;
@synthesize bookStoragePath;
@synthesize bundledBookPath;

- (id) init{
    self = [super init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    // Initialize paths for books
    self.currentBookPath = [documentsPath stringByAppendingPathComponent:@".book"];
    self.bookStoragePath = documentsPath;
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
- (NSString*)handleDownloadedBookAtPath:(NSString *)targetPath{
    NSFileManager* NSFm = [NSFileManager defaultManager];
    NSString *storagePath = [self.bookStoragePath stringByAppendingPathComponent:[targetPath lastPathComponent]];
    if ([NSFm fileExistsAtPath:targetPath]) {
		NSLog(@"File create successfully! Path: %@", targetPath);
		
		NSString *destinationPath = self.currentBookPath;
		NSLog(@"Book destination path: %@", destinationPath);
		
		// If a "book" directory already exists remove it (quick solution, improvement needed) 
		if ([NSFm fileExistsAtPath:destinationPath])
			[NSFm removeItemAtPath:destinationPath error:NULL];
		
		
		NSLog(@"Book successfully downloaded. Moving .hpub file to %@", storagePath);
        if(![NSFm fileExistsAtPath:self.bookStoragePath isDirectory:NULL])
            if(![NSFm createDirectoryAtPath:self.bookStoragePath withIntermediateDirectories:TRUE attributes:NULL error:NULL])
                NSLog(@"Error: Create folder failed");
        [NSFm moveItemAtPath:targetPath toPath:storagePath error:NULL];
		return storagePath;
	} else {
        NSLog(@"Unable to write file (not enough free space?)");
	   // Do something if it was not possible to write the book file on the iPhone/iPad file system...
        return nil;
    } 
}
- (BOOL) extractBookAt:(NSString*)targetPath{
    NSString *destinationPath = self.currentBookPath;
    NSLog(@"Book destination path: %@", destinationPath);
    
    // If a "book" directory already exists remove it (quick solution, improvement needed) 
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationPath])
        [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:NULL];
    [SSZipArchive unzipFileAtPath:targetPath toDestination:destinationPath];
    return YES;
}
- (NSString*) containsStoredBook:(NSString*)bookName{
    
    NSString* possibleStoragePath = [self.bookStoragePath stringByAppendingPathComponent: bookName];
    if([[NSFileManager defaultManager] fileExistsAtPath:possibleStoragePath]){
        NSLog(@"Detected we already have a cached version of this book at %@", possibleStoragePath);
        return possibleStoragePath;
    }
    else{
        NSLog(@"No book at %@", possibleStoragePath);
        return nil;
    }
}
- (NSArray*) storedBooks{
    NSArray* dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.bookStoragePath error:nil];
    return [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.hpub'"]];
}

@end