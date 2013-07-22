//
//  NegaPosi.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/19.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "NegaPosi.h"

@implementation NegaPosi

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // ネガポジ反転
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    
    // ネガポジ反転
    work_img = ~work_img;
    
    return work_img;
}

@end
