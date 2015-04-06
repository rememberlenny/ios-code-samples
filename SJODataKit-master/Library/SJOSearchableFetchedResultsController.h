//
//  SJOSearchableFetchedResultsController.h
//
//  Created by Sam Oakley on 15/07/2013.
//  Copyright (c) 2013 Sam Oakley. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>


@class SJODataStore;
/**
This class provides a simpler way to replicate the often-used pattern of a searchable Core Data-backed table view. Must be used as a subclass.
 */
@interface SJOSearchableFetchedResultsController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, NSFetchedResultsControllerDelegate>

/**
 The SJODataStore to be used when querying data.
 @warning This must be set before the view is loaded.
 */
@property (strong, nonatomic) SJODataStore *store;

/**
 The UISearchDisplayController used to manage the search interface.
 @discussion You can customise it in your subclass to enable scope buttons, etc.
 */
@property (strong, nonatomic, readonly) UISearchDisplayController *searchController;

@property (strong, nonatomic) UIView *emptyView;

/**
 Returns the currently active UITableView (i.e. regular or search).
 @return The UITableView that is currently active.
 */
-(UITableView*)activeTableView;

/**
 Returns the currently active NSFetchedResultsController (i.e. regular or search).
 @return The NSFetchedResultsController that is currently active.
 */
- (NSFetchedResultsController *)activeFetchedResultsController;


/**
 Returns the appropiate NSFetchedResultsController (i.e. regular or search) for the given UITableView.
 @param tableView The UITableView you wish to retrieve the NSFetchedResultsController for.
 @return The NSFetchedResultsController that is managing the given UITableView.
 */
- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView;

/**---------------------------------------------------------------------------------------
 * @name Methods to be overridden in subclass
 *  ---------------------------------------------------------------------------------------
 */
/**
 Configure a cell for display.
 @discussion Override this method in your subclass to customise the appearance of your cell.
 @param cell The cell to be displayed.
 @param indexPath The index path for the row.
 @warning This method must be overidden in your subclass.
 */
- (void)fetchedResultsController:(NSFetchedResultsController *)fetchedResultsController configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/**
 Returns a new NSFetchRequest for the specified search string.
 @discussion Override this method in your subclass to return the appropriate NSFetchRequest for the search term. If searchString is nil, return your unfiltered dataset.
 @param searchString The query entered by a user. May be nil.
 @return The NSFetchRequest to be executed by the NSFetchedResultsController.
 @warning This method must be overidden in your subclass.
 */
- (NSFetchRequest *)fetchRequestForSearch:(NSString *)searchString;

/**
Forces the fetched results controllers to be recreated, causing performFetch to be fired again.
 @param fetchedResultsController The NSFetchedResultsController to be reloaded
 */
- (void) reloadFetchedResultsControllers;

@end
