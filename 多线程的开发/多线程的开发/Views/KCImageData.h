//
//  KCImageData.h
//  多线程的开发
//
//  Created by 贺恒涛 on 17/5/12.
//  Copyright © 2017年 贺恒涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCImageData : NSObject

#pragma mark 索引
@property (nonatomic ,assign)int index;

#pragma mark 图片数据
@property (nonatomic,strong) NSData *data;


@end
