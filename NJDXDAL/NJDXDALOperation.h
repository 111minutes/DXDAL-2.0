//
//  NJDXDALOperation.h
//  NJDXDAL
//
//  Created by LimeStore on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJDXDALOperation : NSOperation

@property (nonatomic, strong) NSArray *result;

-(void)start;
-(void)cancel;

@end
