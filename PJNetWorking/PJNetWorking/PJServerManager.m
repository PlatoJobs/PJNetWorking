//
//  PJServerManager.m
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import "PJServerManager.h"
#import "PJNetWokConfig.h"
#import "PJNetWorkConfigAgent.h"

@interface PJServerManager ()

@property (nonatomic, strong) PJNetWokConfig *config;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *runningBatchAndChainPool;
@property (nonatomic, strong) PJNetWorkConfigAgent *agent;


@end




@implementation PJServerManager

+ (instancetype)sharePJManager{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _config = [PJNetWokConfig pj_sharedConfig ];
        _agent = [PJNetWorkConfigAgent sharedAgentManager];
    }
    return self;
}

- (nullable NSString *)sendRequest:(PJNetRequestConfigBlock)configBlock
                        onProgress:(nullable PJNetProgressBlock)progressBlock
                         onSuccess:(nullable PJNetSuccessBlock)successBlock
                         onFailure:(nullable PJNetFailureBlock)failureBlock{
    PJNetReQuest *request = [PJNetReQuest shareRequest];
    PJ_SAFE_BLOCK(configBlock, request);
    
    [self configRequest:request
             onProgress:progressBlock
              onSuccess:successBlock
              onFailure:failureBlock];
    
    [self startRequest:request];
    
    return request.identifier;
}

#pragma mark -- Private Method

- (void)configRequest:(PJNetReQuest *)request
           onProgress:(PJNetProgressBlock)progressBlock
            onSuccess:(PJNetSuccessBlock)successBlock
            onFailure:(PJNetFailureBlock)failureBlock{
    if (successBlock) {
        request.successBlock = successBlock;
    }
    if (failureBlock) {
        request.failureBlock = failureBlock;
    }
    if (progressBlock && request.requestType != PJNetRequestNormal) {
        request.progressBlock = progressBlock;
    }
    
    if (request.useGeneralParameters && [PJNetWokConfig pj_sharedConfig].generalParameters.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters addEntriesFromDictionary:[PJNetWokConfig pj_sharedConfig].generalParameters];
        if (request.pj_netPramates.count > 0) {
            [parameters addEntriesFromDictionary:request.pj_netPramates];
        }
        request.pj_netPramates = parameters;
    }
    
    if (request.useGeneralHeaders && _config.generalHeaders.count > 0) {
        NSMutableDictionary *headers = [NSMutableDictionary dictionary];
        [headers addEntriesFromDictionary:_config.generalHeaders];
        if (request.pj_netHeaders) {
            [headers addEntriesFromDictionary:request.pj_netHeaders];
        }
        request.pj_netHeaders = headers;
    }
    
    if (request.pj_netRequestUrl.length == 0) {
        if (request.pj_api.length > 0) {
            NSURL *baseURL = [NSURL URLWithString:_config.generalURL];
            if ([[baseURL path] length] > 0 && ![[baseURL absoluteString] hasSuffix:@"/"]) {
                baseURL = [baseURL URLByAppendingPathComponent:@""];
            }
            request.pj_netRequestUrl = [[NSURL URLWithString:request.pj_api relativeToURL:baseURL] absoluteString];
        } else {
            request.pj_netRequestUrl = _config.generalURL;
        }
    }
    
    NSAssert(request.pj_netRequestUrl.length > 0, @"The request url can't be null.");
}


- (void)startRequest:(PJNetReQuest *)request{
    [[PJNetWorkConfigAgent sharedAgentManager] pj_callRequest:request completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [self callFailureBlockWithError:error forRequest:request];
        }else{
            [self callSuccessBlockWithResponse:responseObject forRequest:request];
        }
    }];
}


- (void)callFailureBlockWithError:(NSError *)error forRequest:(PJNetReQuest *)request{
    PJ_SAFE_BLOCK(request.failureBlock, error);
    [request pj_netCleanCallbackBlocks];
}

- (void)callSuccessBlockWithResponse:(id)responseObject forRequest:(PJNetReQuest *)request{
    PJ_SAFE_BLOCK(request.successBlock, responseObject);
    [request pj_netCleanCallbackBlocks];
}

- (void)cancelRequest:(NSString *)identifier
             onCancel:(nullable PJNetCancelBlock)cancelBlock{
    id request = nil;
    if (identifier.length > 0) {
        request = [self.agent pj_cancelRequestByIdentifier:identifier];
    }
}

#pragma mark -- Getter and Setter

- (NSMutableDictionary<NSString *, id> *)runningBatchAndChainPool {
    if (!_runningBatchAndChainPool) {
        _runningBatchAndChainPool = [NSMutableDictionary dictionary];
    }
    return _runningBatchAndChainPool;
}



@end
