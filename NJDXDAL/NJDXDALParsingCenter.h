//
//  NJDXDALParsingCenter.h
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NJDXDALHTTPOperation;


@interface NJDXDALParsingCenter : NSObject

- (void)addForParsingURLOperation:(NJDXDALHTTPOperation*)op;
- (void)cancellOperationWithParent:(NJDXDALHTTPOperation*)op;

@end
