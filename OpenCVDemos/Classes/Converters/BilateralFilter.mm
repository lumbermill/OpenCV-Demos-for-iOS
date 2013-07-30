//
//  BilateralFilter.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "BilateralFilter.h"

@implementation BilateralFilter

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // バイラテラルフィルタを用いた平滑化（ぼかし）
    
    // 中間画像作成
    cv::Mat work_img;
    cv::cvtColor(src_img, work_img, CV_RGBA2RGB);    

    //cv::Mat work_img(src_img.rows, src_img.cols, CV_8UC3);
    //int fromTo[] = {0,0, 1,1, 2,2};
    //cv::mixChannels(&src_img, 1, &work_img, 1, fromTo, 3);

    NSLog(@"MatCannels: %d",work_img.channels());
    // 入力画像，出力画像，各ピクセルの近傍領域を表す直径，色空間におけるσ，座標空間におけるσ
    cv::bilateralFilter(work_img, work_img, 11, 40, 200);
    // スライダ値によって引数を変更
    // Mat型でエラー(なぜ??）
    // OpenCV Error: Assertion failed ((src.type() == CV_8UC1 || src.type() == CV_8UC3) && src.type() == dst.type() && src.size() == dst.size() && src.data != dst.data) in bilateralFilter_8u, file /Users/user/slave/builds/ios_framework/src/opencv/modules/imgproc/src/smooth.cpp, line 1874
    
    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Now Debug"];
}

@end
