//
//  OperationsController.m
//  多线程的开发
//
//  Created by 贺恒涛 on 17/5/12.
//  Copyright © 2017年 贺恒涛. All rights reserved.
//

#import "OperationsController.h"
#import "KCImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10


@interface OperationsController (){
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
}

@end

@implementation OperationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"NSOparation:加载数组图片";
    [self layoutUI];
}

#pragma mark 界面布局
-(void)layoutUI{
    //创建多个图片控件用于显示图片
    _imageViews=[NSMutableArray array];
    for (int r = 0; r<ROW_COUNT; r++) {
        for (int c = 0; c<COLUMN_COUNT; c++) {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20+c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING)+50, ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(50, 500, 220, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    //添加方法
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
#pragma mark 将图片显示到界面
-(void)updateImageWithData:(NSData *)data andIndex:(int )index{

    UIImage *image = [UIImage imageWithData:data];
    UIImageView *imageview = _imageViews[index];
    imageview.image = image;
}

#pragma mark 请求图片数据
-(NSData *)requestData:(int )index{
    
    NSURL *url=[NSURL URLWithString:@"http://test.starbuyer.com//upload/bangdan/2017/02/28/1488255429.jpg"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;
}

#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    int i = [index intValue];
    //请求数据
    NSData *data = [self requestData:i];
    //更新UI界面，此处调用了主线程队列的方法（mainQueue是UI主线程）
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateImageWithData:data andIndex:i];
    }];
    
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    int count = ROW_COUNT *COLUMN_COUNT;
    //创建操作队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    operationQueue.maxConcurrentOperationCount = 2;//设置最大并发线程数
    
    //先加载最后一张在加载前面的图片
    NSBlockOperation *lastBlockQueue = [NSBlockOperation blockOperationWithBlock:^{
        [self loadImage:[NSNumber numberWithInt:(count-1)]];
    }];
    
    //创建多个线程用于填充图片
    for (int i = 0 ; i< count; i++) {
        //方法1：创建操作块添加到队列
        //创建多线程操作
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self loadImage:[NSNumber numberWithInt:i]];
        }];
        //设置依赖操作为最后一张图片加载操作
        [blockOperation addDependency:lastBlockQueue];
        
        //创建操作队列
        [operationQueue addOperation:blockOperation];
        
        
        //方法2：直接使用队列添加操作
//        [operationQueue addOperationWithBlock:^{
//            [self loadImage:[NSNumber numberWithInt:i]];
//        }];
    }
    //将最后一个图片的加载加入线程队列
    [operationQueue addOperation:lastBlockQueue];
    
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
