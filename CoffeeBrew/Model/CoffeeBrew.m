//
//  CoffeeBrew.m
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/16/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import "CoffeeBrew.h"
#import "CoffeeConst.h"

NSString * const kCoffeeBaseURLString = @"https://coffeeapi.percolate.com/";
NSString * const kCoffeeListString = @"api/coffee/";
NSString * const kCoffeeDetails = @"api/coffee/%@";

@implementation CoffeeBrew

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (NSOperationQueue *)sharedCoffeeRequestOperationQueue {
    static NSOperationQueue *_sharedCoffeeRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCoffeeRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_sharedCoffeeRequestOperationQueue setMaxConcurrentOperationCount:8];
    });
    
    return _sharedCoffeeRequestOperationQueue;
}

+(void) getCoffeeList :(void (^)(NSArray *records))block{
    NSString *fullCoffeeListString = [NSString stringWithFormat:@"%@%@",kCoffeeBaseURLString,kCoffeeListString];
    NSString *apikey = [[CoffeeConst sharedInstance] apiKey];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullCoffeeListString]];
    [mutableRequest setValue:apikey forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *coffeelistRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
    coffeelistRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [coffeelistRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject isKindOfClass:[NSArray class]]){
            NSArray *data = (NSArray *)responseObject;
            
            NSArray *coffeeData = [MTLJSONAdapter modelsOfClass:CoffeeDetail.class fromJSONArray:data error:nil];
            
            if (block) {
                block(coffeeData);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error.localizedDescription);
    }];
    
    [[[self class] sharedCoffeeRequestOperationQueue] addOperation:coffeelistRequestOperation];
}

+(void) getCoffeeDetails:(NSString *)coffeeId block:(void (^)(CoffeeDetail *coffee))block{
    
    NSString *coffeeIdUrl = [NSString stringWithFormat:kCoffeeDetails,coffeeId];
    NSString *fullCoffeeListString = [NSString stringWithFormat:@"%@%@",kCoffeeBaseURLString,coffeeIdUrl];
    NSString *apikey = [[CoffeeConst sharedInstance] apiKey];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fullCoffeeListString]];
    [mutableRequest setValue:apikey forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *coffeelistRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
    coffeelistRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [coffeelistRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *data = (NSDictionary *)responseObject;
            
            CoffeeDetail *cDetail = [MTLJSONAdapter modelOfClass:CoffeeDetail.class fromJSONDictionary:data error:nil];
            
            if (block) {
                block(cDetail);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error.localizedDescription);
    }];
    
    [[[self class] sharedCoffeeRequestOperationQueue] addOperation:coffeelistRequestOperation];
}

@end
