//
//  PJNetWorkConst.h
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#ifndef PJNetWorkConst_h
#define PJNetWorkConst_h

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


#endif /* PJNetWorkConst_h */
