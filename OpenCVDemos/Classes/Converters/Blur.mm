//
//  Blur.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "Blur.h"

@implementation Blur

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // blurを用いた平滑化（ぼかし）
    
    // 中間画像作成
    cv::Mat work_img = src_img;

    // 入力画像，出力画像，カーネルサイズ，アンカー，境界モード
    cv::blur(work_img, work_img, cv::Size(2,100));

    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"No Information"];
}

@end
