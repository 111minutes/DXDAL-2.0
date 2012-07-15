//
//  SmartParserProtocol.h
//  SmartParser
//
//  Created by android on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NJDXDALParserProtocol <NSObject>

+ (BOOL)isDataTypeAcceptable:(NSString *)type;
+ (id)parseData:(NSData *)aData error:(NSError *)anError;

@end
