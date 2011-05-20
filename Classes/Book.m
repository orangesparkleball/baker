//
//  Book.m
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import "Book.h"
#define INDEX_FILE_NAME @"index.html"


@implementation Book

@synthesize pages;
@synthesize bookPath;

- (Book*)initBookFromPath:(NSString *)path{
    self =[super init];
    self.bookPath = path;
    self.pages = [NSMutableArray array];
 
    [self.pages removeAllObjects];
	
	NSArray *dirContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
	for (NSString *fileName in dirContent) {
		if ([[fileName pathExtension] isEqualToString:@"html"] && ![fileName isEqualToString:INDEX_FILE_NAME])
			[self.pages addObject:[path stringByAppendingPathComponent:fileName]];
	}
    NSLog(@"Pages in this book: %d", [self totalPages]);
    return self;
}

-(int)totalPages{
    return [self.pages count];
}

-(NSString*)indexPath{
    return [bookPath stringByAppendingPathComponent:INDEX_FILE_NAME];
}
-(NSString*)indexPathComponent{
    return INDEX_FILE_NAME;
}

- (int)currentPageWithURL:(NSString*)url andFirstLoad:(BOOL)isFirstLoad{
    NSString *currPageToLoad = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPageViewed"];
    int currentPageNumber;
    if (isFirstLoad && currPageToLoad != nil) {
        currentPageNumber = [currPageToLoad intValue];
    }
    else{
        currentPageNumber = 1;
        if (url != nil) { 
            NSString *fileNameFromURL = [self.bookPath stringByAppendingPathComponent:url];
            for (int i = 0; i < [self totalPages]; i++) {
                if ([[pages objectAtIndex:i] isEqualToString:fileNameFromURL]) {
                    currentPageNumber = i+1;
                    break;
                }
            }
        }
    }
    return currentPageNumber;
}

- (int)currentPageWithURL:(NSString*)url{
    return [self currentPageWithURL:url andFirstLoad:NO];
}

- (int)currentPage{
    return [self currentPageWithURL:nil andFirstLoad:NO];
}

- (BOOL)openPage:(int)pageNum inView:(UIWebView*)webView{
    int indexNum = pageNum - 1;
    NSString *path = [self.pages objectAtIndex:indexNum];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"[+] Loading: book/%@", [[NSFileManager defaultManager] displayNameAtPath:path]);
        webView.hidden = YES; // use direct property instead of [self webView:hidden:animating:] otherwise it won't work
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        return YES;
    }
    return NO;
}

- (BOOL)openInView:(UIWebView*)view{
    return [self openPage:[self currentPage] inView:view];
}


@end
