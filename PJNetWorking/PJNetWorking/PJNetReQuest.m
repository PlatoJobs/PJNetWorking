//
//  PJNetReQuest.m
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import "PJNetReQuest.h"

@implementation PJNetFormDataModel


@end


@implementation PJNetReQuest

+ (instancetype)shareRequest{
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _requestType = PJNetRequestNormal;
    _methodType = PJServerHTTPMethodPOST;
    _requestSerializerType = PJNetRequestSerializerHTTP;
    _responseSerializerType = PJNetResponseSerializerJSON;
    _timeoutInterval = 60.0;
    
    _useGeneralServer = YES;
    _useGeneralHeaders = YES;
    _useGeneralParameters = YES;
    
    _retryCount = 0;
  
    return self;
}

- (void)pj_netCleanCallbackBlocks {
    _successBlock = nil;
    _failureBlock = nil;
    _progressBlock = nil;
}

@end
