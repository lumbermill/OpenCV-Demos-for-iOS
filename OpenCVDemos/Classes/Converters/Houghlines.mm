//
//  Houghlines.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "Houghlines.h"

@implementation Houghlines

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 直線検出(Houghlines)
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    cv::Mat dst_img;

    // グレースケールに変換後、canny関数で輪郭を抽出
    cv::cvtColor(src_img, dst_img, CV_RGB2GRAY);
    cv::Canny(dst_img, dst_img, 50, 250, 3);
    
    // 古典的Hough変換
    std::vector<cv::Vec2f> lines;
    
    // 入力画像，出力画像，距離分解能，角度分解能，閾値，*,*
    cv::HoughLines(dst_img, lines, 1, CV_PI/180, self.gain*255, 0, 0);
    // 閾値をスライダ値で可変
    
    // 直線の描画
    std::vector<cv::Vec2f>::iterator it = lines.begin();
    for(; it!=lines.end(); ++it) {
        float rho = (*it)[0], theta = (*it)[1];
        cv::Point pt1, pt2;
        double a = cos(theta), b = sin(theta);
        double x0 = a*rho, y0 = b*rho;
        pt1.x = cv::saturate_cast<int>(x0 + 1000*(-b));
        pt1.y = cv::saturate_cast<int>(y0 + 1000*(a));
        pt2.x = cv::saturate_cast<int>(x0 - 1000*(-b));
        pt2.y = cv::saturate_cast<int>(y0 - 1000*(a));
        cv::line(work_img, pt1, pt2, cv::Scalar(255,0,0), 2, CV_AA);
    }

    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Threshold\n %.2f",self.gain*255];
    
}

@end
