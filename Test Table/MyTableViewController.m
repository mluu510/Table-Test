//
//  MyTableViewController.m
//  Test Table
//
//  Created by Minh Luu on 6/4/14.
//  Copyright (c) 2014 Minh Luu. All rights reserved.
//

#import "MyTableViewController.h"

@interface MyTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSArray *contacts;

@end

@implementation MyTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Contacts";
    
    [self loadContacts];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    // Add search bar
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    self.tableView.tableHeaderView = searchBar;
//    UISearchDisplayController *searchVC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    searchVC.delegate = self;
//    searchVC.searchResultsDataSource = self;
}

- (void)loadContacts {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"txt"];
    NSString *contactList = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *names = [contactList componentsSeparatedByString:@"\n"];
    
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    NSInteger sectionCount = collation.sectionTitles.count;
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    for (int i = 0; i < sectionCount; i++) {
        [unsortedSections addObject:[@[] mutableCopy]];
    }
    
    // Put each contact into a section
    for (NSString *name in names) {
        NSInteger index = [collation sectionForObject:names collationStringSelector:@selector(description)];
        [[unsortedSections objectAtIndex:index] addObject:name];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    // Sort each section
    for (NSMutableArray *section in unsortedSections) {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
    }
    
    self.contacts = sections;
    
//    self.contacts = [@{} mutableCopy];
//    for (NSString *name in names) {
//        // Grab their last name
//        NSString *lastName = [[name componentsSeparatedByString:@" "] lastObject];
//        
//        // Grab the first letter
//        NSString *firstLetter = [lastName substringToIndex:1];
//        
//        // Create an array for each new index letter
//        if (!self.contacts[firstLetter]) {
//            self.contacts[firstLetter] = [@[] mutableCopy];
//        }
//        
//        // Grab the array for the index letter
//        NSMutableArray *letterArray = self.contacts[firstLetter];
//        
//        // Add name to the array
//        [letterArray addObject:name];
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL showSection = [[self.contacts objectAtIndex:section] count] != 0;
    return showSection ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.contacts objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    NSString *name = [[self.contacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = name;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionTitles];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
