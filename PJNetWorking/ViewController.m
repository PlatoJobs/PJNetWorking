//
//  ViewController.m
//  PJNetWorking
//
//  Created by Jobs Plato on 2020/11/26.
//

#import "ViewController.h"
#import "PJServerManager.h"
#import "PJNetReQuest.h"
#import "PJNetWorkConfigAgent.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PJServerManager sharePJManager] sendRequest:^(PJNetReQuest *request) {
        request.pj_netRequestUrl = @"http://v.juhe.cn/toutiao/index";
        request.methodType = PJServerHTTPMethodGET;
    } onProgress:^(NSProgress *progress) {
        
    } onSuccess:^(id  _Nullable responseObject) {
        NSLog(@"responseObject -- %@",responseObject);
    } onFailure:^(NSError * _Nullable error) {
        NSLog(@"error--- %@,error",error);
    }];
    
    // Do any additional setup after loading the view.
}


@end
