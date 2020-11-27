//
//  PJSeralRequest.h
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import <Foundation/Foundation.h>
#import "PJNetWorkConst.h"

@class PJNetReQuest;


NS_ASSUME_NONNULL_BEGIN

@interface PJSeralRequest : NSObject


@property (nonatomic, copy) PJNetMutilRepSuccessBlock chainSuccessBlock;
@property (nonatomic, copy) PJNetMutilRepFailureBlock chainFailureBlock;

@property (nonatomic, copy, readonly) NSString *seralIdentifier;
@property (nonatomic, strong, readonly) PJNetReQuest *seralCurrentRequest;

- (PJSeralRequest *)firstRequset:(PJNetRequestConfigBlock)firstBlock;
- (PJSeralRequest *)nextRequest:(PJNetMutilRepsNextBlock)nextBlock;

- (BOOL)doneOneRequest:(PJNetReQuest *)request response:(nullable id)responseObject error:(nullable NSError *)error;




@end

NS_ASSUME_NONNULL_END
