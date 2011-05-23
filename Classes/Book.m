//
//  Book.m
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import "Book.h"

#import "NSDictionary_JSONExtensions.h"

#define INDEX_FILE_NAME @"index.html"
#define MANIFEST_FILE_NAME @"manifest.json"


@implementation Book

@synthesize pages;
@synthesize bookPath;
@synthesize title;
@synthesize meta;
@synthesize version;
@synthesize url;

- (Book*)initBookFromPath:(NSString *)path{
    self =[super init];
    self.bookPath = path;
    self.pages = [NSMutableArray array];
    [self.pages removeAllObjects];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[self manifestPath]]){
        // Manifest found, load settings from it.
        
        NSLog(@"Manifest found at %@", [self manifestPath]);
        NSDictionary* settings = [self loadManifest:[self manifestPath]];
        self.title = [settings objectForKey:@"title"];
        self.version = [settings objectForKey:@"version"];
        self.meta = settings;
        if([[settings objectForKey:@"pages"] isKindOfClass:[NSArray class]]){
            for(NSString* fileName in [settings objectForKey:@"pages"]){
                if ([[NSFileManager defaultManager] fileExistsAtPath:[self.bookPath stringByAppendingPathComponent:fileName]])
                    [self.pages addObject:[path stringByAppendingPathComponent:fileName]];

            }
        }
        else self.pages = [self listOfPages];
    }
    else{
        self.title = @"A Baker Book";
        self.version = @"1.0";
        self.pages = [self listOfPages];

    }
    NSLog(@"Pages in this book: %d", [self totalPages]);
    return self;
}

-(int)totalPages{
    return [self.pages count];
}

-(NSMutableArray*)listOfPages{
    NSMutableArray* myPages = [NSMutableArray array];
    NSArray *dirContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.bookPath error:nil];
    for (NSString *fileName in dirContent) {
        if ([[fileName pathExtension] isEqualToString:@"html"] && ![fileName isEqualToString:INDEX_FILE_NAME])
            [myPages addObject:[self.bookPath stringByAppendingPathComponent:fileName]];
    }
    return myPages;
}

// ****** LOADING
- (NSDictionary*)loadManifest:(NSString*)file {
    /****************************************************************************************************
	 * Reads a JSON file from Application Bundle to a NSDictionary.
     *
     * Requires TouchJSON with the inclusion of: #import "NSDictionary_JSONExtensions.h"
     *
     * Use normal NSDictionary and NSArray lookups to find elements.
     *   [json objectForKey:@"name"]
     *   [[json objectForKey:@"items"] objectAtIndex:1]
	 */
    NSDictionary *ret;
    
    if (file) {  
        NSString *fileJSON = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
        
        NSError *e = NULL;
        ret = [NSDictionary dictionaryWithJSONString:fileJSON error:&e];
    }
    
    /* // Testing logs
     NSLog(@"%@", e);
     NSLog(@"%@", ret);
     
     NSLog(@"Lookup, string: %@", [ret objectForKey:@"title"]);
     NSLog(@"Lookup, sub-array: %@", [[ret objectForKey:@"pages"] objectAtIndex:1]); */
    
    return ret;
}

-(NSString*)indexPath{
    return [bookPath stringByAppendingPathComponent:[self indexPathComponent]];
}
-(NSString*)indexPathComponent{
    if(self.meta && [[self.meta objectForKey:@"index_view"] isKindOfClass:[NSString class]]){
        return [self.meta objectForKey:@"index_view"];
    }
    return INDEX_FILE_NAME;
}
-(NSString*)manifestPath{
    return [bookPath stringByAppendingPathComponent:MANIFEST_FILE_NAME];
}
-(NSString*)manifestPathComponent{
    return MANIFEST_FILE_NAME;
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
