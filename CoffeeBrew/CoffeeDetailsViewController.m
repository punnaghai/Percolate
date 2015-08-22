//
//  CoffeeDetailsViewController.m
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/15/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import "CoffeeDetailsViewController.h"
#import "CoffeeManager.h"
#import "UIImageView+AFNetworking.h"
#import "CoffeeHelpers.h"
#import "CoffeeLocalStore.h"

@implementation CoffeeDetailsViewController

@synthesize coffeeId;
@synthesize cTitle;
@synthesize cDesc;
@synthesize cImageView;
@synthesize cLastUpdated;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchRecordComplete:) name:FETCH_RECORD_COMPLETE object:nil];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    self.navigationItem.titleView = [[CoffeeHelpers sharedInstance] getNavigationImage];
    
    if(![CoffeeLocalStore checkIfFileExists:coffeeId] && [CoffeeHelpers isNetworkAvailable]){
        //file doesnt exist in cache
        
        [CoffeeManager getCoffeeDetails:self.coffeeId block:^(Coffee *coffee){
            [CoffeeLocalStore cacheCoffee:coffee];
            [[NSNotificationCenter defaultCenter] postNotificationName:FETCH_RECORD_COMPLETE object:coffee];
        }];
    }
    else{
        //file exists in cache
        [CoffeeLocalStore cachedCoffee:self.coffeeId block:^(Coffee *coffee){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FETCH_RECORD_COMPLETE object:coffee];
        }];
        
    }
}

-(void) fetchRecordComplete:(NSNotification*)notification{
    if(notification.object == nil)
        return;
    Coffee *coffee = (Coffee *)notification.object;
    
    cTitle.text = coffee.Name;
    cDesc.text = coffee.Desc;
    cLastUpdated.text = coffee.lastUpdated;
    if([coffee.ImageURLString isEqual:@""]){
        [cImageView removeFromSuperview];
    }
    else{
        
        [CoffeeHelpers downloadImageWithURL:coffee.ImageURLString completionBlock:^(BOOL succeeded, UIImage *image){
            if (succeeded) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cImageView setImage:image];
                    
                });
            }
        }];
    }
    
    [CoffeeHelpers RemoveObservers:FETCH_RECORD_COMPLETE forObject:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
