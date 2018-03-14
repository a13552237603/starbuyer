//
//  MainViewController.m
//  多线程的开发
//
//  Created by 贺恒涛 on 17/5/12.
//  Copyright © 2017年 贺恒涛. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "ThreadsController.h"
#import "OperationController.h"
#import "OperationsController.h"
#import "GCDbingController.h"
#import "GCDchuanController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"多线程开发";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 100, 150, 25);
    [button setTitle:@"Thread" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(150, 100, 220, 25);
    [button1 setTitle:@"Thread:多张" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(clickThreads) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(20, 200, 150, 25);
    [button2 setTitle:@"NSOperation:" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(clickNSOperation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.frame = CGRectMake(150, 200, 150, 25);
    [button3 setTitle:@"NSOperation:多张" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(clickNSOperations) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button4.frame = CGRectMake(20, 300, 150, 25);
    [button4 setTitle:@"GCD:串行" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(clickGCDchuan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button5.frame = CGRectMake(150, 300, 150, 25);
    [button5 setTitle:@"GCD:并发" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(clickGCDbing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    // Do any additional setup after loading the view.
}

-(void)clickThread{
    ViewController *view = [[ViewController alloc]init];
    [self.navigationController pushViewController:view animated:NO];
}

-(void)clickThreads{
    ThreadsController *thread = [[ThreadsController alloc]init];
    [self.navigationController pushViewController: thread animated:NO];
}

-(void)clickNSOperation{
    OperationController *operation = [[OperationController alloc]init];
    [self.navigationController pushViewController:operation animated:NO];
}

-(void)clickNSOperations{
    OperationsController *operation = [[OperationsController alloc]init];
    [self.navigationController pushViewController:operation animated:NO];
}

-(void)clickGCDchuan{
    GCDchuanController *operation = [[GCDchuanController alloc]init];
    [self.navigationController pushViewController:operation animated:NO];
}
-(void)clickGCDbing{
    GCDbingController *operation = [[GCDbingController alloc]init];
    [self.navigationController pushViewController:operation animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
