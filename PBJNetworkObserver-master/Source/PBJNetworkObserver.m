//
//  PBJNetworkObserver.m
//
//  Created by Patrick Piemonte on 5/24/13.
//  Copyright (c) 2013. All rights reserved.
//

#import "PBJNetworkObserver.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h> // internet address ints

#define LOG_NETWORK 0
#if !defined(NDEBUG) && LOG_NETWORK
#   define DLog(fmt, ...) NSLog((@"network: " fmt), ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

@interface PBJNetworkObserver ()
{
    dispatch_queue_t _queue;
    NSHashTable *_observers;

    SCNetworkReachabilityRef _networkReachability;
    SCNetworkReachabilityFlags _networkReachabilityFlags;
    
    struct {
        unsigned int networkReachable:1;
        unsigned int cellularConnection:1;
        unsigned int networkObserversNotified:1;
    } _flags;
}

@end

@implementation PBJNetworkObserver

#pragma mark - singleton

+ (PBJNetworkObserver *)sharedNetworkObserver
{
    static PBJNetworkObserver *singleton = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        singleton = [[PBJNetworkObserver alloc] init];
    });
    return singleton;
}

#pragma mark - getters/setters

- (BOOL)isNetworkReachable
{
    __block BOOL result = NO;
    dispatch_sync(_queue, ^{
        if (!_observers)
            [self _setup];
        result = _flags.networkReachable;
    });
    return result;
}

- (BOOL)isCellularConnection
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif

    __block BOOL result = NO;
    dispatch_sync(_queue, ^{
        if (!_observers)
            [self _setup];
        result = _flags.cellularConnection;
    });
    return result;
}

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create("PBJNetworkObserver", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - PBJNetworkObserver add/remove

- (void)addNetworkReachableObserver:(id<PBJNetworkObserverProtocol>)observer;
{
    dispatch_sync(_queue, ^{
        if (!_observers)
            [self _setup];
    
        if (![_observers containsObject:observer])
            [_observers addObject:observer];
    });
}

- (void)removeNetworkReachableObserver:(id<PBJNetworkObserverProtocol>)observer;
{
    dispatch_sync(_queue, ^{
        if (!_observers || [_observers count] == 0)
            return;
    
        if ([_observers containsObject:observer])
            [_observers removeObject:observer];
    });
}

#pragma mark - private

- (void)_setup
{
    if (!_observers)
        _observers = [NSHashTable weakObjectsHashTable];

    struct sockaddr_in addr = {sizeof(addr), AF_INET, 0, {htonl(INADDR_ANY)}, {0}};
    
    _networkReachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&addr);
    
    SCNetworkReachabilityGetFlags(_networkReachability, &_networkReachabilityFlags);
    
    _flags.networkReachable = ((_networkReachabilityFlags & kSCNetworkReachabilityFlagsReachable) != 0);
    _flags.cellularConnection = ((_networkReachabilityFlags & kSCNetworkReachabilityFlagsIsWWAN) != 0);
    
    SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    SCNetworkReachabilitySetCallback(_networkReachability, (SCNetworkReachabilityCallBack)networkReachabilityCallBack, &context);

    NSData *data = [NSData dataWithBytes:&_networkReachabilityFlags length:sizeof(_networkReachabilityFlags)];
    dispatch_async(dispatch_get_main_queue(), ^{
        DLog(@"initial reachable (%d) cellular (%d)", _flags.networkReachable, _flags.cellularConnection);
        [self _networkReachability:_networkReachability updatedWithFlags:*((SCNetworkReachabilityFlags *)[data bytes])];
        SCNetworkReachabilityScheduleWithRunLoop(_networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    });
}

#pragma mark - SCNetworkReachability callbacks

// SCNetworkReachabilityCallBack ---> _networkReachability:updatedWithFlags:
static void networkReachabilityCallBack(SCNetworkReachabilityRef networkReachability, SCNetworkReachabilityFlags flags, PBJNetworkObserver *me) {
    [me _networkReachability:networkReachability updatedWithFlags:flags];
}

- (void)_networkReachability:(SCNetworkReachabilityRef)networkReachability updatedWithFlags:(SCNetworkReachabilityFlags)flags
{
    // ensure this reachability ref is being used
    if (networkReachability != _networkReachability)
        return;

    DLog(@"handler reachable (%d) cellular (%d)", ((flags & kSCNetworkReachabilityFlagsReachable) != 0), ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) );

    // determine state
    unsigned int reachable[2] = {0, 0};
    size_t count = 0;
    
    unsigned int currentReachable = (flags & kSCNetworkReachabilityFlagsReachable) != 0;
    unsigned int previousReachable = (_networkReachabilityFlags & kSCNetworkReachabilityFlagsReachable) != 0;
    if (currentReachable && previousReachable) {
        reachable[count++] = NO;
    }
    reachable[count++] = currentReachable;
    
    // update state
    _networkReachabilityFlags = flags;
    _flags.cellularConnection = ((_networkReachabilityFlags & kSCNetworkReachabilityFlagsIsWWAN) != 0);
    
    // notify, if necessary
    for (size_t i = 0; i < count; i++) {
        BOOL changed = reachable[i] != _flags.networkReachable;
        if (changed || !_flags.networkObserversNotified) {
            
            _flags.networkObserversNotified = YES;
            _flags.networkReachable = reachable[i];

            DLog(@"notifying reachable (%d) cellular (%d)", _flags.networkReachable, _flags.cellularConnection);
            
            for (id observer in [_observers allObjects])
                [observer networkObserverReachabilityDidChange:self];
        }

    }
}

@end
