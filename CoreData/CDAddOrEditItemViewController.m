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

- (IBAction)saveItemData:(id)sender {
    
    if (![self isValidToSave]) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Name or Price is Required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        errorAlert = nil;
        
    } else {
        
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
    
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
