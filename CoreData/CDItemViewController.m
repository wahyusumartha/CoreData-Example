//
//  CDItemViewController.m
//  CoreData
//
//  Created by Wahyu Sumartha on 8/21/13.
//  Copyright (c) 2013 Mindvalley. All rights reserved.
//

#import "CDItemViewController.h"

#import "CDAddOrEditItemViewController.h"
#import "Item.h"

#import "CDItemCell.h"

@interface CDItemViewController ()

@end

@implementation CDItemViewController

@synthesize itemTableView;
@synthesize addItemBarButtonItem;
@synthesize managedObjectContext;
@synthesize itemsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadItemsData) name:kNotificationToReloadData object:nil];
    
    [self setTitle:@"Manage Items"];
    
    // initialize items array
    self.itemsArray = [NSMutableArray array];
    
    // load items array
    [self loadItemsData];
    
    // add tableview to ui hierarchy
    self.itemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    [self.itemTableView setDataSource:self];
    [self.itemTableView setDelegate:self];
    [self.view addSubview:self.itemTableView];
    
    // add plus button to navigation controller
    self.addItemBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddView:)];
    [self.navigationItem setRightBarButtonItem:self.addItemBarButtonItem];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item *item = [self.itemsArray objectAtIndex:indexPath.row];
    
    [self editItem:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Item *itemToDelete = [self.itemsArray objectAtIndex:indexPath.row];
        [self deleteItem:itemToDelete atIndexPath:indexPath withTableView:tableView];
    }
}


#pragma mark - UITableView DataSource 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    CDItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[CDItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Item *item = (Item *)[self.itemsArray objectAtIndex:indexPath.row];
    
    [cell.positionIndexLabel setText:[NSString stringWithFormat:@"%d", indexPath.row+1]];
    [cell.itemNameLabel setText:item.name];
    
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
    [nf setCurrencySymbol:@"RM "];

    [cell.itemPriceLabel setText:[nf stringFromNumber:item.price]];
    
    if ((indexPath.row + 1) % 2 == 0) {
        [cell.contentView setBackgroundColor:[UIColor yellowColor]];
    }
    
    return cell;
}


#pragma mark - Open Add View 
- (void)showAddView:(id)sender
{
    CDAddOrEditItemViewController *addItemVC = [[CDAddOrEditItemViewController alloc] init];
    addItemVC.managedObjectContext = self.managedObjectContext;
    [addItemVC setIsUpdateData:NO];
    
    [self.navigationController pushViewController:addItemVC animated:YES];
}

#pragma mark - Edit Item 
- (void)editItem:(Item *)item;
{
    CDAddOrEditItemViewController *editItemVC = [[CDAddOrEditItemViewController alloc] init];
    editItemVC.managedObjectContext = self.managedObjectContext;
    [editItemVC setIsUpdateData:YES];
    [editItemVC setCurrentItem:item];
    
    [self.navigationController pushViewController:editItemVC animated:YES];
}

#pragma mark - Delete Item 
- (void)deleteItem:(Item *)item atIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView
{
    [self.managedObjectContext deleteObject:item];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        errorAlert = nil;
        
    } else {
        
        // update the data
        [self.itemsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }
}


#pragma mark - Load Items Data 
- (void)loadItemsData
{
    // set the request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    // sort item data
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"itemId" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    sortDescriptors = nil;
    sortDescriptor = nil;
    
    // Execute The Request
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    

    self.itemsArray = mutableFetchResults;
    mutableFetchResults = nil;
    request = nil;
    
    [self.itemTableView reloadData];

}

@end
