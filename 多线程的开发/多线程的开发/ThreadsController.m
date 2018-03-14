//
//  ThreadsController.m
//  多线程的开发
//
//  Created by 贺恒涛 on 17/5/12.
//  Copyright © 2017年 贺恒涛. All rights reserved.
//

#import "ThreadsController.h"
#import "KCImageData.h"
#define ROW_COUNT 5
#define COLUMN_COUNT 3
#define ROW_HEIGHT 100
#define ROW_WIDTH  ROW_HEIGHT
#define CELL_SPACING 10



@interface ThreadsController (){
    NSMutableArray *_imageViews;
    
    NSMutableArray *_imageNames;
    NSMutableArray *_threads;

}

@end

@implementation ThreadsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Thread：加载数组图片";
    [self layoutUI];
    // Do any additional setup after loading the view.
}
#pragma mark 界面布局
-(void)layoutUI{
    //创建多个图片控件用于显示图片
    _imageViews = [[NSMutableArray alloc]init];
    for (int r = 0; r<ROW_COUNT; r++) {
        for (int c = 0; c<COLUMN_COUNT; c++) {
     UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20+c*ROW_WIDTH+(c*CELL_SPACING), r*ROW_HEIGHT+(r*CELL_SPACING)+50, ROW_WIDTH, ROW_HEIGHT)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [self.view addSubview:imageView];
            [_imageViews addObject:imageView];
        }
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(80, 550, 100, 25);
    [button setTitle:@"加载图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(loadImageWithMultiThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //停止按钮
    UIButton *buttonStop=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonStop.frame=CGRectMake(200, 550, 100, 25);
    [buttonStop setTitle:@"停止加载" forState:UIControlStateNormal];
    [buttonStop addTarget:self action:@selector(stopLoadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonStop];
    
    
}

#pragma mark 将图片显示到界面
-(void)updateImage:(KCImageData *)imageData{
    UIImage *image = [UIImage imageWithData:imageData.data];
    UIImageView *imageview = _imageViews[imageData.index];
    imageview.image = image;
}

#pragma mark 请求图片数据 
-(NSData *)requestData:(int )index{
    //对非最后一张图片加载线程休眠2秒
    
//    if (index != (ROW_COUNT *COLUMN_COUNT - 1)) {
//        [NSThread sleepForTimeInterval:2.0];
//    }
    
    
    NSURL *url=[NSURL URLWithString:@"http://test.starbuyer.com//upload/bangdan/2017/02/28/1488255429.jpg"];
    NSData *data=[NSData dataWithContentsOfURL:url];
    return data;
}

#pragma mark 加载图片
-(void)loadImage:(NSNumber *)index{
    //currentThread方法可以取得当前操作线程
    NSLog(@"current thread:%@",[NSThread currentThread]);
    
    int i = [index intValue];
    NSLog(@"i = = %d",i);//未必按照顺序输出
    NSData *data = [self requestData:i];
    
    //如果当前线程处于取消状态，则退出当前线程
    NSThread *currentThread = [NSThread currentThread];
    if (currentThread.isCancelled) {
        NSLog(@"thread(%@) will be cancelled!",currentThread);
        [NSThread exit];//取消当前线程
    }
    
    KCImageData *imageData = [[KCImageData alloc]init];
    imageData.data = data;
    imageData.index = i;
    
    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
    
}

#pragma mark 多线程下载图片
-(void)loadImageWithMultiThread{
    
    _threads = [NSMutableArray array];
    int count = ROW_COUNT*COLUMN_COUNT;
    
    //创建多个线程用于填充图片
    for (int i = 0; i<count; i++) {
        //类方法
       // [NSThread detachNewThreadSelector:@selector(loadImage:) toTarget:self withObject:[NSNumber numberWithInt:i]];
        
        //对象方法
        NSThread *thred = [[NSThread alloc]initWithTarget:self selector:@selector(loadImage:) object:[NSNumber numberWithInt:i]];
        thred.name = [NSString stringWithFormat:@"myThread%i",i];//设置线程名称
        //优先执行最后那个线程，优先级threadPriority范围为0~1
        if (i == (count -1)) {
            thred.threadPriority = 1.0;
        }else{
            thred.threadPriority = 0.0;
        }
        [_threads addObject:thred];
        
    }
    for (int i=0; i<count; i++) {
        NSThread *thread=_threads[i];
        [thread start];
    }
    
}


#pragma mark 停止加载图片
-(void)stopLoadImage{
    
    for (int i = 0; i<ROW_COUNT*COLUMN_COUNT; i++) {
        NSThread *thread = _threads[i];
        //判断线程是否完成，如果没有完成则设置为取消状态
        //注意设置为取消状态仅仅是改变了线程状态而言，并不能终止线程
        if (!thread.isFinished) {
            [thread cancel];
        }
    }
    
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
