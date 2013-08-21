//
//  CDItemCell.m
//  CoreData
//
//  Created by Wahyu Sumartha on 8/21/13.
//  Copyright (c) 2013 Mindvalley. All rights reserved.
//

#import "CDItemCell.h"

@implementation CDItemCell

@synthesize positionIndexLabel;
@synthesize itemNameLabel;
@synthesize itemPriceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.positionIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, (kMaxHeightOfCell-20)/2, 35, 20)];
    [self.positionIndexLabel setFont:[UIFont systemFontOfSize:18]];
    [self.positionIndexLabel setBackgroundColor:[UIColor clearColor]];
    [self.positionIndexLabel setText:@"1"];
    [self.positionIndexLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.positionIndexLabel];
    
    self.itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, (kMaxHeightOfCell-20)/2, 120, 20)];
    [self.itemNameLabel setFont:[UIFont systemFontOfSize:18]];
    [self.itemNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.itemNameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.itemNameLabel];
    
    self.itemPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, (kMaxHeightOfCell-20)/2, 135, 20)];
    [self.itemPriceLabel setFont:[UIFont systemFontOfSize:18]];
    [self.itemPriceLabel setBackgroundColor:[UIColor clearColor]];
    [self.itemPriceLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.itemPriceLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
