//
//  CDAddOrEditItemViewController.m
//  CoreData
//
//  Created by Wahyu Sumartha on 8/21/13.
//  Copyright (c) 2013 Mindvalley. All rights reserved.
//

#import "CDAddOrEditItemViewController.h"

#import "Item.h"

@interface CDAddOrEditItemViewController ()

@end

@implementation CDAddOrEditItemViewController

@synthesize managedObjectContext;
@synthesize updateData;
@synthesize currentItem;

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
    // Do any additional setup after loading the view from its nib.
    
    if (updateData) {
        [self.itemNameTextField setText:self.currentItem.name];
        [self.itemPriceTextField setText:[self.currentItem.price stringValue]];
        
        [self.saveOrUpdateBtn setTitle:@"Update" forState:UIControlStateNormal];
    } else {
        [self.saveOrUpdateBtn setTitle:@"Save" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Management 
- (BOOL)isValidToSave
{
    if (self.itemNameTextField.text.length == 0 ||
            self.itemPriceTextField.text.length == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)saveItemData
{
    Item *item = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    
    [item setItemId:[NSNumber numberWithInt:timestamp]];
    [item setName:self.itemNameTextField.text];
    [item setPrice:[NSDecimalNumber decimalNumberWithString:self.itemPriceTextField.text]];
    
    NSError *error = nil;
    
    if (![managedObjectContext save:&error]) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        errorAlert = nil;
        
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToReloadData object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void)updateItemData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *itemDescription = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:itemDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(itemId = '%@')", self.currentItem.itemId]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *tempObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    Item *tempObject = [tempObjects objectAtIndex:0];
    
    
    [tempObject setName:self.itemNameTextField.text];
    [tempObject setPrice:[NSDecimalNumber decimalNumberWithString:self.itemPriceTextField.text]];
    
    if (![self.managedObjectContext save:&error]) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        errorAlert = nil;
    
    } else {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationToReloadData object:nil];
        [self.navigationController popViewControllerAnimated:YES];

    }
    
    
}

- (IBAction)saveOrUpdate:(id)sender {
    
    
    if (![self isValidToSave]) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Name or Price is Required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        errorAlert = nil;
        
    } else {
        
        if (updateData) [self updateItemData];
        else [self saveItemData];
    }

}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
