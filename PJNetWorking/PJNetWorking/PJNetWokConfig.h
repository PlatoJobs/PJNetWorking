//
//  PJNetWokConfig.h
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PJNetWokConfig : NSObject

+ (PJNetWokConfig *)pj_sharedConfig;

/** 请求基础 API */
@property (nonatomic, strong) NSString *generalURL;
/** 通用参数 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *generalParameters;
/** 通用请求头 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, NSString *> *generalHeaders;
/** 用户信息 */
@property (nonatomic, strong, nullable) NSDictionary *generalUserInfo;

@end

NS_ASSUME_NONNULL_END
