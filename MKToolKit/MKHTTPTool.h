//
//  MKHTTPTool.h
//  Shutterbug
//
//  Created by Mark Lewis on 16-8-13.
//  Copyright (c) 2016年 MarkLewis. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^RequestFinishedBlock) (id result);

@interface MKHTTPTool : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, copy) RequestFinishedBlock finshedBlock; //note
@property (nonatomic, strong) NSMutableData *receiveData; //note

+ (instancetype)shareInstance;

- (void)requestWithURL:(NSString *)urlstring
               params:(NSMutableDictionary *)params
           httpMethod:(NSString *)httpMethod
        completeBlock:(RequestFinishedBlock)block;

@end
