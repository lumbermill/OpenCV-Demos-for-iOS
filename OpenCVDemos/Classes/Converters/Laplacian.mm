//
//  Laplacian.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "Laplacian.h"

@implementation Laplacian

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 輪郭検出(Laplacian)
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    
    // グレースケールに変換
    cv::cvtColor(src_img, work_img, CV_RGB2GRAY);

    // 入力画像，出力画像，出力画像のビット深度，2次微分フィルタを求めるために利用されるアパーチャのサイズ
    cv::Laplacian(work_img, work_img, CV_32F, 3);
    
    // 絶対値を計算し，結果を 8 ビットに変換
    cv::convertScaleAbs(work_img, work_img, 1, 0);

    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"No Information"];
}

@end
