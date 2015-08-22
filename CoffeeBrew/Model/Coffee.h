//
//  Coffee.h
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/21/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTLJSONAdapter.h"
#import "MTLModel.h"

@interface Coffee : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *Identifier;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ImageURLString;
@property (nonatomic, copy) NSString *Desc;
@property (nonatomic, copy) NSString *lastUpdated;

@end

