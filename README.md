# PJNetWorking
网络请求封装

#### 自定义的一些`block`和`枚举值`

```objc
@class PJNetReQuest;

typedef NS_ENUM(NSInteger, PJNetRequestType) {
    PJNetRequestNormal    = 0,
    PJNetRequestUpload    = 1
};

typedef NS_ENUM(NSInteger, PJNetRequestSerializerType) {
    PJNetRequestSerializerHTTP     = 0,
    PJNetRequestSerializerJSON    = 1,
};

typedef NS_ENUM(NSInteger, PJNetResponseSerializerType) {
    PJNetResponseSerializerHTTP    = 0,
    PJNetResponseSerializerJSON   = 1,
    PJNetResponseSerializerXMLParser = 2
};

typedef NS_ENUM(NSInteger, PJServerHTTPMethodType) {
    PJServerHTTPMethodGET    = 0,
    PJServerHTTPMethodPOST   = 1,
    PJServerHTTPMethodHEAD   = 2,
    PJServerHTTPMethodDELETE = 3,
    PJServerHTTPMethodPUT    = 4,
    PJServerHTTPMethodPATCH  = 5,
};

typedef void (^PJNetProgressBlock)(NSProgress * _Nullable progress);
typedef void (^PJNetSuccessBlock)(id _Nullable responseObject);
typedef void (^PJNetFailureBlock)(NSError * _Nullable error);
typedef void (^PJNetFinishedBlock)(id _Nullable responseObject, NSError * _Nullable error);

typedef void (^PJNetRequestConfigBlock)(PJNetReQuest * _Nullable request);

typedef void (^PJNetProgressBlock)(NSProgress * _Nullable   progress);
typedef void (^PJNetSuccessBlock)(id _Nullable responseObject);
typedef void (^PJNetFailureBlock)(NSError * _Nullable error);
typedef void (^PJNetFinishedBlock)(id _Nullable responseObject, NSError * _Nullable error);
typedef void (^PJNetCancelBlock)(id _Nullable request);


typedef void (^PJNetMutilRepSuccessBlock)(NSArray * _Nullable responseObjects);
typedef void (^PJNetMutilRepFailureBlock)(NSArray * _Nullable   errors);
typedef void (^PJNetMutilRepsNextBlock)(PJNetReQuest * _Nullable request, id _Nullable responseObject, BOOL * _Nullable isSent);

typedef void (^PJAgentCompletionHandler) (id _Nullable responseObject, NSError * _Nullable error);


#define PJ_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })


```

##### 主要请求类 

```objc

#import <Foundation/Foundation.h>
#import "PJNetWorkConst.h"
#import "PJNetReQuest.h"
#import "PJSeralRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface PJServerManager : NSObject


+ (instancetype)sharePJManager;
//保存和调用 Block
- (nullable NSString *)sendRequest:(PJNetRequestConfigBlock)configBlock
                        onProgress:(nullable PJNetProgressBlock)progressBlock
                         onSuccess:(nullable PJNetSuccessBlock)successBlock
                         onFailure:(nullable PJNetFailureBlock)failureBlock;



- (void)cancelRequest:(NSString *)identifier;

- (void)cancelRequest:(NSString *)identifier
             onCancel:(nullable PJNetCancelBlock)cancelBlock;




```


##### usage

```objc

[[PJServerManager sharePJManager] sendRequest:^(PJNetReQuest *request) {
    request.pj_netRequestUrl = @"http://v.juhe.cn/toutiao/index";
    request.methodType = PJServerHTTPMethodGET;
} onProgress:^(NSProgress *progress) {
    
} onSuccess:^(id  _Nullable responseObject) {
    NSLog(@"responseObject -- %@",responseObject);
} onFailure:^(NSError * _Nullable error) {
    NSLog(@"error--- %@,error",error);
}];

```
