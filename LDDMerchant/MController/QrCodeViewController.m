
//
//  QrCodeViewController.m
//  LSKKApp
//
//  Created by 云盛科技 on 16/4/20.
//  Copyright © 2016年 云盛科技. All rights reserved.
//

#import "QrCodeViewController.h"
@interface QrCodeViewController ()
@end

@implementation QrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSURL *url = [NSURL URLWithString:_str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [self.view addSubview:web];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
