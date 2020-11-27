//
//  PJSeralRequest.m
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import "PJSeralRequest.h"
#import "PJNetReQuest.h"
@interface PJSeralRequest (){
    NSUInteger _pjIndex;
}

@property (nonatomic, strong) NSMutableArray<PJNetMutilRepsNextBlock> *nextBlockArray;
@property (nonatomic, strong) NSMutableArray *responseArray;



@end

@implementation PJSeralRequest

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _pjIndex = 0;
    _responseArray = [NSMutableArray array];
    _nextBlockArray = [NSMutableArray array];
    
    NSLog(@"%@: %s", self, __FUNCTION__);
    
    return self;
}


- (PJSeralRequest *)firstRequset:(PJNetRequestConfigBlock)firstBlock {
    _seralCurrentRequest = [[PJNetReQuest alloc] init];
    firstBlock(_seralCurrentRequest);
    [_responseArray addObject:[NSNull null]];
    return self;
}

- (PJSeralRequest *)nextRequest:(PJNetMutilRepsNextBlock)nextBlock {
    [_nextBlockArray addObject:nextBlock];
    [_responseArray addObject:[NSNull null]];
    return self;
}

- (BOOL)doneOneRequest:(PJNetReQuest *)request response:(id)responseObject error:(NSError *)error{
    BOOL isFinished = NO;
    if (responseObject) {
        [_responseArray replaceObjectAtIndex:_pjIndex withObject:responseObject];
    }
    return isFinished;
}

- (void)cleanCallbackBlocks {
    _seralCurrentRequest = nil;
    _chainSuccessBlock = nil;
    _chainFailureBlock = nil;
    [_nextBlockArray removeAllObjects];
}


@end
