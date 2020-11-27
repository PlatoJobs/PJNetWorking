//
//  PJNetReQuest.h
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import <Foundation/Foundation.h>
#import "PJNetWorkConst.h"

NS_ASSUME_NONNULL_BEGIN
@interface PJNetFormDataModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, nullable) NSString *fileName;
@property (nonatomic, copy, nullable) NSString *mimeType;
@property (nonatomic, strong, nullable) NSData *fileData;
@property (nonatomic, strong, nullable) NSURL *fileURL;


@end


@interface PJNetReQuest : NSObject

+(instancetype)shareRequest;

@property(nonatomic,copy,nullable)NSString *pj_baseURL;

@property(nonatomic,copy,nullable)NSString *pj_api;

@property(nonatomic,copy,nullable)NSString *pj_netRequestUrl;

@property(nonatomic,strong,nullable)NSDictionary<NSString*,id> *pj_netPramates;

@property(nonatomic,strong,nullable)NSDictionary<NSString*,NSString*> *pj_netHeaders;

@property (nonatomic, copy, readonly) NSString *identifier;

@property(nonatomic,assign)NSTimeInterval timeoutInterval;

@property(nonatomic,assign)NSUInteger retryCount;

@property (nonatomic, assign) PJNetRequestType requestType;

@property (nonatomic, assign) PJServerHTTPMethodType methodType;

@property (nonatomic, assign) PJNetRequestSerializerType requestSerializerType;

@property (nonatomic, assign) PJNetResponseSerializerType responseSerializerType;

@property (nonatomic, strong) NSMutableArray<PJNetFormDataModel *> *formDatas;

@property (nonatomic, assign) BOOL useGeneralServer;
@property (nonatomic, assign) BOOL useGeneralHeaders;
@property (nonatomic, assign) BOOL useGeneralParameters;

@property (nonatomic, copy, nullable) PJNetSuccessBlock successBlock;
@property (nonatomic, copy, nullable) PJNetFailureBlock failureBlock;
@property (nonatomic, copy, nullable) PJNetProgressBlock progressBlock;

- (void)pj_netCleanCallbackBlocks;



@end

NS_ASSUME_NONNULL_END
