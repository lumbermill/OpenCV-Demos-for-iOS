//
//  HoughlinesP.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "HoughlinesP.h"

@implementation HoughlinesP

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 直線検出(HoughLinesP)
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    cv::Mat dst_img;
    
    // グレースケールに変換後、canny関数で輪郭を抽出
    cv::cvtColor(src_img, dst_img, CV_RGB2GRAY);
    cv::Canny(dst_img, dst_img, 50, 250, 3);
    // 確率的Hough変換
    std::vector<cv::Vec4i> lines;
    // 入力画像，出力，距離分解能，角度分解能，閾値，線分の最小長さ，2点が同一線分上にあると見なす場合に許容される最大距離
    cv::HoughLinesP(dst_img, lines, 1, CV_PI/180, self.gain*255, 50, 10);
    // 閾値をスライダ値で可変
    
    // 直線の描画
    std::vector<cv::Vec4i>::iterator it = lines.begin();
    for(; it!=lines.end(); ++it) {
        cv::Vec4i l = *it;
        cv::line(work_img, cv::Point(l[0], l[1]), cv::Point(l[2], l[3]), cv::Scalar(255,0,0), 2, CV_AA);
    }

    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Threshold\n %.2f",self.gain*255];
    
}

@end
