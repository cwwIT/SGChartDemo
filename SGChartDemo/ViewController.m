//
//  ViewController.m
//  SGChartDemo
//
//  Created by sungrow on 2019/9/19.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "ViewController.h"
#import "SGChartVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)clickGotoChartViewController:(UIButton *)sender {
    
    SGChartVC *chart = [[SGChartVC alloc]init];
    [self presentViewController:chart animated:YES completion:^{}];
     
}

@end
