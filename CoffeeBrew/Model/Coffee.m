//
//  Coffee.m
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/21/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import "Coffee.h"

@implementation Coffee

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"Identifier" : @"id",
             @"Name" : @"name",
             @"Desc" : @"desc",
             @"ImageURLString" : @"image_url",
             @"lastUpdated" : @"last_updated_at"
             };
}

@end
