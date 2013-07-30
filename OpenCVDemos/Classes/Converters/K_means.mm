//
//  K_means.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/22.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "K_means.h"

@implementation K_means

- (cv::Mat)convert:(cv::Mat) src_img{
    
    // K-meansによるピクセル値のクラスタリング（減色）
    
    // 中間画像作成
    cv::Mat work_img;
    cv::cvtColor(src_img, work_img, CV_RGBA2RGB);

    // 画像を1列の行列に変形
    cv::Mat points;
    work_img.convertTo(points, CV_32FC3);
    points = points.reshape(3, work_img.rows*work_img.cols);
    
    const int cluster_count = 10; // クラスタ数
    
    // RGB空間でk-meansを実行
    cv::Mat_<int> clusters(points.size(), CV_32SC1);
    cv::Mat centers;
    // クラスタ対象，クラスタ数，（出力）クラスタインデックス，
    // 停止基準，k-meansの実行回数，手法，（出力）クラスタ中心値
    cv::kmeans(points, cluster_count, clusters, cvTermCriteria(CV_TERMCRIT_EPS|CV_TERMCRIT_ITER, 10, 1.0), 1, cv::KMEANS_PP_CENTERS, centers);
    
    // すべてのピクセル値をクラスタ中心値で置き換え
    cv::Mat dst_img(work_img.size(), work_img.type());
    cv::MatIterator_<cv::Vec3b> itd = dst_img.begin<cv::Vec3b>(),
    itd_end = dst_img.end<cv::Vec3b>();
    for(int i=0; itd != itd_end; ++itd, ++i) {
        cv::Vec3f &color = centers.at<cv::Vec3f>(clusters(i), 0);
        (*itd)[0] = cv::saturate_cast<uchar>(color[0]);
        (*itd)[1] = cv::saturate_cast<uchar>(color[1]);
        (*itd)[2] = cv::saturate_cast<uchar>(color[2]);
    }

    return dst_img;
}

@end
