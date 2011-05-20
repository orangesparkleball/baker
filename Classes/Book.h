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
    
    
}

@property (nonatomic,retain) NSString* bookPath;
@property (nonatomic,retain) NSMutableArray* pages;

- (Book*)initBookFromPath:(NSString*)path;
- (int)currentPageWithURL:(NSString*)url andFirstLoad:(BOOL)isFirstLoad;
- (int)currentPageWithURL:(NSString*)url;
- (int)currentPage;
- (int)totalPages;
- (BOOL)openInView:(UIWebView*)view;
- (BOOL)openPage:(int)page inView:(UIWebView*)view;
- (NSString*)indexPath;
- (NSString*)indexPathComponent;

@end
