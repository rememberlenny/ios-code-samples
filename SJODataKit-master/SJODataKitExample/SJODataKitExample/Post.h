//
//  Post.h
//  SJODataKitExample
//
//  Created by Zack Brown on 06/10/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Author *author;

@end
