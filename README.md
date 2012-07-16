DXDAL-2.0
=========

Using DXDAL 2.0
At first you should create request builder


``` objective-c
@interface MyRequestBuilder : NJDXDALRequestBuilder
```


Default parameters use
``` objective-c
- (void)addDefaultConfig:(NJDXDALOperationConfigurationBlock) configurationBlock;
```
tо add default configuration blocks for each operation, for example:
``` objective-c
MyRequestBuilder *requestBuilder = [MyRequestBuilder new];
    NJDXDALOperationConfigurationBlock configBlock = ^(NJDXDALHTTPOperation *operation)
    {
      // some configurations of operation.v   
    };
[requestBuilder addDefaultConfig:configBlock];
```



## Operations definition
### Mapping configuration
``` objective-c
NJDXDALOperationConfigurationBlock configBlock = ^(NJDXDALHTTPOperation *operation)
{
	// some operation configuration        
        
	// Create configuration for mapper
        NJDXDALMappingConfigurator *rootConfig = [[NJDXDALMappingConfigurator alloc] initForClass:[Meta class]];
        [rootConfig setCorrespondenceOfProperty:@"codeData" toDataField:@"code"];
        NJDXDALMappingController *mapper = [[NJDXDALMappingController alloc] initWithRootMappingConfigurator:rootConfig keyPath:@"meta"];
        mapper.delegate = operation;
        operation.mapper = mapper;
};
``` 

### GET Operation
``` objective-c
NJDXDALOperationConfigurationBlock configBlock = ^(NJDXDALHTTPOperation *operation)
    {
        operation.httpMethod = @"GET";
        operation.httpPath = @"/v2/venues/40a55d80f964a52020f31ee3";
        [operation addParam:@"oauth_token" value:@"XXX"];
        [operation addParam:@"v" value:@"YYYYMMDD"];
        
		// some mapping configs
		
		// set current operation as delegate for mapper        	        
        mapper.delegate = operation;

		// set your custom mapper as operation mapper
        operation.mapper = mapper;
        
    };

NJDXDALOperation *_operation = [requestBuilder operationWithUrl:@"https://api.foursquare.com" configurationBlock:configBlock contentType:@"json"];
```

### POST Operation
``` objective-c
NJDXDALOperationConfigurationBlock configBlock = ^(NJDXDALHTTPOperation *operation)
    {
        operation.httpMethod = @"POST";
        operation.httpPath = @"path";
        [operation addParam:@"param1" value:@"v1"];
        [operation addParam:@"param2" value:@"v2"];
        
		// some mapping configs
		
		// set current operation as delegate for mapper        	        
        mapper.delegate = operation;

		// set your custom mapper as operation mapper
        operation.mapper = mapper;
        
    };
```


## About Parser

To use NJDXDAL parser you need to provide it with NSData object containing data for parsing. In addition you need to provide info about type of passed data. It should be an NSString e.g. "xml" or "json". Also you should have an NJDXDALParserDelegate to catch parsed data.

If you want to add a parser to the system, you should do the following:

1. Your parser name should start with "NJDXDALParser" and have at least one character after it to specify type of data that will be parsed, e.g. NJDXDALParserBPLIST;
2. Your parser should implement NJDXDALParserProtocol;
3. Necessarily fill the obtained error property if happen any parsing problem;
4. (id)parseData:error: method should return exclusively NSArray or NSDictionary or nil in case of error;

NJDXDALParserProtocol follows.
``` objective-c
@protocol NJDXDALParserProtocol <NSObject>

+ (BOOL)isDataTypeAcceptable:(NSString *)type;              // Check if data type is appropriate.
+ (id)parseData:(NSData *)aData error:(NSError *)anError;   // Parse data. Using an error necessarily! 
															// Return an NSArray or an NSDictionary.
@end
```


## MAPPING CONFIGURATION

For using mapping first you need to create root object of class NJDXDALMappingConfigurator. This class sets a mapping object class and mapping configuration for nesting level in data.  For every level you need NJDXDALMappingConfigurator object. 

