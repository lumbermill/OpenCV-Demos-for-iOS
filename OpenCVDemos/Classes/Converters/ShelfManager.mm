//
//  ShelfManager.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/08/23.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "ShelfManager.h"

@implementation ShelfManager

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 直線検出(Houghlines)
    
    // 中間画像作成
    cv::Mat work_img = src_img;
    cv::Mat dst_img;
    
    // グレースケールに変換後、canny関数で輪郭を抽出
    cv::cvtColor(src_img, dst_img, CV_RGB2GRAY);

    // コントラストを上げる
    cv::equalizeHist(dst_img, dst_img);

    // ぼかしでノイズ低減
    //cv::medianBlur(dst_img, dst_img, 9);

    // 2値化　入力画像，出力画像，閾値，maxVal，閾値処理手法
    //cv::threshold(dst_img, dst_img, self.gain*255, 255, cv::THRESH_BINARY);
    // スライダ値によって閾値を変更
    
    // 入力画像，出力画像，閾値，maxVal，閾値処理手法
    //cv::threshold(dst_img, dst_img, self.gain*255, 255, cv::THRESH_TOZERO);
    // スライダ値によって閾値を変更

    cv::Canny(dst_img, dst_img, self.gain*255, self.gain*255, 3);
    
    int distance = self.gain2nd * 100 + 1;
    
    
    // 古典的Hough変換
    std::vector<cv::Vec2f> lines;
    // 入力画像，出力画像，距離分解能，角度分解能，閾値，*,*
    cv::HoughLines(dst_img, lines, distance, CV_PI/2, 200, 0, 0);
    // 閾値をスライダ値で可変

    // 直線の描画
    std::vector<cv::Vec2f>::iterator it = lines.begin();
    for(; fmin(it!=lines.end(),50); ++it) {
        float rho = (*it)[0], theta = (*it)[1];
        cv::Point pt1, pt2;
        double a = cos(theta), b = sin(theta);
        double x0 = a*rho, y0 = b*rho;
        pt1.x = cv::saturate_cast<int>(x0 + 2000*(-b));
        pt1.y = cv::saturate_cast<int>(y0 + 2000*(a));
        pt2.x = cv::saturate_cast<int>(x0 - 2000*(-b));
        pt2.y = cv::saturate_cast<int>(y0 - 2000*(a));
        cv::line(work_img, pt1, pt2, cv::Scalar(255,0,0), 3, CV_AA);
    }
   
    return work_img;
}

- (NSString *)getGainFormat{
    return [NSString stringWithFormat:@"Threshold\n %.2f",self.gain*255];
    
}
- (NSString *)getGain2ndFormat{
    int distance = self.gain2nd * 100;
    return [NSString stringWithFormat:@"Distance\n %d",distance];
    
}


@end
