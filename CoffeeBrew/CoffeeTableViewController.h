//
//  ViewController.h
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/14/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoffeeTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

