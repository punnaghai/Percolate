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
    
    [self loadContents];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - helper methods

-(void) loadContents {
    
    
    BOOL cacheFileExists = [CoffeeLocalStore checkIfFileExists:self.coffeeId];
    if([CoffeeHelpers isNetworkAvailable]){
        [CoffeeManager getCoffeeDetails:self.coffeeId block:^(Coffee *coffee){
            if(!cacheFileExists)
                [CoffeeLocalStore cacheCoffee:coffee];
            [[NSNotificationCenter defaultCenter] postNotificationName:FETCH_RECORD_COMPLETE object:coffee];
        }];
    }
    else{
        if(cacheFileExists){
            [CoffeeLocalStore cachedCoffee:self.coffeeId block:^(Coffee *coffee){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:FETCH_RECORD_COMPLETE object:coffee];
            }];
        }
        else{
            
            [CoffeeHelpers RemoveObservers:FETCH_RECORD_COMPLETE forObject:self];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[[CoffeeHelpers sharedInstance] internetMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            
        }
        
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




@end
