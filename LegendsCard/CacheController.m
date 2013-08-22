//
//  CacheController.m
//  LegendsCard
//
//  Created by Josh Sklar on 7/14/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "CacheController.h"
#import "NSData+ZSAdditions.h"
#import "NSString+ZSAdditions.h"
#define kCachePath @"imageCache"

#define TMP NSTemporaryDirectory()

@interface CacheController ()

@property (strong, nonatomic) NSString *picturesCacheDirectory;
@property (strong, nonatomic) NSString *cachePathString;

@end

@implementation CacheController

@synthesize picturesCacheDirectory = _picturesCacheDirectory;
@synthesize cachePathString;

-(id)init
{
    self = [super init];
    if (self) {
        self.cachePathString = [self cachePath];
        _picturesCacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"perksPics"];
    }
    return self;
}


- (NSURL*)localURLForAssetURL:(NSURL*)url
{    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *localURL = [self resolveLocalURLForRemoteURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[localURL path]]) {
        return localURL;
    }
    return nil;
}

- (void)queueAssetForRetrievalFromURL:(NSURL*)url withData:(NSData*)data
{
    NSString *filePath = [[self resolveLocalURLForRemoteURL:url] path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        DLog(@"file already in place: %@", filePath);
        return;
    }
    
    [data writeToFile:filePath atomically:NO];
}

- (NSURL*)resolveLocalURLForRemoteURL:(NSURL*)url
{
    if (!url) return nil;
    
    NSString *filename = [[url absoluteString] zs_digest];
    NSString *filePath = [[self cachePathString] stringByAppendingPathComponent:filename];
    
    return [NSURL fileURLWithPath:filePath];
}

- (NSString*)cachePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:kCachePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) return filePath;
    
    NSError *error = nil;
    ZAssert([fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:&error], @"Failed to create image cache directory: %@\n%@", [error localizedDescription], [error userInfo]);
    
    return filePath;
}

- (void)clearCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error = nil;
    [fileManager removeItemAtPath:[self cachePath] error:&error];
    if (error) {
        NSLog(@"This should never occur");
    }

}

@end
