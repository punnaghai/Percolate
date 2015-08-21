//
//  CoffeeConst.m
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/17/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import "CoffeeConst.h"
#import "AppDelegate.h"
#import "Reachability.h"

NSString * const API_KEY = @"api_key";

NSString * const APP_LOGO = @"app_logo";

NSString * const FETCH_RECORD_COMPLETE = @"fetchRecordComplete";

NSString * const COFFEE_LIST = @"coffeelist";

@implementation CoffeeConst

-(NSString *) apiKey {
    if(_apiKey == nil){
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        _apiKey = [delegate.dConstants valueForKey:API_KEY];
    }
    
    return _apiKey;
}

-(NSString *) appLogo {
    if(_appLogo == nil){
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        _appLogo = [delegate.dConstants valueForKey:APP_LOGO];
    }
    
    return _appLogo;
}

+ (CoffeeConst *)sharedInstance
{
    static CoffeeConst * _sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}

- (UIImageView *) getNavigationImage {
    NSString *appLogo = [[CoffeeConst sharedInstance] appLogo];
    UIImage *logo = [UIImage imageNamed:appLogo];
    UIImage *newImage = [self imageWithImage:logo];
    UIImageView *imageView =  [[UIImageView alloc] initWithImage:newImage];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return imageView;
}

- (UIImage *)imageWithImage:(UIImage *)image {
    CGSize newSize = CGSizeMake(image.size.width/6, image.size.height/6);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSOperationQueue *)sharedCoffeeOperationQueue {
    static NSOperationQueue *_sharedCoffeeOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCoffeeOperationQueue = [[NSOperationQueue alloc] init];
        [_sharedCoffeeOperationQueue setMaxConcurrentOperationCount:8];
    });
    
    return _sharedCoffeeOperationQueue;
}

+ (void) RemoveObservers:(NSString *)observerName forObject:(id) observerObject{
    [[NSNotificationCenter defaultCenter] removeObserver:observerObject name:observerName object:nil];
}

+(BOOL) isNetworkAvailable
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return FALSE;
    }
    return TRUE;
}


@end
