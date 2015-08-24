//
//  CoffeeDetailsViewController.h
//  CoffeeBrew
// This view provides the details of the coffee with the last updated details
// The details will be cached whenever the network is available
// the cached contents will be accessed only when the network is not available
// if the contents are not available then an error msg is displayed & pushed to the list view
//  Created by Punnaghai Puvi on 8/15/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coffee.h"


@interface CoffeeDetailsViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, assign) NSString *coffeeId;
@property (nonatomic, strong) IBOutlet UILabel *cTitle;
@property (nonatomic, strong) IBOutlet UILabel *cDesc;
@property (nonatomic, strong) IBOutlet UIImageView *cImageView;
@property (nonatomic, strong) IBOutlet  UILabel *cLastUpdated;

@end
