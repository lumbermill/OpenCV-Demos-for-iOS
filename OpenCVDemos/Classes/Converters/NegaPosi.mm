//
//  NegaPosi.m
//  OpenCVDemos
//
//  Created by 中村 将 on 2013/07/19.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "NegaPosi.h"

@implementation NegaPosi

// ネガポジ反転
- (cv::Mat)convert:(cv::Mat) src_img{
    
    // グレースケールに変換
    cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    
    // ネガポジ反転
    work_img = ~work_img;
    
    return work_img;
}

@end
