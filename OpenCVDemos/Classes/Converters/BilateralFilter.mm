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
    cv::Mat work_img = src_img;
    
    // 入力画像，出力画像，各ピクセルの近傍領域を表す直径，色空間におけるσ，座標空間におけるσ
    //cv::bilateralFilter(src_img, src_img, gain*11, 40, 200);
    // スライダ値によって引数を変更
    // Mat型でエラー
    
    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Now Debug"];
}

@end
