## PBJNetworkObserver

'PBJNetworkObserver' is an iOS component for detecting changes in network reachability state as well as connection type. For example, it can determine when an IP is being routed through a Wireless Wide Area Network (WWAN) interface such as 3G or LTE.

Mobile devices are frequently moving through connectivity challenged environments made up of various network interfaces. This component enables apps to easily monitor these network changes and allow opportunities to refresh, cache, or even provide user interface feedback when they occur.

Some common uses include auto-refresh, logic that can be triggered for a view if the device upgrades from an EDGE network to a WiFi access point allowing more or higher quality data to be quickly loaded.

Observers are notified when a network is no longer reachable, the network becomes reachable, and when the network interface type changes.

If you have questions, [github issues](https://github.com/piemonte/PBJNetworkObserver/issues) is a great means to start a discussion, this allows others to benefit and chime in on the project too.

## Installation

[CocoaPods](http://cocoapods.org) is the recommended method of installing PBJNetworkObserver, just add the following line to your `Podfile`:

#### Podfile

```ruby
pod 'PBJNetworkObserver'
```

## Usage

```objective-c
#import "PBJNetworkObserver.h"
```

```objective-c
@interface MyClass () <PBJNetworkObserverProtocol>
```

```objective-c
// add observer on init or viewDidAppear
    [[PBJNetworkObserver sharedNetworkObserver] addNetworkReachableObserver:self];

// remove observer on dealloc or on viewDidDisappear
    [[PBJNetworkObserver sharedNetworkObserver] removeNetworkReachableObserver:self];
```

```objective-c
- (void)networkObserverReachabilityDidChange:(PBJNetworkObserver *)networkObserver
{
    // network status changed, these properties can also be queried at any time
    BOOL isNetworkReachable = [networkObserver isNetworkReachable];
    BOOL isCellularConnection = [networkObserver isCellularConnection];
    NSLog(@"network status changed reachable (%d),  cellular (%d)", isNetworkReachable, isCellularConnection);
}

```

## License

PBJNetworkObserver is available under the MIT license, see the [LICENSE](https://github.com/piemonte/PBJNetworkObserver/blob/master/LICENSE) file for more information.
