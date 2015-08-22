//
//  CoffeeDetailsViewController.h
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/15/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coffee.h"


@interface CoffeeDetailsViewController : UIViewController

@property (nonatomic, assign) NSString *coffeeId;
@property (nonatomic, strong) IBOutlet UILabel *cTitle;
@property (nonatomic, strong) IBOutlet UILabel *cDesc;
@property (nonatomic, strong) IBOutlet UIImageView *cImageView;
@property (nonatomic, strong) IBOutlet  UILabel *cLastUpdated;


@end
