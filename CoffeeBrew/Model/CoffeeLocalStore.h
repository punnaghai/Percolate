//
//  CoffeeLocalStore.h
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/17/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoffeeDetail.h"

@interface CoffeeLocalStore : NSObject

+ (void) cacheCoffee:(CoffeeDetail *)coffee;

+ (void) cacheCoffeeTypes:(NSArray *)coffeeTypes;

+ (void) cachedCoffeeTypes :(void (^)(NSArray *coffeeList))block;

+ (void) cachedCoffee:(NSString *)coffeeKey block:(void (^)(CoffeeDetail *coffee))block;

+ (BOOL) checkIfFileExists :(NSString *)filename;

@end
