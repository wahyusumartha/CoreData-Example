//
//  CDItemViewController.h
//  CoreData
//
//  Created by Wahyu Sumartha on 8/21/13.
//  Copyright (c) 2013 Mindvalley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *itemTableView;
    UIBarButtonItem *addItemBarButtonItem;
    
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *itemsArray;
}

@property (nonatomic, strong) UITableView *itemTableView;
@property (nonatomic, strong) UIBarButtonItem *addItemBarButtonItem;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *itemsArray;

@end
