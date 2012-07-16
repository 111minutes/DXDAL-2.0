//
//  NJDXDALRunLoopController.h
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <Foundation/Foundation.h>



// Represents a thread with RunLoop for loading data operations

@interface NJDXDALRunLoopController : NSObject

- (NSThread*)thread;

@end
