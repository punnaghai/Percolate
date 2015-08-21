//
//  CoffeeLocalStore.m
//  CoffeeBrew
//
//  Created by Punnaghai Puvi on 8/17/15.
//  Copyright (c) 2015 Punnaghai Puvi. All rights reserved.
//

#import "CoffeeLocalStore.h"
#import "MTLJSONAdapter.h"
#import "CoffeeConst.h"

@implementation CoffeeLocalStore

+ (void)cacheCoffeeTypes:(NSArray *)coffeeTypes
{
    NSBlockOperation *saveCoffeeOperation = [[NSBlockOperation alloc] init];
    NSBlockOperation *weakOp = saveCoffeeOperation;
    [saveCoffeeOperation addExecutionBlock:^(void){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            if (!weakOp.isCancelled) {
                [[self class] serializeCoffeeTypesToNSData:coffeeTypes completion:^(NSData *jsonData){
                    NSString *filePath = [[self class] filePathForCoffeeTypeKey:COFFEE_LIST];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [jsonData writeToFile:filePath atomically:YES];
                        
                    });
                }];
            }
        }];
    }];
    
    if (saveCoffeeOperation) {
        [[CoffeeConst sharedCoffeeOperationQueue] addOperation:saveCoffeeOperation];
    }
    
    if (!coffeeTypes) return;
    
}

+ (void)cacheCoffee:(CoffeeDetail *)coffee{
    NSBlockOperation *saveCoffeeOperation = [[NSBlockOperation alloc] init];
    NSBlockOperation *weakOp = saveCoffeeOperation;
    [saveCoffeeOperation addExecutionBlock:^(void){
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            if (!weakOp.isCancelled) {
                [[self class] serializeCoffeeToNSData:coffee completion:^(NSData *jsonData){
                    NSString *filePath = [[self class] filePathForCoffeeTypeKey:[coffee Identifier]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [jsonData writeToFile:filePath atomically:YES];
                        
                    });
                }];
            }
        }];
    }];
    
    if (saveCoffeeOperation) {
        [[CoffeeConst sharedCoffeeOperationQueue] addOperation:saveCoffeeOperation];
    }
    
}


+ (void) cachedCoffeeTypes :(void (^)(NSArray *coffeeList))block
{
    NSString *filePath = [self filePathForCoffeeTypeKey:COFFEE_LIST];
    if (!filePath || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        if (block) {
            block(nil);
        }
    }
    
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *jsonError;
    NSArray *coffeeListArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (block) {
        block([[self class] deserializeCoffeeTypesFromJSON:coffeeListArray]);
    }
}

+ (void) cachedCoffee:(NSString *)coffeeKey block:(void (^)(CoffeeDetail *coffee))block{
    NSString *filePath = [self filePathForCoffeeTypeKey:coffeeKey];
    if (!filePath || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        if (block) {
            block(nil);
        }
    }
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSError *jsonError;
    NSMutableDictionary *coffeeDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (block) {
        block([[self class] deserializeCoffeeFromJSON:coffeeDict]);
    }
}

+ (CoffeeDetail *)deserializeCoffeeFromJSON:(NSDictionary *)coffeeJSON
{
    NSError *error;
    CoffeeDetail *coffee = [MTLJSONAdapter modelOfClass:[CoffeeDetail class] fromJSONDictionary:coffeeJSON error:&error];
    if (error) {
        NSLog(@"Couldn't convert coffee JSON to Coffee models: %@", error);
        return nil;
    }
    
    return coffee;
}

+ (NSArray *)deserializeCoffeeTypesFromJSON:(NSArray *)coffeeTypesJSON
{
    NSError *error;
    NSArray *coffeeTypes = [MTLJSONAdapter modelsOfClass:[CoffeeDetail class] fromJSONArray:coffeeTypesJSON error:&error];
    if (error) {
        NSLog(@"Couldn't convert coffee JSON to Coffee models: %@", error);
        return nil;
    }
    
    return coffeeTypes;
}

+ (void)serializeCoffeeTypesToNSData:(NSArray *)coffeeTypes completion:(void(^)(NSData *jsonDictData))completion
{
    NSError *error;

    NSArray *coffeeTypesJSON = [MTLJSONAdapter JSONArrayFromModels:coffeeTypes error:nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:coffeeTypesJSON options:0 error:&error];
    
    if (error) {
        NSLog(@"Couldn't turn coffee types JSON into NSData. JSON: %@, \n\n Error: %@", coffeeTypesJSON, error);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(jsonData);
    });
}

+ (void) serializeCoffeeToNSData:(CoffeeDetail *)coffeeType completion:(void(^)(NSData *jsonDictData))completion{
    NSError *error;
    
    NSDictionary *coffeeDict = [MTLJSONAdapter JSONDictionaryFromModel:coffeeType error:nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:coffeeDict options:0 error:&error];
    
    if (error) {
        NSLog(@"Couldn't turn coffee types JSON into NSData. JSON: %@, \n\n Error: %@", coffeeType, error);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(jsonData);
    });
}

+ (NSString *)filePathForCoffeeTypeKey:(NSString *)appTypeKey
{
    NSString *directory = [CoffeeLocalStore pathForCacheDirectory];
    
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@%@", directory, appTypeKey, @".json"];
    return fullFilePath;
}

+ (NSString *)pathForCacheDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    if (! [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return cachePath;
}

+ (BOOL) checkIfFileExists :(NSString *)filename {
    
    NSString* documentsPath =[[self class] pathForCacheDirectory];
    
    NSString *fullFP = [NSString stringWithFormat:@"%@%@",filename,@".json"];
    
    NSString* jsonfile = [documentsPath stringByAppendingPathComponent:fullFP];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:jsonfile];
    
    return fileExists;
}

@end
