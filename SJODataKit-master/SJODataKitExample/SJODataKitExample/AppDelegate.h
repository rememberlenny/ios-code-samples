//
//  AppDelegate.h
//  SJODataKitExample
//
//  Created by Sam Oakley on 12/07/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJODataKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SJODataStore *store;

@end
