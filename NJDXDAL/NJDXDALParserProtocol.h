//
//  NJDXDALParserProtocol.h
//  NJDXDAL
//
//  Created by android on 11.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>


// Protocol for custom parser classes.

@protocol NJDXDALParserProtocol <NSObject>

+ (BOOL)isDataTypeAcceptable:(NSString *)type;
+ (id)parseData:(NSData *)aData error:(NSError *)anError;

@end
