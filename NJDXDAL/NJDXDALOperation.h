//
//  NJDXDALOperation.h
//  NJDXDAL
//
//  Created by LimeStore on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


// The final Operation for the user using. 

@interface NJDXDALOperation : NSOperation

@property (nonatomic, strong) NSArray *mappedData;

- (void)start;
- (void)cancel;

@end
