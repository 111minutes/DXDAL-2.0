//
//  NJDXDALOperationsCenter.h
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJDXDALRunLoopController.h"
#import "NJDXDALParsingCenter.h"

@class NJDXDALOperation;

// Managing all HTTPOperations (adding, canceling).

@interface NJDXDALOperationsCenter : NSObject

@property (nonatomic, strong) NJDXDALRunLoopController* runLoopManager;
@property (nonatomic, strong) NJDXDALParsingCenter* parsingManager;

-(NJDXDALHTTPOperation *)addRequest:(NSString *)url contentType:(NSString *) aContentType;
-(void)cancelOperation:(NJDXDALOperation *)operation;

@end
