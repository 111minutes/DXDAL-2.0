//
//  MainViewController.m
//  NJDXDAL
//
//  Created by LimeStore on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "NJDXDALHTTPOperation.h"
#import "NJDXDALOperationsCenter.h"
#import "NJDXDALRequestBuilder.h"

@interface MainViewController ()
{
 //   HTTPOperationsManager* _httpOpManager;
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
    //    _lastRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://flapps.ru/example/user-info.php"]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    //_lastRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/venues/40a55d80f964a52020f31ee3?oauth_token=XXX&v=YYYYMMDD"]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    
    //NJDXDALHTTPOperation* op = [_httpOpManager addRequest:@"https://api.foursquare.com/v2/venues/40a55d80f964a52020f31ee3?oauth_token=XXX&v=YYYYMMDD"];

    NJDXDALRequestBuilder *requestBuilder = [NJDXDALRequestBuilder new];
    NJDXDALOperationConfigurationBlock configBlock = ^(NJDXDALHTTPOperation *operation)
    {
        operation.httpMethod = @"GET";
     //   operation.httpPath = @"/v2/venues/40a55d80f964a52020f31ee3?oauth_token=XXX&v=YYYYMMDD";
        operation.httpPath = @"/v2/venues/40a55d80f964a52020f31ee3";
        [operation addParam:@"oauth_token" value:@"XXX"];
        [operation addParam:@"v" value:@"YYYYMMDD"];
    };
//    2012-07-12 13:25:22.427 NJDXDAL[5959:f803] Connecting...
//    2012-07-12 13:25:34.044 NJDXDAL[5959:13103] {"meta":{"code":401,"errorType":"invalid_auth","errorDetail":"OAuth token invalid or revoked."},"response":{}}
    
    
//    2012-07-12 13:27:18.974 NJDXDAL[6084:f803] Connecting...
//    2012-07-12 13:27:20.456 NJDXDAL[6084:13103] {"meta":{"code":400,"errorType":"invalid_auth","errorDetail":"Missing access credentials. See https:\/\/developer.foursquare.com\/docs\/oauth.html for details."},"response":{}}



//    _operation = [requestBuilder operationWithUrl:@"https://api.foursquare.com" configurationBlock:configBlock];
//    [_operation start];
    

}

-(void)cancelPressed
{
    NSLog(@"Canceling...");
    //[_httpOpManager cancelOperation:_operation];
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
