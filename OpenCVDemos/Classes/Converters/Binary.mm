//
//  Binary.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "Binary.h"

@implementation Binary

- (cv::Mat)convert:(cv::Mat) src_img{

    // ２値化(Binary)

    // 中間画像作成
    cv::Mat work_img = src_img;
    
    // グレースケールに変換
    cv::cvtColor(src_img, work_img, CV_RGB2GRAY);
    
    // 入力画像，出力画像，閾値，maxVal，閾値処理手法
    cv::threshold(work_img, work_img, self.gain*255, 255, cv::THRESH_BINARY);
    // スライダ値によって閾値を変更
    
    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Threshold\n %.2f",self.gain*255];
    
}

@end