For create use method:
``` objective-c
- (id)initForClass:(Class)mappingClass;
```

If property of mapping class is some custom object, you have to set type of this property using method:
``` objective-c
- (void)setMappingOfProperty:(NSString *)propertyName toType:(NSString *)propertyType;
```

If property of mapping class is object, which contains another objects, you have to create NJDXDALMappingConfigurator object for inner level and connect it to current using method:
``` objective-c
- (void)setMappingOfProperty:(NSString *)propertyName toMappingConfigurator:(NJDXDALMappingConfigurator *)configurator;
```

If property name is not equal to name of field in received data, you have to set correspondence manually using method:
``` objective-c
- (void)setCorrespondenceOfProperty:(NSString *)propertyName toDataField:(NSString *)dataField;
```

If property of mapping class is NSDate type, you can use following methods to configure mapping on each level:
``` objective-c
- (void)setDateStyle:(NSInteger)formatterDateStyle;
- (void)setTimeStyle:(NSInteger)formatterTimeStyle;
- (void)setDateFormat:(NSString *)dateFormat;
```

If property of mapping class is NSDictionary or NSMutableDictionary, you have to create new NJDXDALMappingConfigurator object for class "NSDictionary" and connect it to root configuration.
Then all your configurations are set, you can create NJDXDALMappingController object with root NJDXDALMappingConfigurator object and key path of required data in received data (if needed).
For example, you want to map a class BookStore, which has following interface:

``` objective-c
@interface BookStore : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSNumber *territory;
@property (nonatomic, strong) NSArray *catalogue;
@property (nonatomic, strong) NSDictionary *numberOfArticles;

@end
```

### Example

JSON response has next form:

``` JSON
receivedData = {
    foodstore = {
    	someInformation = @"info"
    }
    bookstore = 
    {
        "name": "HappyBook",
        "territory": "24.56",
        "catalogue":
            [
                { 
                    "title": "RestKit Object Mapping Intro",
                    "body": "This article details how to use RestKit object mapping...",
                    "author": "Blake Watters",
                    "publication_date": "7/4/2011",
                    "copies": "1"
                },
                { 
                    "title": "RestKit 1.0 Released",
                    "body": "RestKit 1.0 has been released to much fanfare across the galaxy...",
                    "author": "Blake Watters",
                    "publication_date": "9/4/2011",
                    "copies": "2"
                }
            ],
         "numberOf" : 
            {
                "firstKey" : "firstValue",
                "secondKey" : "secondValue",
                "thirdKey" : 
                    { 
                        "title": "RestKit Object Mapping Intro",
                        "body": "This article details how to use RestKit object mapping...",
                        "author": "Blake Watters",
                        "publication_date": "7/4/2011",
                        "copies": "1"
                    }
            }
    }
}
```

Config code for it:
``` objective-c
    NJDXDALMappingConfigurator *rootConfigurator = [[NJDXDALMappingConfigurator alloc] initForClass:[BookStore class]]; // create rootConfigurator object
    [rootConfigurator setMappingOfProperty:@"catalogue" toType:@"Article"]; //Set type of content property "catalogue" to custom object type "Article"
    [rootConfigurator setCorrespondenceOfProperty:@"numberOfArticles" toDataField:@"numberOf"]; // set correspondence between property name "numberOfArticles" and field "numberOf" in received data
       
    NJDXDALMappingConfigurator *numberOfArticlesConfigurator = [[NJDXDALMappingConfigurator alloc] initForClass:[NSDictionary class]]; // create new configurator for property of type NSDictionary
    [numberOfArticlesConfigurator setMappingOfProperty:@"thirdKey" toType:@"Article"]; // set type for key "third key" in NSDictionary to "Article"
    
    [rootConfigurator setMappingOfProperty:@"numberOfArticles" toMappingConfigurator:numberOfArticlesConfigurator]; // connect NSDictionary configurator to root configurator
    
    NJDXDALMappingController *mappingController = [[NJDXDALMappingController alloc] initWithRootMappingConfigurator:rootConfigurator keyPath:@"bookstore"]; // create controller object with root configurator
```