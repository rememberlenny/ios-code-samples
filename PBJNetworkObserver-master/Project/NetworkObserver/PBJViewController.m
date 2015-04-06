//
//  PBJViewController.m
//  NetworkObserver
//
//  Created by Patrick Piemonte on 7/22/13.
//  Copyright (c) 2013 Patrick Piemonte. All rights reserved.
//

#import "PBJViewController.h"
#import "PBJNetworkObserver.h"

@interface PBJViewController () <PBJNetworkObserverProtocol>

@end

@implementation PBJViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[PBJNetworkObserver sharedNetworkObserver] addNetworkReachableObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[PBJNetworkObserver sharedNetworkObserver] removeNetworkReachableObserver:self];
}

#pragma mark - PBJNetworkObserverProtocol

- (void)networkObserverReachabilityDidChange:(PBJNetworkObserver *)networkObserver
{
    // network status changed, these properties can also be queried directly from the singleton
    BOOL isNetworkReachable = [networkObserver isNetworkReachable];
    BOOL isCellularConnection = [networkObserver isCellularConnection];
    NSLog(@"network status changed reachable (%d), cellular (%d)", isNetworkReachable, isCellularConnection);
}

@end
