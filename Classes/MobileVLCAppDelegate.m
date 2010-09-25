//
//  MobileVLCAppDelegate.m
//  MobileVLC
//
//  Created by Pierre d'Herbemont on 6/27/10.
//  Copyright Applidium 2010. All rights reserved.
//

#import "MobileVLCAppDelegate.h"
#import "MLMediaLibrary.h"
#import <MobileVLCKit/MobileVLCKit.h>

@interface MobileVLCAppDelegate (Private)
- (void)_updateMediaLibrary;
@end


@implementation MobileVLCAppDelegate
@synthesize window=_window, navigationController=_navigationController, movieListViewController=_movieListViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [_window addSubview:self.navigationController.view];
    [_window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// The application becomes active after a sync (i.e., file upload)
	[self _updateMediaLibrary];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[MLMediaLibrary sharedMediaLibrary] applicationWillExit];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[_movieListViewController release];
	[_navigationController release];
    [_window release];
    [super dealloc];
}
@end

@implementation MobileVLCAppDelegate (Private)
- (void)_updateMediaLibrary {
#define PIERRE_LE_GROS_CRADE 0
#if TARGET_IPHONE_SIMULATOR && PIERRE_LE_GROS_CRADE
    NSString *directoryPath = @"/Users/steg/Movies";
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = [paths objectAtIndex:0];
#endif
    MVLCLog(@"Scanning %@", directoryPath);
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    NSMutableArray *filePaths = [NSMutableArray arrayWithCapacity:[fileNames count]];
    for (NSString * fileName in fileNames) {
		if ([fileName rangeOfString:@"\\.(3gp|asf|avi|divx|dv|flv|gxf|m2p|m2ts|m2v|m4v|mkv|moov|mov|mp4|mpeg|mpeg1|mpeg2|mpeg4|mpg|mpv|mt2s|mts|mxf|ogm|ogv|ps|qt|rm|rmvb|ts|vob|webm|wm|wmv)$" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].length != 0) {
            [filePaths addObject:[directoryPath stringByAppendingPathComponent:fileName]];
        }
    }
    [[MLMediaLibrary sharedMediaLibrary] addFilePaths:filePaths];
	[self.movieListViewController reloadMedia];
}
@end


