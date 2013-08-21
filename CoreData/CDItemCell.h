//
//  CDItemCell.h
//  CoreData
//
//  Created by Wahyu Sumartha on 8/21/13.
//  Copyright (c) 2013 Mindvalley. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kMaxHeightOfCell = 60;

@interface CDItemCell : UITableViewCell

@property (nonatomic, strong) UILabel *positionIndexLabel;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *itemPriceLabel;

@end
