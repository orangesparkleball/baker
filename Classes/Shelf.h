//
//  Shelf.h
//  Baker
//
//  Created by David Haslem on 5/19/11.
//  Copyright 2011 Orange Sparkle Ball, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Shelf : NSObject {
    NSString* bundledBookPath;
    NSString* currentBookPath;
    NSString* bookStoragePath;
}

@property (nonatomic,retain) NSString* bundledBookPath;
@property (nonatomic,retain) NSString* currentBookPath;
@property (nonatomic,retain) NSString* bookStoragePath;

@end
