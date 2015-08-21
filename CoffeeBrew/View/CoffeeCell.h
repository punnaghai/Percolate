//
//  CoffeeCell.h
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/16/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoffeeCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *desc;
@property (nonatomic, retain) IBOutlet UIImageView *coffeeImage;

@end
