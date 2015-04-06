//
//  Store.m
//
//  Created by Sam Oakley on 10/07/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import "SJODataStore.h"

@interface SJODataStore ()
@property (nonatomic,strong,readwrite) NSManagedObjectContext* mainContext;
@property (nonatomic,strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end

@implementation SJODataStore

- (id)init
{
    self = [super init];
    if (self) {
        
        SJODataStore* weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification* note)
         {
             NSManagedObjectContext *managedObjectContext = [note object];
             
             for(NSManagedObject *object in [[note userInfo] objectForKey:NSUpdatedObjectsKey]) {
                 [[managedObjectContext objectWithID:[object objectID]] willAccessValueForKey:nil];
             }

             [weakSelf.mainContext mergeChangesFromContextDidSaveNotification:note];
         }];
    }
    return self;
}


- (void)save
{
    NSError *error = nil;
    if (_mainContext != nil) {
        if ([_mainContext hasChanges] && ![_mainContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext*)newPrivateContext
{
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = [self persistentStoreCoordinator];
    return context;
}


// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)mainContext
{
    if (_mainContext != nil) {
        return _mainContext;
    }
    
    _mainContext = [[NSManagedObjectContext alloc] init];
    _mainContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    return _mainContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

    // Default model
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // Ensure a model is loaded
    if (!model) {
        [[NSException exceptionWithName:@"SJODataKitMissingModel" reason:@"You must provide a managed model." userInfo:nil] raise];
        return nil;
    }
    
	_managedObjectModel = model;
	return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSDictionary *applicationInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *applicationName = [applicationInfo objectForKey:@"CFBundleDisplayName"];
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", applicationName]];

    
    
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    
    // Check if we already have a persistent store
    if ( [[NSFileManager defaultManager] fileExistsAtPath: [storeURL path]] ) {
        NSDictionary *existingPersistentStoreMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType: NSSQLiteStoreType URL:storeURL error:&error];
        if (!existingPersistentStoreMetadata) {
            // Something *really* bad has happened to the persistent store
            if (![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]) {
                NSLog(@"*** Could not delete persistent store, %@", error);
            }
        }
        if (![[self managedObjectModel] isConfiguration:nil compatibleWithStoreMetadata:existingPersistentStoreMetadata]) {
            if (![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]) {
                NSLog(@"*** Could not delete persistent store, %@", error);
            }
        }
    }

    

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end

