//
//  Trunk.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "Trunk.h"

@implementation Trunk

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // ２値化(Trunk)
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    
    // グレースケールに変換
    cv::cvtColor(src_img, work_img, CV_RGB2GRAY);
    
    // 入力画像，出力画像，閾値，maxVal，閾値処理手法
    cv::threshold(work_img, work_img, self.gain*255, 255, cv::THRESH_TRUNC);
    // スライダ値によって閾値を変更
    
    return work_img;
}

@end
