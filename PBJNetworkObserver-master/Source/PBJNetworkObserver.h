//
//  PBJNetworkObserver.h
//
//  Created by Patrick Piemonte on 5/24/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PBJNetworkObserverProtocol;
@interface PBJNetworkObserver : NSObject
{
}

+ (PBJNetworkObserver *)sharedNetworkObserver;

@property (nonatomic, readonly, getter=isNetworkReachable) BOOL networkReachable;
@property (nonatomic, readonly, getter=isCellularConnection) BOOL cellularConnection;

// observers will be notified on network reachability state changes, as defined by SCNetworkReachabilityFlags

- (void)addNetworkReachableObserver:(id<PBJNetworkObserverProtocol>)observer;
- (void)removeNetworkReachableObserver:(id<PBJNetworkObserverProtocol>)observer;

@end

@protocol PBJNetworkObserverProtocol <NSObject>
@required
- (void)networkObserverReachabilityDidChange:(PBJNetworkObserver *)networkObserver;
@end
