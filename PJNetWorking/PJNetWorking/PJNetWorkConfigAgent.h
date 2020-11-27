//
//  PJNetWorkConfigAgent.h
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import <Foundation/Foundation.h>
#import "PJNetWorkConst.h"

NS_ASSUME_NONNULL_BEGIN


@class PJNetReQuest;

@interface PJNetWorkConfigAgent : NSObject

-(instancetype)init NS_UNAVAILABLE;
+(instancetype)new NS_UNAVAILABLE;

+(PJNetWorkConfigAgent*)sharedAgentManager;

- (void)pj_callRequest:(PJNetReQuest *)request completionHandler:(PJAgentCompletionHandler)completionHandler;

- (nullable PJNetReQuest *)pj_cancelRequestByIdentifier:(NSString *)identifier;


@end

NS_ASSUME_NONNULL_END
