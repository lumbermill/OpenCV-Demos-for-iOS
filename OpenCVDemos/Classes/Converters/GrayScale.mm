//
//  GrayScale.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "GrayScale.h"

@implementation GrayScale

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // グレースケール化
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    
    // グレースケールに変換
    cv::cvtColor(src_img, work_img, CV_RGB2GRAY);
        
    return work_img;
}

@end
