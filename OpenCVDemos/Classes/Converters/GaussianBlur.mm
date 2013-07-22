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
    cv::GaussianBlur(work_img, work_img, cv::Size(31,31), self.gain*20, self.gain*20);
    // スライダ値によって引数を変更
    
    return work_img;
}

- (NSString *)getGainFormat{
    return [[NSString stringWithFormat:@"Sigma\n X:%.2f",self.gain*20]
            stringByAppendingFormat:@"\n Y:%.2f",self.gain*20];
}

@end
