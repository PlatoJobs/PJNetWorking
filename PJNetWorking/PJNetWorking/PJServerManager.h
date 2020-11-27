//
//  PJServerManager.h
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

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


@end

NS_ASSUME_NONNULL_END
