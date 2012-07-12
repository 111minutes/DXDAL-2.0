//
//  NJDXDALHTTPOperation.h
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJDXDALOperation.h"

@class NJDXDALHTTPOperation;

@protocol NJDXDALHTTPOperationDelegate <NSObject>

-(void)startOperation:(NJDXDALHTTPOperation*)op;
-(void)loadingFinished:(NJDXDALHTTPOperation*)op;

@end



@interface NJDXDALHTTPOperation : NJDXDALOperation <NSURLConnectionDelegate>

@property (nonatomic,strong) NSMutableURLRequest* request;
@property (nonatomic,readonly) BOOL isExecuting;
@property (nonatomic,assign) BOOL isFinished; 
@property (nonatomic,readonly) BOOL isCancelled;

@property (nonatomic,copy) NSString* httpMethod;
@property (nonatomic,copy) NSString* httpPath;
@property (nonatomic,assign)Class entityClass;

//-(void)parser;
//-(void)mapper;


-(NJDXDALHTTPOperation*)initWithURL:(NSString*)url delegate:(id<NJDXDALHTTPOperationDelegate>)aDelegate thread:(NSThread*)aThread;
-(BOOL)isConcurrent;
-(NSData*)receivedData;
-(void)start;
-(void)cancel;

@end
