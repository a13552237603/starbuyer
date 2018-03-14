//
//  GCDbingController.m
//  多线程的开发
//
//  Created by 贺恒涛 on 17/5/16.
//  Copyright © 2017年 贺恒涛. All rights reserved.
//

#import "GCDbingController.h"
#import "KCImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH ROW_HEIGHT
#define CELL_SPACING 10


@interface GCDbingController (){
    NSMutableArray *_imageViews;
    NSMutableArray *_imageNames;
}


@end

@implementation GCDbingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"GCD:并行队列";

    [self layoutUI];
    
    // Do any additional setup after loading the view.
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
#pragma mark 请求图片数据
-(NSData *)requestData:(int )index{
    
    NSURL *url=[NSURL URLWithString:@"http://test.starbuyer.com//upload/bangdan/2017/02/28/1488255429.jpg"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;
}
#pragma mark 将图片显示到界面
-(void)updateImageWithData:(NSData *)data andIndex:(int )index{
    UIImage *image=[UIImage imageWithData:data];
    UIImageView *imageView= _imageViews[index];
    imageView.image=image;
}
#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    
    //如果在串行队列中会发现当前线程打印变化完全一样，因为他们在一个线程中
    NSLog(@"当前线程==%@",[NSThread currentThread]);
    
    int i = [index intValue];
    //请求数据
    NSData *data = [self requestData:i];
    //更新UI界面，此处调用GCD主线程队列的方法
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(mainQueue, ^{
        [self updateImageWithData:data andIndex:i];
    });
    
    
}
#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    
    int count=ROW_COUNT*COLUMN_COUNT;
    /*取得全局队列
     第一个参数：线程优先级
     第二个参数：标记参数，目前没有用，一般传入0
     */
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //先加载最后一张图片，在加载其它图片
//    dispatch_barrier_async(globalQueue, ^{
//        [self loadImage:[NSNumber numberWithInt:(count-1)]];
//
//    });
    //创建多个线程用于填充图片
    for (int i = 0; i<count; i++) {
        //异步执行队列任务
        dispatch_async(globalQueue, ^{
            [self loadImage:[NSNumber numberWithInt:i]];
        });
    }
    
}
#pragma mark 队列组使用
-(void)groupDispatch{
    dispatch_group_t group = dispatch_group_create();//创建队列组
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//全局并发队列
    dispatch_group_async(group, queue, ^{
        //操作1
    });
    dispatch_group_async(group, queue, ^{
        //操作2
    });
    dispatch_group_notify(group, queue, ^{
        //主线程刷新数据
    });
    
    
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
