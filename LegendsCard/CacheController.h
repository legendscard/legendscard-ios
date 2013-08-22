//
//  CacheController.h
//  LegendsCard
//
//  Created by Josh Sklar on 7/14/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CacheController : NSObject

- (void)queueAssetForRetrievalFromURL:(NSURL*)url withData:(NSData*)data;
- (NSURL*)localURLForAssetURL:(NSURL*)url;

- (void)clearCache;
@end
