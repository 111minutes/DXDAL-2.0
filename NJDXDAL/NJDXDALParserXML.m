//
//  SmartParserXML.m
//  SmartParser
//
//  Created by android on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALParserXML.h"

@interface NJDXDALParserXML () 

+ (NSDictionary*)dictionaryWithXMLNode:(TBXMLElement*)element;

@end

@implementation NJDXDALParserXML

+ (id)parseData:(NSData*) aData error:(NSError *)anError;
{
    TBXML *XMLObj = [TBXML tbxmlWithXMLData:aData error:&anError];
    if (anError || ![XMLObj rootXMLElement]) {
        NSLog(@"NJDXDALParserXML: parse error! \n%@", anError);
        return nil;
    }
    else {
        return [self dictionaryWithXMLNode:[XMLObj rootXMLElement]];
    }

}

+ (NSDictionary*)dictionaryWithXMLNode:(TBXMLElement*)element
{
    NSMutableDictionary *elementDict = [NSMutableDictionary new];
    
    TBXMLAttribute *attribute = element->firstAttribute;
    while (attribute) {
        [elementDict setObject:[TBXML attributeValue:attribute] forKey:[TBXML attributeName:attribute]];
        attribute = attribute->next;
    }
    
    TBXMLElement *childElement = element->firstChild;
    if (childElement) {        
        while (childElement) {
            if ([elementDict objectForKey:[TBXML elementName:childElement]] == nil) {
                [elementDict addEntriesFromDictionary:[self dictionaryWithXMLNode:childElement]];
            } 
            else if ([[elementDict objectForKey:[TBXML elementName:childElement]] isKindOfClass:[NSArray class]]) {                
                NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[elementDict objectForKey:[TBXML elementName:childElement]]];
                [items addObject:[[self dictionaryWithXMLNode:childElement] objectForKey:[TBXML elementName:childElement]]];
                [elementDict setObject:[NSArray arrayWithArray:items] forKey:[TBXML elementName:childElement]];
                items = nil;
            } 
            else {
                NSMutableArray *items = [[NSMutableArray alloc] init];
                [items addObject:[elementDict objectForKey:[TBXML elementName:childElement]]];
                [items addObject:[[self dictionaryWithXMLNode:childElement] objectForKey:[TBXML elementName:childElement]]];
                [elementDict setObject:[NSArray arrayWithArray:items] forKey:[TBXML elementName:childElement]];
                items = nil;
            }
            
            childElement = childElement->nextSibling;
        }
        
    } 
    else if ([TBXML textForElement:element] != nil && [TBXML textForElement:element].length>0) {
        if ([elementDict count]>0) {
            [elementDict setObject:[TBXML textForElement:element] forKey:@"text"];
        } 
        else {
            [elementDict setObject:[TBXML textForElement:element] forKey:[TBXML elementName:element]];
        }
    }    
    NSDictionary *resultDict = nil;
    
    if ([elementDict count]>0) {
        if ([elementDict valueForKey:[TBXML elementName:element]] == nil) {
            resultDict = [NSDictionary dictionaryWithObject:elementDict forKey:[TBXML elementName:element]];
        } 
        else {
            resultDict = [NSDictionary dictionaryWithDictionary:elementDict];
        }
    }
    elementDict = nil;    
    
    return resultDict;
}

+ (BOOL)isDataTypeAcceptable:(NSString *)type;
{
    type = [type lowercaseString];
    if ([type isEqualToString:@"xml"]){
        return YES;
    }
    else {
        return NO;
    }
}

@end
