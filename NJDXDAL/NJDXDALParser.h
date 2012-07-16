//
//  NJDXDALParser.h
//  NJDXDAL
//
//  Created by android on 12.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NJDXDALParserDelegate <NSObject>

- (void)didFinishedParsing:(id) data;
- (void)didFailedWithError:(NSError*) error;

@end



// Class for managing parsing process.

@interface NJDXDALParser : NSObject

@property (nonatomic, strong) id<NJDXDALParserDelegate> delegate; //for infroming (mapper) when data's parsed

- (id)parseData:(NSData *)aData type:(NSString *)aType;

@end
