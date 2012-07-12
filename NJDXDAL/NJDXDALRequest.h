//
//  NJDXDALRequest.h
//  NJDXDAL
//
//  Created by LimeStore on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJDXDALHTTPOperation.h"



@interface NJDXDALRequest : NSObject

-(NJDXDALRequest*)initWithOperation:(NJDXDALHTTPOperation*)operation;
-(void)start;
-(void)cancel;
-(void)addParam:(NSString*)key value:(NSString*)aValue;

@end
