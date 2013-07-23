//
//  HumanDetection.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/23.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "HumanDetection.h"

@implementation HumanDetection

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // 人検出(HOG)

    /*
    cv::HOGDescriptor hog;
    hog.setSVMDetector(cv::HOGDescriptor::getDefaultPeopleDetector());
    
    std::vector<cv::Rect> found;
    // 画像，検出結果，閾値（SVMのhyper-planeとの距離），
    // 探索窓の移動距離（Block移動距離の倍数），
    // 画像外にはみ出た対象を探すためのpadding，
    // 探索窓のスケール変化係数，グルーピング係数
    hog.detectMultiScale(src_img, found, 0.2, cv::Size(8,8), cv::Size(16,16), 1.0, 2);
    // ここでエラーになる。画像の形式が違う？
    // Assertion failed (img.type() == CV_8U || img.type() == CV_8UC3) in computeGradient
    // OpenCV Referenceには "Source image. CV_8UC1 and CV_8UC4 types are supported for now."と書いてあるが..
    
    std::vector<cv::Rect>::const_iterator it = found.begin();
    std::cout << "found:" << found.size() << std::endl;
    for(; it!=found.end(); ++it) {
        cv::Rect r = *it;
        // 描画に際して，検出矩形を若干小さくする
        r.x += cvRound(r.width*0.1);
        r.width = cvRound(r.width*0.8);
        r.y += cvRound(r.height*0.07);
        r.height = cvRound(r.height*0.8);
        cv::rectangle(src_img, r.tl(), r.br(), cv::Scalar(0,255,0), 2);
    }
    */
   
    return src_img;
}

@end
