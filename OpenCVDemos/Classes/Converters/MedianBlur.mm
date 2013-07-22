//
//  MedianBlur.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "MedianBlur.h"

@implementation MedianBlur

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // メディアンフィルタを用いた平滑化（ぼかし）
    
    // 中間画像作成
    cv::Mat work_img = src_img;

    // 入力画像，出力画像，カーネルサイズ
    //cv::medianBlur(work_img, work_img, gain*42);
    cv::medianBlur(work_img, work_img, 21);
    // スライダ値によって引数を変更　->するとエラー(奇数にならないとダメ）
    // OpenCV Error: Assertion failed (ksize % 2 == 1) in medianBlur

    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Kernel Size\n 21"];
    
}

@end
