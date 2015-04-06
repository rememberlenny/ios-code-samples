//
//  AppDelegate.m
//  SJODataKitExample
//
//  Created by Sam Oakley on 12/07/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import "AppDelegate.h"
#import "SJODataKit.h"
#import "Post.h"
#import "ExampleViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    ExampleViewController* vc = [[ExampleViewController alloc] init];
    vc.store = self.store;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
    
    
    NSManagedObjectContext* context = [self.store newPrivateContext];
    
    [context performBlock:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[Post entityWithContext:context]];
        NSInteger count = [context countForFetchRequest:fetchRequest error:nil];
        NSLog(@"Total posts = %@", @(count));
    }];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //Saves changes in the application's managed object context before the application terminates.
    [self.store save];
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    //For testing in simulator
    [self.store save];
}

-(SJODataStore *)store
{
    if (!_store) {
        _store = [[SJODataStore alloc] init];
    }
    return _store;
}

@end
