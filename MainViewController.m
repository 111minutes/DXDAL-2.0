//
//  MainViewController.m
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "MainViewController.h"
#import "NJDXDALHTTPOperation.h"
#import "NJDXDALOperationsCenter.h"
#import "NJDXDALRequestBuilder.h"
#import "NJDXDALMappingController.h"
#import "NJDXDALMappingConfigurator.h"
#import "NJDXDALParser.h"
#import "Meta.h"

@interface MainViewController ()
{
    NJDXDALOperationsCenter* _httpOpManager;
    NSMutableURLRequest* _lastRequest;
    NJDXDALOperation *_operation;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 50);
    [button setTitle:@"Add" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed) 
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(100, 200, 100, 50);
    [button2 setTitle:@"Cancel" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(cancelPressed) 
      forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    _httpOpManager = [NJDXDALOperationsCenter new];
}

-(void)buttonPressed
{
  /*  NJDXDALRequestBuilder *requestBuilder = [NJDXDALRequestBuilder new];
    NJDXDALOperationConfigurationBlock configBlock = ^(NJDXDALHTTPOperation *operation) {
        operation.httpMethod = @"GET";
        operation.httpPath = @"/v2/venues/40a55d80f964a52020f31ee3";
        [operation addParam:@"oauth_token" value:@"XXX"];
        [operation addParam:@"v" value:@"YYYYMMDD"];
                
        NJDXDALMappingConfigurator *rootConfig = [[NJDXDALMappingConfigurator alloc] initForClass:[Meta class]];
        [rootConfig setCorrespondenceOfProperty:@"codeData" toDataField:@"code"];
        NJDXDALMappingController *mapper = [[NJDXDALMappingController alloc] initWithRootMappingConfigurator:rootConfig keyPath:@"meta"];
        mapper.delegate = operation;
        operation.mapper = mapper;
        
    };

    _operation = [requestBuilder operationWithUrl:@"https://api.foursquare.com" configurationBlock:configBlock contentType:@"json"];
    [_operation start];*/
/*    NJDXDALRequestBuilder *requestBuilder = [NJDXDALRequestBuilder new];
    NJDXDALOperationConfigurationBlock configBlock = ^(NJDXDALHTTPOperation *operation) {
        operation.httpMethod = @"POST";
        
        [operation addParam:@"password" value:@"1111aa"];       
        [operation addParam:@"email" value:@"pirogsergik@rambler.ru"];
    };
    NJDXDALOperation *loginOperation = [requestBuilder operationWithUrl:@"http://kc.9bitinteractive.com/mobile/users/login" configurationBlock:configBlock contentType:@"JSON"];
    [loginOperation start];*/
    NJDXDALRequestBuilder *requestBuilder = [NJDXDALRequestBuilder new];
    NJDXDALOperationConfigurationBlock configBlock = ^(NJDXDALHTTPOperation *operation) {
        operation.httpMethod = @"FILES";
        
        [operation addParam:@"user_id" value:@"20"];
        [operation addParam:@"key" value:@"a1c5bf2ec654779202b327444feb69d1"];       
        [operation addParam:@"email" value:@"pirogsergik@rambler.ru"];
        
        [operation addFile:UIImageJPEGRepresentation([UIImage imageNamed:@"pic.jpg"] , 90) withName:@"pic.jpg"];
    };
    NJDXDALOperation *loginOperation = [requestBuilder operationWithUrl:@"http://0.0.0.0:3000/index/upload" configurationBlock:configBlock contentType:@"JSON"];
    [loginOperation start];
}

-(void)cancelPressed
{
    NSLog(@"Canceling...");
    [_operation cancel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
