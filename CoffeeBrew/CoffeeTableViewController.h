//
//  ViewController.h
//  CoffeeBrew
//  Displays the list of coffees available with a short description about the same
//  If network is not available the  the cached contents will be picked & displayed
//  Created by Punnaghai Puvi on 8/14/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoffeeTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

