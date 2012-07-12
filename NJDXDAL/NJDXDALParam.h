//
//  NJDXDALParam.h
//  NJDXDAL
//
//  Created by LimeStore on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJDXDALParam : NSObject
{
    NSString* _key;  
    NSString* _value;
}

-(NJDXDALParam*)initWithKey:(NSString*)aKey value:(NSString*)aValue;
-(NSString*)toString;

@end
