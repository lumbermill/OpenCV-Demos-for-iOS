//
//  EllipticalFitting.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "EllipticalFitting.h"

@implementation EllipticalFitting

- (cv::Mat)convert:(cv::Mat) src_img{
    
    //楕円フィッティング
    
    // 中間画像作成
    cv::Mat work_img = src_img;

    // グレースケールに変換
    cv::Mat bin_img;
    cv::cvtColor(src_img, work_img, CV_BGR2GRAY);
    
    std::vector<std::vector<cv::Point> > contours;
    
    // 画像の二値化
    cv::threshold(work_img, bin_img, 0, 255, cv::THRESH_BINARY|cv::THRESH_OTSU);
    
    // 輪郭の検出
    //cv::findContours(bin_img, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    cv::findContours(bin_img, contours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
    //cv::findContours(bin_img, contours, CV_RETR_CCOMP, CV_CHAIN_APPROX_NONE);
    //cv::findContours(bin_img, contours, CV_RETR_TREE, CV_CHAIN_APPROX_NONE);
    
    for(int i = 0; i < contours.size(); ++i) {
        size_t count = contours[i].size();
        
        if(count < 10+self.gain*1000 || count > 10+self.gain2nd*1000) continue;
        // （小さすぎる|大きすぎる）輪郭を除外 スライダ値で可変

        cv::Mat pointsf;
        cv::Mat(contours[i]).convertTo(pointsf, CV_32F);
        // 楕円フィッティング
        cv::RotatedRect box = cv::fitEllipse(pointsf);
        // 楕円の描画
        cv::ellipse(src_img, box, cv::Scalar(255,0,0), 3, CV_AA);
    }

    //return bin_img;
    return src_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Detect Size\n Min:%.2f",10+self.gain*1000];
    
}
- (NSString *)getGain2ndFormat{
    return [NSString stringWithFormat:@"Detect Size\n Max:%.2f",10+self.gain2nd*1000];
    
}


@end
