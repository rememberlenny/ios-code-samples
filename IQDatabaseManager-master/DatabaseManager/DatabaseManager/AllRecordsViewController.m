//
//  AllRecordsViewController.m
//  DatabaseManager

#import "AllRecordsViewController.h"
#import "MyDatabaseManager.h"
#import "RecordCell.h"
#import "UpdateViewController.h"

@interface AllRecordsViewController ()
{
    NSArray *records;
    NSArray *filteredRecords;
    RecordTable *selectedRecord;
    NSString *sortingAttribute;
}

-(void)deleteAllRecords:(id)sender;
-(void)ShowActionSheet:(id)sender;

@end

@implementation AllRecordsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setEditing:YES animated:YES];
    self.tableView.allowsSelectionDuringEditing = YES;
    
    UIBarButtonItem *actionSheetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ShowActionSheet:)];
    UIBarButtonItem *deleteAllRecords = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAllRecords:)];
    
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:deleteAllRecords,actionSheetButton, nil];
    
    self.navigationItem.rightBarButtonItems = buttonArray;
    
    filteredRecords = [NSMutableArray arrayWithCapacity:[records count]];
    
    [self.tableView reloadData];
}

-(void)refreshTable
{
    records = [[[MyDatabaseManager sharedManager] allRecordsSortByAttribute:sortingAttribute] mutableCopy];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredRecords count];
    }
    else
    {
        return [records count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"recordCell";

    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        RecordTable *record = [filteredRecords objectAtIndex:indexPath.row];

        cell.textLabel.text = record.name;
        cell.detailTextLabel.text = record.email;
        return cell;

    }
    else
    {
        RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        RecordTable *record = [records objectAtIndex:indexPath.row];
        cell.labelName.text = record.name;
        cell.labelEmail.text = record.email;
        cell.labelPhone.text = record.phoneNumber;
        cell.labelComment.text = record.comment;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        selectedRecord = [filteredRecords objectAtIndex:indexPath.row];
    }
    else
    {
        selectedRecord = [records objectAtIndex:indexPath.row];
    }

    [self performSegueWithIdentifier:@"kUpdateSegue" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            RecordTable *aRecord = [records objectAtIndex: indexPath.row];
            [[MyDatabaseManager sharedManager] deleteTableRecord:aRecord];
            
            [self refreshTable];
        }
}

-(void)deleteAllRecords:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                      message:@"Do you want to delete all records"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Delete", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Delete"])
    {
        [[MyDatabaseManager sharedManager] deleteAllTableRecord];
        
        [self refreshTable];
        NSLog(@"Delete was selected.");
    }
    else if([title isEqualToString:@"Cancel"])
    {
        NSLog(@"Cancel was selected.");
    }
}

-(void)ShowActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Sort List"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:kName, kEmail, kPhoneNumber,kComment, nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (![buttonTitle isEqualToString:@"Cancel"])
    {
        sortingAttribute = buttonTitle;
        [self refreshTable];
    }
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"kUpdateSegue"])
    {
        UpdateViewController *controller = [segue destinationViewController];
        controller.record = selectedRecord;
    }
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    filteredRecords = [[MyDatabaseManager sharedManager] allRecordsSortByAttribute:nil where:scope contains:searchText];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}




@end
