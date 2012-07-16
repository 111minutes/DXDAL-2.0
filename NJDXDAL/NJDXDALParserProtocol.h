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

+ (BOOL)isDataTypeAcceptable:(NSString *)type;              // Check if data type is appropriate.
+ (id)parseData:(NSData *)aData error:(NSError *)anError;   // Parse data. Use an error necessarily! Return an array or a dictionary.

@end
