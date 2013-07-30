//
//  GaussianBlur.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "GaussianBlur.h"

@implementation GaussianBlur

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // ガウシアンフィルタを用いた平滑化（ぼかし）
    
    // 中間画像作成
    cv::Mat work_img = src_img;

    // 入力画像，出力画像，カーネルサイズ，標準偏差x, y
    cv::GaussianBlur(work_img, work_img, cv::Size(31,31), 0.01+self.gain*10, 0.01+self.gain2nd*10);
    // スライダ値によって引数を変更 標準偏差がゼロになるとボケるので+0.01しています
    
    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Sigma\n X:%.2f",0.01+self.gain*10];
}
- (NSString *)getGain2ndFormat{
    return [NSString stringWithFormat:@"Sigma\n Y:%.2f",0.01+self.gain2nd*10];
}

@end
