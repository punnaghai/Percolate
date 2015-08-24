//
//  CoffeeLocalStore.h
//  CoffeeBrew
//  This class stores the coffee list & details in the cache & fetches the same when requested
//  Created by Punnaghai Puvi on 8/17/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coffee.h"

@interface CoffeeLocalStore : NSObject


//Caches the coffee details of the selected coffee
+ (void) cacheCoffee:(Coffee *)coffee;

//Caches the coffee list for offline use
+ (void) cacheCoffeeTypes:(NSArray *)coffeeTypes;

// Fecthes the coffee list from cache
+ (void) cachedCoffeeTypes :(void (^)(NSArray *coffeeList))block;

//Fetches the coffee details from the cache
+ (void) cachedCoffee:(NSString *)coffeeKey block:(void (^)(Coffee *coffee))block;

// checks if the file exists in cache
+ (BOOL) checkIfFileExists :(NSString *)filename;

@end
