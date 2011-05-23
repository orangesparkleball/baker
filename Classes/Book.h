//
//  Book.h
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Book : NSObject {
    NSString* bookPath;
    NSMutableArray* pages;
    NSString* title;
    NSDictionary* meta;
    NSString* version;
    NSString* url;
}

@property (nonatomic,retain) NSString* bookPath;
@property (nonatomic,retain) NSMutableArray* pages;
@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSDictionary* meta;
@property (nonatomic,retain) NSString* version;
@property (nonatomic,retain) NSString* url;

- (Book*)initBookFromPath:(NSString*)path;
- (NSDictionary*)loadManifest:(NSString*)file;
- (NSMutableArray*)listOfPages;

- (int)currentPageWithURL:(NSString*)url andFirstLoad:(BOOL)isFirstLoad;
- (int)currentPageWithURL:(NSString*)url;
- (int)currentPage;
- (int)totalPages;
- (BOOL)openInView:(UIWebView*)view;
- (BOOL)openPage:(int)page inView:(UIWebView*)view;
- (NSString*)indexPath;
- (NSString*)indexPathComponent;
- (NSString*)manifestPath;
- (NSString*)manifestPathComponent;

@end
