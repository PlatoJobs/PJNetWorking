//
//  PJNetWorkConfigAgent.m
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import "PJNetWorkConfigAgent.h"
#import <objc/runtime.h>
#import "AFNetworking.h"
#import "PJNetReQuest.h"

@interface NSURLSessionTask (PJBindRequest)

@property (nonatomic, strong) PJNetReQuest *pj_bindedRequest;


@end

@implementation NSURLSessionTask (PJBindRequest)


-(PJNetReQuest *)pj_bindedRequest {
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setPj_bindedRequest:(PJNetReQuest *)pj_bindedRequest{
    objc_setAssociatedObject(self, @selector(pj_bindedRequest), pj_bindedRequest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


@interface PJNetWorkConfigAgent()

{
    
    dispatch_semaphore_t _pjLock;
}

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) dispatch_queue_t completionQueue;
@property (nonatomic, strong) AFJSONResponseSerializer *jsonResponseSerializer;
@property (nonatomic, strong) AFXMLParserResponseSerializer *xmlParserResponseSerialzier;


@end

@implementation PJNetWorkConfigAgent

+(PJNetWorkConfigAgent*)sharedAgentManager{
    
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _pjLock = dispatch_semaphore_create(1);
        _completionQueue = dispatch_queue_create("com.platojobs.queue", DISPATCH_QUEUE_CONCURRENT);
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:nil];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.completionQueue = _completionQueue;
    }
    return self;
}

#pragma mark -- Public Method

- (void)pj_callRequest:(PJNetReQuest *)request completionHandler:(PJAgentCompletionHandler)completionHandler{
    if (request.requestType == PJNetRequestNormal) {
        [self dataTaskWithRequest:request completionHandler:completionHandler];
    }else if(request.requestType == PJNetRequestUpload){
        //多表单的提交
        [self uploadTaskWithRequest:request completionHandler:completionHandler];
    }else{
        NSAssert(NO, @"UnKnow Type");
    }
}

#pragma mark -- Private Method

- (void)dataTaskWithRequest:(PJNetReQuest *)request
          completionHandler:(PJAgentCompletionHandler)completionHandler{
    NSString *httpMethod = nil;
    static dispatch_once_t onceToken;
    static NSArray *httpMethodArray = nil;
    dispatch_once(&onceToken, ^{
        httpMethodArray = @[@"GET", @"POST", @"HEAD", @"DELETE", @"PUT", @"PATCH"];
    });
    if (request.methodType >= 0 && request.methodType < httpMethodArray.count) {
        httpMethod = httpMethodArray[request.methodType];
    }
    NSAssert(httpMethod.length > 0, @"The HTTP method not found.");
    
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:httpMethod
                                                                 URLString:request.pj_netRequestUrl
                                                                parameters:request.pj_netPramates
                                                                     error:&serializationError];
    if (serializationError) {
        if (completionHandler) {
            dispatch_async(_completionQueue, ^{
                completionHandler(nil, serializationError);
            });
        }
        return;
    }
    
    NSURLSessionDataTask *dataTask = nil;
    __weak __typeof(self)weakSelf = self;
    dataTask = [_manager dataTaskWithRequest:urlRequest
                                    uploadProgress:nil
                                  downloadProgress:nil
                                 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                     __strong __typeof(weakSelf)strongSelf = weakSelf;
                                     [strongSelf handleResponseResult:response
                                                               object:responseObject
                                                                error:error
                                                              request:request
                                                    completionHandler:completionHandler];
                                 }];
    [self setIdentifierWithRequest:request taskIdentifier:dataTask.taskIdentifier];
    [dataTask resume];
}

- (void)uploadTaskWithRequest:(PJNetReQuest *)request
            completionHandler:(PJAgentCompletionHandler)completionHandler{
    
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    __block NSError *serializationError = nil;
    
    NSMutableURLRequest *urlRequest = [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                              URLString:request.pj_netRequestUrl
                                                                             parameters:request.pj_netPramates
                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
              [request.formDatas enumerateObjectsUsingBlock:^(PJNetFormDataModel *obj, NSUInteger idx, BOOL *stop) {
                  if (obj.fileData) {
                      if (obj.fileName && obj.mimeType) {
                          [formData appendPartWithFileData:obj.fileData name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
                      } else {
                          [formData appendPartWithFormData:obj.fileData name:obj.name];
                      }
                  } else if (obj.fileURL) {
                      NSError *fileError = nil;
                      if (obj.fileName && obj.mimeType) {
                          [formData appendPartWithFileURL:obj.fileURL name:obj.name fileName:obj.fileName mimeType:obj.mimeType error:&fileError];
                      } else {
                          [formData appendPartWithFileURL:obj.fileURL name:obj.name error:&fileError];
                      }
                      if (fileError) {
                          serializationError = fileError;
                          *stop = YES;
                      }
                  }
              }];
        } error:&serializationError];
    
    if (serializationError) {
        if (completionHandler) {
            dispatch_async(_completionQueue, ^{
                completionHandler(nil, serializationError);
            });
        }
        return;
    }
    
    NSURLSessionUploadTask *uploadTask = nil;
    __weak __typeof(self)weakSelf = self;
    uploadTask = [_manager uploadTaskWithStreamedRequest:urlRequest
                                                progress:request.progressBlock
                                       completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                                           [strongSelf handleResponseResult:response
                                                               object:responseObject
                                                                error:error
                                                              request:request
                                                    completionHandler:completionHandler];
                }];
    
    [self setIdentifierWithRequest:request taskIdentifier:uploadTask.taskIdentifier];
    [uploadTask resume];
}

- (void)handleResponseResult:(NSURLResponse *)response
                      object:(id)responseObject
                       error:(NSError *)error
                     request:(PJNetReQuest *)request
           completionHandler:(PJAgentCompletionHandler)completionHandler{
    NSError *responseError = nil;
 
    if (request.responseSerializerType != PJNetRequestSerializerHTTP) {
        AFHTTPResponseSerializer *responseSerializer = [self responseSerializerForRequest:request];
        responseObject = [responseSerializer responseObjectForResponse:response data:responseObject error:&responseError];
    }
    
    if (completionHandler) {
        if (responseError) {
            completionHandler(nil, responseError);
        } else {
            completionHandler(responseObject, error);
        }
    }
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(PJNetReQuest *)request{
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == PJNetRequestSerializerHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }else if(request.requestSerializerType == PJNetRequestSerializerJSON){
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = request.timeoutInterval;
    
    if (request.pj_netHeaders.count > 0) {
        [request.pj_netHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
            [requestSerializer setValue:value forHTTPHeaderField:field];
        }];
    }
    
    return requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializerForRequest:(PJNetReQuest *)request{
    if (request.responseSerializerType == PJNetResponseSerializerJSON) {
        return self.jsonResponseSerializer;
    }else if(request.responseSerializerType == PJNetResponseSerializerXMLParser){
        return self.xmlParserResponseSerialzier;
    }else{
        return nil;
    }
}

- (void)setIdentifierWithRequest:(PJNetReQuest *)request
                  taskIdentifier:(NSUInteger)taskIdentifier{
    NSString *identifier = [NSString stringWithFormat:@"+%lu", (unsigned long)taskIdentifier];
    [request setValue:identifier forKey:@"_identifier"];
}


- (nullable PJNetReQuest *)cancelRequestByIdentifier:(NSString *)identifier{
    PJNetReQuest *request = nil;
    return request;
}

#pragma mark -- Getter And Setter

- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier {
    if (!_xmlParserResponseSerialzier) {
        _xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
    }
    return _xmlParserResponseSerialzier;
}



@end
