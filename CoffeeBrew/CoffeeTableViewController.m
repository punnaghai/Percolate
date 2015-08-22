//
//  ViewController.m
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/14/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "CoffeeTableViewController.h"
#import "CoffeeDetailsViewController.h"
#import "CoffeeManager.h"
#import "Coffee.h"
#import "CoffeeCell.h"
#import "CoffeeHelpers.h"
#import "CoffeeLocalStore.h"
#import "UIRefreshControl+AFNetworking.h"

static NSString *coffeeCellIdentifier = @"CoffeeCell";

@implementation CoffeeTableViewController

@synthesize tableView;

NSArray *coffeeList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.navigationItem.titleView = [[CoffeeHelpers sharedInstance] getNavigationImage];
    
    [self loadContent];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [coffeeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [self galleryCellAtIndexPath:indexPath];
    
}

- (CoffeeCell *)galleryCellAtIndexPath:(NSIndexPath *)indexPath {
    CoffeeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:coffeeCellIdentifier forIndexPath:indexPath];
    [self configureImageCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureImageCell:(CoffeeCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
        Coffee *coffee = [self getCoffeeDetails:indexPath];
        cell.title.text =coffee.Name;
        cell.desc.text = coffee.Desc;
    
    if([coffee.ImageURLString isEqualToString:@""]){
        [cell.imageView removeFromSuperview];
    }
    else{
        [CoffeeHelpers downloadImageWithURL:coffee.ImageURLString completionBlock:^(BOOL succeeded, UIImage *image){
            if (succeeded) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.coffeeImage setImage:image];
                    
                });
            }
        }];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForCellAtIndexPath:indexPath];
}

- (CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    
    static CoffeeCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:coffeeCellIdentifier];
    });
    
    [self configureImageCell:cell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCoffeeDetail"]) {
        
       NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
       Coffee *selCoffee = [self getCoffeeDetails:indexPath];
       CoffeeDetailsViewController *destViewController = segue.destinationViewController;
        destViewController.coffeeId = selCoffee.Identifier;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark helper methods

- (void)loadContent {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchRecordComplete:) name:FETCH_RECORD_COMPLETE object:nil];
    
    BOOL cacheFileExists = [CoffeeLocalStore checkIfFileExists:COFFEE_LIST];
    if([CoffeeHelpers isNetworkAvailable]){
        [CoffeeManager getCoffeeList:^(NSArray *records){
            if(!cacheFileExists)
                [CoffeeLocalStore cacheCoffeeTypes:records];
            [[NSNotificationCenter defaultCenter] postNotificationName:FETCH_RECORD_COMPLETE object:records];
        }];
    }
    else{
        if(cacheFileExists){
            [CoffeeLocalStore cachedCoffeeTypes:^(NSArray *records){
        
                [[NSNotificationCenter defaultCenter] postNotificationName:FETCH_RECORD_COMPLETE object:records];
            }];
        }
        else{
            
            [CoffeeHelpers RemoveObservers:FETCH_RECORD_COMPLETE forObject:self];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Internet Connection Avaialble" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
        
    }
}

-(void) fetchRecordComplete:(NSNotification*)notification{
    
    if(notification.object == nil)
        return;
    
    coffeeList = (NSArray *)notification.object;
    
    [self.tableView reloadData];
    [CoffeeHelpers RemoveObservers:FETCH_RECORD_COMPLETE forObject:self];
    
}

-(Coffee *) getCoffeeDetails:(NSIndexPath *) indexPath {
    Coffee *coffeeItem = [coffeeList objectAtIndex:indexPath.row];
    
    return coffeeItem;
}




#pragma end
@end
