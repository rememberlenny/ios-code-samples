//
//  Store.h
//
//  Created by Sam Oakley on 10/07/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
/**
 This class manages the Core Data setup and initialisation for an application. The model is automatically loaed from the bundle, and lightweight migration is enabled.
 
 Best practice would be to create an SJODataStore as a property on your appDelegate, then pass this to the view controllers as needed.
 */
@interface SJODataStore : NSObject

/**
 Save the contents of the store.
 @discussion Most often called within applicationWillTerminate: to persist changes to disk when the user leaves the app.
 */
- (void) save;

/**
 Create a new private context for use off the main thread.
 @discussion Make use of GCD and performBlockAndWait:. For example, if you want to import some data in the background:
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext* context = [store privateContext];
        [context performBlockAndWait:^{
            //Create new objects and save the private context here
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Notify of success on main thread
        });
    });
 
 @return A new context initialised with the NSPrivateQueueConcurrencyType type.
 */
- (NSManagedObjectContext*) newPrivateContext;

/**
 The primary NSManagedObjectContext on the main thread.
 @discussion In general this should only be used to back FRCs, or for quick operations. Most other operations should happen off the main thread for performance.
 @return The shared NSManagedObjectContext.
 */
- (NSManagedObjectContext*) mainContext;

@end
