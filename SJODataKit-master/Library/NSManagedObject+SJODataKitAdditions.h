//
//  NSManagedObject+Additions.h
//
//  Created by Sam Oakley on 10/07/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SJODataStore.h"
/**
Additions to NSManagedObject to reduce boilerplate and simplify common operations. 
 @warning These methods never should __never__ be called directly on NSManagedObject (e.g. [NSManagedObject entityName]), but instead only on subclasses.
 */
@interface NSManagedObject (SJODataKitAdditions)

/**
 The name of the entity, derived from the class name.
 @return The name of the entity.
 */
+ (NSString *)entityName;

/**
 A convenience method for obtaning a new NSEntityDescription.\
 @param context The NSManagedObjectContext to use. Must not be nil.
 @return The entity for the calling class from the managed object model associated with context’s persistent store coordinator.
 */
+ (NSEntityDescription *)entityWithContext:(NSManagedObjectContext *)context;

/**
 Insert and return a new instance of NSManagedObject subclass.
 @param context The NSManagedObjectContext to use. Must not be nil.
 @return A new, autoreleased, fully configured instance of the class. The instance has its entity description set and is inserted it into context.
 */
+ (instancetype) insertInContext:(NSManagedObjectContext*) context;

+ (instancetype) findWithPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext *)context;

/**
 Find an instance of NSManagedObject subclass in the NSManagedObjectContext matching the key and value.
 @param key The name of the object property to match on.
 @param value The value of the property specified by key.
 @param context The NSManagedObjectContext to use.
 @return The matching object, or nil if no match is found.
 */
+ (instancetype)findByKey:(NSString *)key value:(id)value inContext:(NSManagedObjectContext *)context;

/**
 Find an instance of NSManagedObject subclass in the NSManagedObjectContext matching the key and value. If no match is found, a new object is inserted with the it's key value set appropriately.
 @param key The name of the object property to match on.
 @param value The value of the property specified by key.
 @param context The NSManagedObjectContext to use.
 @return An object retrieved from the context, or a new object inserted to the context with key set to value.
 */
+ (instancetype)findOrInsertByKey:(NSString *)key value:(id)value inContext:(NSManagedObjectContext *)context;

/**
 Returns a fetch request configured for the entity.
 @discussion This method provides a convenient way to create a fetch request without having to retrieve an NSEntityDescription object.
 @return A fetch request configured to fetch using the subclass' entity.
 */
+ (NSFetchRequest*) fetchRequest;

/**
 Returns a fetch request configured for the entity with a given predicate.
 @discussion This method provides a convenient way to create a fetch request without having to retrieve an NSEntityDescription object.
 @param predicate The NSPredicate to set on the fetch request.
 @return A fetch request configured to fetch using the subclass' entity.
 */
+(NSFetchRequest*) fetchRequestWithPredicate:(NSPredicate*)predicate;


/**
 Returns the result of executing a fetch request the given predicate over the given context.
 @discussion This method provides a convenient way to retrieve results without the intermediate steps.
 @param predicate The NSPredicate to set on the fetch request.
 @param context The NSManagedObjectContext to execute the fetch request.
 @param error If there is a problem executing the fetch, upon return contains an instance of NSError that describes the problem.
 @return An array of objects that meet the criteria specified by request fetched from the receiver and from the persistent stores associated with the receiver’s persistent store coordinator. If an error occurs, returns nil. If no objects match the criteria specified by request, returns an empty array.
 */
+(NSArray*) executeFetchRequestWithPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*) context error:(NSError **)error;

/**
 Perform a batch insert-or-update.
 @discussion This method codifies the pattern found in the Apple guide to [Implementing Find-or-Create Efficiently](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdImporting.html#//apple_ref/doc/uid/TP40003174-SW4).
 
 @param dictArray An array of dictionaries corresponsing to the objects you wish to insert/update. It is not necessary that the keys of the dictionary are the same as the NSManagedObject properties, only that they share the value specified by the key parameter.
 @param key The key that cam be used to identidy uniqueness between the NSManagedObjects and the dictionaries. Usually an ID returned byy a web service.
 @param block This block is called when the values of a newly inserted or a fetched object need to be set. In order that the keys of the dictionary do not have to 1-1 correspond with the model, both are used as parameters to the block so that the model may be set form the dictionary. You may include additional logic within this block to determine if an update should actually occur. For example:

     [Bookmark insertOrUpdate:responseObject
         forUniqueKey:@"href"
         withBlock:^(NSDictionary *dictionary, Bookmark *bookmark) {
             //Set the object values from the dict (or however). Here we perform some additional logic.
             if (![bookmark.deleted boolValue] && ![[bookmark changeDetectionHash] isEqualToString:dictionary[@"meta"]]) {
                 [bookmark setFromDictionary:dictionary];
             }
         }
         inStore:store
         error:nil];
 
 @param store The SJODataStore in which to perform the inserts/updates.
 @param error An error pointer
 */
+ (void) insertOrUpdate:(NSArray*)dictArray
           forUniqueKey:(NSString*)key
              withBlock:(void (^) (NSDictionary* dictionary, id managedObject))block
                inContext:(NSManagedObjectContext *)context
                  error:(NSError**)error;

/**
 Delete the NSManagedObject from its current context.
 */
- (void)deleteObject;

/**
 Remove all objects of the class from the store asyncronously.
 
 @param store The SJODataStore in which to perform the deletions.
 @param block called on success or failure.
 */
+ (void)deleteAllInStore:(SJODataStore*) store withBlock:(void (^) (BOOL success, NSError *error))block;

/**
 Convenience method for retrieving an NSPropertyDescription.
 
 @param store The name of the property.
 @param context The NSManagedObjectContext to use.
 */
+ (NSPropertyDescription*) propertyDescriptionForName:(NSString*) name inContext:(NSManagedObjectContext *) context;

@end
