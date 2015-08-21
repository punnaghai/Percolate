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
#import "CoffeeBrew.h"
#import "CoffeeDetail.h"
#import "CoffeeCell.h"
#import "CoffeeConst.h"
#import "CoffeeLocalStore.h"
#import "UIRefreshControl+AFNetworking.h"

static NSString *coffeeCellIdentifier = @"CoffeeCell";

@interface CoffeeTableViewController ()

-(CoffeeDetail *) getCoffeeDetails:(NSIndexPath *) indexPath;
-(void) loadContent;

@end

@implementation CoffeeTableViewController

@synthesize tableView;

NSArray *coffeeList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.navigationItem.titleView = [[CoffeeConst sharedInstance] getNavigationImage];
    
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
    
        CoffeeDetail *coffee = [self getCoffeeDetails:indexPath];
        cell.title.text =coffee.Name;
        cell.desc.text = coffee.Desc;
    
    if([coffee.ImageURLString isEqualToString:@""]){
        [cell.imageView removeFromSuperview];
    }
    else{
    
    //Create a block operation for loading the image into the profile image view
    NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
    //Define weak operation so that operation can be referenced from within the block without creating a retain cycle
    __weak NSBlockOperation *weakOp = loadImageIntoCellOp;
    [loadImageIntoCellOp addExecutionBlock:^(void){
        
        NSURL *imageUrl = [NSURL URLWithString:coffee.ImageURLString];
        
        //Once the image is ready, it will load into view on the main queue
        UIImage *coffeeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            //Check for cancelation before proceeding. We use cellForRowAtIndexPath to make sure we get nil for a non-visible cell
            if (!weakOp.isCancelled) {
                [cell.coffeeImage setImage:coffeeImage];
            }
        }];
    }];
    
    //Add the operation to the designated background queue
    if (loadImageIntoCellOp) {
        [[CoffeeConst sharedCoffeeOperationQueue] addOperation:loadImageIntoCellOp];
    }
    
    //Make sure cell doesn't contain any traces of data from reuse -
    cell.coffeeImage.image = nil;
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
       CoffeeDetail *selCoffee = [self getCoffeeDetails:indexPath];
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
    
    if(![CoffeeLocalStore checkIfFileExists:COFFEE_LIST] && [CoffeeConst isNetworkAvailable]){
        //file doesnt exist in cache
        
        [CoffeeBrew getCoffeeList:^(NSArray *records){
            
            [CoffeeLocalStore cacheCoffeeTypes:records];
            [[NSNotificationCenter defaultCenter] postNotificationName:FETCH_RECORD_COMPLETE object:records];
        }];
    }
    else{
        //file exists in cache
        [CoffeeLocalStore cachedCoffeeTypes:^(NSArray *records){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:FETCH_RECORD_COMPLETE object:records];
        }];
        
    }
    
//    [CoffeeBrew getCoffeeList:^(NSArray *records){
//        coffeeList = records;
//        [self.tableView reloadData];
//    }];
}

-(void) fetchRecordComplete:(NSNotification*)notification{
    
    if(notification.object == nil)
        return;
    
    coffeeList = (NSArray *)notification.object;
    
    [self.tableView reloadData];
    [CoffeeConst RemoveObservers:FETCH_RECORD_COMPLETE forObject:self];
    
}

-(CoffeeDetail *) getCoffeeDetails:(NSIndexPath *) indexPath {
    CoffeeDetail *coffeeItem = [coffeeList objectAtIndex:indexPath.row];
    
    return coffeeItem;
}

#pragma end
@end
