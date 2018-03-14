//
//  OperationController.m
//  多线程的开发
//
//  Created by 贺恒涛 on 17/5/12.
//  Copyright © 2017年 贺恒涛. All rights reserved.
//

#import "OperationController.h"

@interface OperationController (){
    UIImageView *_imageView;
}

@end

@implementation OperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"NSOparation:加载图片";
    [self layoutUI];
    // Do any additional setup after loading the view.
}
#pragma mark 界面布局
-(void)layoutUI{
    _imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

#pragma mark 将图片显示在界面
-(void)updateImage:(NSData *)imageData{
    UIImage *image = [UIImage imageWithData:imageData];
    _imageView.image = image;
}

#pragma mark 请求图片数据
-(NSData *)requstData{
    NSURL *url = [NSURL URLWithString:@"http://test.starbuyer.com/upload/autoplay/jinyubin/bg_jinyubin.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}

#pragma mark 加载图片
-(void)loadImage{
    NSData *data = [self requstData];
    /*将数据显示到UI控件,注意只能在主线程中更新UI,
     另外performSelectorOnMainThread方法是NSObject的分类方法，每个NSObject对象都有此方法，
     它调用的selector方法是当前调用控件的方法，例如使用UIImageView调用的时候selector就是UIImageView的方法
     Object：代表调用方法的参数,不过只能传递一个参数(如果有多个参数请使用对象进行封装)
     waitUntilDone:是否线程任务完成执行
     */
    
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:data waitUntilDone:YES];
    
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
   //创建一个调用操作  object: 调用方法参数
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(loadImage) object:nil];
    //创建完NSInvocationOperation对象并不会调用，它由一个start方法启动操作，但是注意如果直接调用start方法，则此操作会在主线程中调用，一般不会这么操作，而是添加到NSOperationQueue中
    //[invocationOperation start];
    
    //创建操作队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    //注意添加到操作队列后，队列会开启一个线程执行此操作
    [operationQueue addOperation:invocationOperation];
    
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
