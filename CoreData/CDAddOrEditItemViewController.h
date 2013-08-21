//
//  CDAddOrEditItemViewController.h
//  CoreData
//
//  Created by Wahyu Sumartha on 8/21/13.
//  Copyright (c) 2013 Mindvalley. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kNotificationToReloadData = @"kNotificationToReloadData";

@class Item;

@interface CDAddOrEditItemViewController : UIViewController <UITextFieldDelegate> {
    
    NSManagedObjectContext *managedObjectContext;
    BOOL updateData;
    Item *currentItem;
}

@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemPriceTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveOrUpdateBtn;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign, nonatomic, getter = isUpdateData, setter = setIsUpdateData:) BOOL updateData;
@property (strong, nonatomic) Item *currentItem;

- (IBAction)saveOrUpdate:(id)sender;

@end
