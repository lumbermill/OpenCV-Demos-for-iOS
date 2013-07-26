//
//  Canny.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "Canny.h"

@implementation Canny

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 輪郭検出(Canny)
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    
    // グレースケールに変換
    cv::cvtColor(src_img, work_img, CV_RGB2GRAY);

    // 入力画像，出力画像，1番目の閾値，2番目の閾値
    cv::Canny(work_img, work_img, self.gain*255, self.gain2nd*255);
    // スライダ値によって引数を変更

    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Threshold\n T1:%.2f",self.gain*255];
    
}
- (NSString *)getGain2ndFormat{
    return [NSString stringWithFormat:@"Threshold\n T2:%.2f",self.gain2nd*255];
    
}

@end
