//
//  Adaptive.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "Adaptive.h"

@implementation Adaptive

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // ２値化(Adaptive)
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    
    // グレースケールに変換
    cv::cvtColor(src_img, work_img, CV_RGB2GRAY);

    // 入力画像，出力画像，maxVal，閾値決定手法，閾値処理手法，blockSize，C
    cv::adaptiveThreshold(work_img, work_img, 255-self.gain*255, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, 7, 8);
    // スライダ値によって閾値を変更

    return work_img;
}

@end
