//
//  CoffeeHelpers.h
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/17/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const API_KEY;
extern NSString * const APP_LOGO;
extern NSString * const COFFEE_LIST;

extern NSString * const FETCH_RECORD_COMPLETE;

@interface CoffeeHelpers : NSObject{
    NSDictionary * constDictionary;
}

@property (nonatomic, assign) NSString *apiKey;
@property (nonatomic, assign) NSString *appLogo;

+ (CoffeeHelpers *)sharedInstance;

- (UIImageView *) getNavigationImage;

+ (NSOperationQueue *)sharedCoffeeOperationQueue;

+ (void) RemoveObservers:(NSString *)observerName forObject:(id) observerObject;

+(BOOL) isNetworkAvailable;

+(void) downloadImageWithURL:(NSString *)imageUrl completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

@end
