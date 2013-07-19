//
//  FaceDetection.m
//  OpenCVDemos
//
//  Created by 中村 将 on 2013/07/19.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "FaceDetection.h"

@implementation FaceDetection

cv::CascadeClassifier* cascade;
cv::CascadeClassifier* cascade2;

- (id)init
{
    if(self == [super init]) {
        
        NSString* haar = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
        cascade = new cv::CascadeClassifier();
        cascade->load([haar UTF8String]);
        
        NSString* haar2 = [[NSBundle mainBundle] pathForResource:@"haarcascade_eye" ofType:@"xml"];
        cascade2 = new cv::CascadeClassifier();
        cascade2->load([haar2 UTF8String]);
        
    }
	
    return self;
}

// 顔検出
- (cv::Mat)convert:(cv::Mat) src_img{
    
    // グレースケールに変換
    double scale = 2.0;
    cv::Mat work_img, smallImg(cv::saturate_cast<int>(src_img.rows/scale),
                               cv::saturate_cast<int>(src_img.cols/scale),
                               CV_8UC1);
    cv::cvtColor(src_img, work_img, CV_RGB2GRAY);
    
    // 処理時間短縮のために画像を縮小
    cv::resize(work_img, smallImg, smallImg.size(), 0, 0, cv::INTER_LINEAR);
    cv::equalizeHist( smallImg, smallImg);
    
    std::vector<cv::Rect> faces;
    
    /// マルチスケール（顔）探索
    // 画像，出力矩形，縮小スケール，最低矩形数，（フラグ），最小矩形
    cascade->detectMultiScale(smallImg, faces,
                             1.1, 2,
                             CV_HAAR_SCALE_IMAGE,
                             cv::Size(30, 30) );
    
    std::vector<cv::Rect>::const_iterator r = faces.begin();
    for(; r != faces.end(); ++r) {
        
        // 検出結果（顔）の描画
        cv::Point face_center;
        int face_radius;
        face_center.x = cv::saturate_cast<int>((r->x + r->width*0.5)*scale);
        face_center.y = cv::saturate_cast<int>((r->y + r->height*0.5)*scale);
        face_radius = cv::saturate_cast<int>((r->width + r->height)*0.25*scale);
        cv::circle( src_img, face_center, face_radius, cv::Scalar(80,80,255), 3, 8, 0 );
        
        // 
        cv:: Mat smallImgROI = smallImg(*r);
        std::vector<cv::Rect> nestedObjects;
        
        /// マルチスケール（目）探索
        // 画像，出力矩形，縮小スケール，最低矩形数，（フラグ），最小矩形
        cascade2->detectMultiScale(smallImgROI, nestedObjects,
                                        1.1, 3,
                                        CV_HAAR_SCALE_IMAGE,
                                        cv::Size(10,10));
        // 検出結果（目）の描画
        std::vector<cv::Rect>::const_iterator nr = nestedObjects.begin();
        for(; nr != nestedObjects.end(); ++nr) {
            cv::Point center;
            int radius;
            center.x = cv::saturate_cast<int>((r->x + nr->x + nr->width*0.5)*scale);
            center.y = cv::saturate_cast<int>((r->y + nr->y + nr->height*0.5)*scale);
            radius = cv::saturate_cast<int>((nr->width + nr->height)*0.25*scale);
            cv::circle( src_img, center, radius, cv::Scalar(80,255,80), 2, 8, 0 );
        }
    }
    
    return src_img;
}


@end
