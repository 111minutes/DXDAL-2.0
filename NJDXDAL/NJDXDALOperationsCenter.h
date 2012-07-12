//
//  NJDXDALOperationsCenter.h
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJDXDALRunLoopController.h"
#import "NJDXDALParsingCenter.h"

@interface NJDXDALOperationsCenter : NSObject

@property (nonatomic, strong) NJDXDALRunLoopController* runLoopManager;
@property (nonatomic, strong) NJDXDALParsingCenter* parsingManager;

-(NJDXDALHTTPOperation*)addRequest:(NSString*)url;
-(void)cancelRequest:(NSURLRequest*)req;

@end
