//
//  CoffeeBrew.h
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/16/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "CoffeeDetail.h"

extern NSString * const kCoffeeBaseURLString;
extern NSString * const kCoffeeListString;
extern NSString * const kCoffeeDetails;

@interface CoffeeBrew : NSObject

//+ (CoffeeBrew *)sharedClient;
+(void) getCoffeeList:(void (^)(NSArray *records))block;
+(void) getCoffeeDetails:(NSString *)coffeeId block:(void (^)(CoffeeDetail *coffee))block;

@end
