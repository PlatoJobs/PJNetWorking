//
//  PJNetWokConfig.m
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import "PJNetWokConfig.h"

@implementation PJNetWokConfig

+ (PJNetWokConfig *)pj_sharedConfig {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
