//
//  CoffeeManager.h
//  CoffeeBrew
//  The manager which makes the networking calls to get the coffee list & details
//  Created by Punnaghai Puvi on 8/16/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Coffee.h"

extern NSString * const kCoffeeBaseURLString;
extern NSString * const kCoffeeListString;
extern NSString * const kCoffeeDetails;

@interface CoffeeManager : NSObject

//Gets the coffeelist from the service
//converts the coffeelist to array of custom coffee objects & returns the same
+(void) getCoffeeList:(void (^)(NSArray *records))block;

//gets the coffeedetails from the service
//converts the cofeedetails dict to custom coffee object & return the same
+(void) getCoffeeDetails:(NSString *)coffeeId block:(void (^)(Coffee *coffee))block;

@end
