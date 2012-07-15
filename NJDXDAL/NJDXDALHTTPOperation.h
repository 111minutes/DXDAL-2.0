//
//  NJDXDALHTTPOperation.h
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJDXDALOperation.h"
#import "NJDXDALMappingController.h"

@class NJDXDALHTTPOperation;
@class NJDXDALParser;
@class NJDXDALMappingController;


@protocol NJDXDALHTTPOperationDelegate <NSObject>

- (void)startOperation:(NJDXDALOperation*)op;
- (void)loadingFinished:(NJDXDALOperation*)op;
- (void)cancelOperation:(NJDXDALOperation*)op;

@end


@interface NJDXDALHTTPOperation : NJDXDALOperation <NSURLConnectionDelegate,MappingDelegate>

@property (nonatomic,strong) NSMutableURLRequest* request;
@property (nonatomic,readonly) BOOL isExecuting;
@property (nonatomic,assign) BOOL isFinished; 
@property (nonatomic,readonly) BOOL isCancelled;

@property (nonatomic, strong) NSString *contentType;
@property (nonatomic,copy) NSString* httpMethod;
@property (nonatomic,copy) NSString* httpPath;
@property (nonatomic,copy) NSString* httpContentType;
@property (nonatomic,assign)Class entityClass;

@property (nonatomic,strong) NJDXDALMappingController *mapper;

@property (nonatomic, strong) id<NJDXDALHTTPOperationDelegate> delegate; //for informing when data is loaded


- (NJDXDALHTTPOperation*)initWithURL:(NSString*)url delegate:(id<NJDXDALHTTPOperationDelegate>)aDelegate thread:(NSThread*)aThread contentType:(NSString *) aContentType;
- (BOOL)isConcurrent;
- (NSData*)receivedData;
- (void)start;
- (void)cancel;
- (void)addParam:(NSString*)key value:(NSString*)aValue;

@end
