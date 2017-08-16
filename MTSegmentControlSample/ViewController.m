//
//  ViewController.m
//  MTSegmentControlSample
//
//  Created by LiMengtian on 2017/4/4.
//  Copyright © 2017年 LiMengtian. All rights reserved.
//

#import "ViewController.h"
#import "MTSegmentedControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MTSegmentedControl *segmentControl = [[MTSegmentedControl alloc] initWithItem:@[@"你好",@"再见哇",@"萨瓦迪卡"]];
//    segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
    
    segmentControl.frame = CGRectMake(0, 100, 250, 40);
    
    [self.view addSubview:segmentControl];
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
