//
//  DetailViewController.m
//  OpenCV_Demo14
//
//  Created by 國武　正督 on 2013/07/05.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Utils.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController {
    AVCaptureSession *session;
}

//MasterViewControllerで選択されたセル番号
@synthesize num;

//FPS測定用変数
int countFPS;
//FPS測定用タイマー
NSTimer *timer = [[NSTimer alloc]init];

/*
 - (void)receiveCellIndex
{
    MasterViewController *master = [[MasterViewController alloc]init];
    num = master.cellIndex;
}
*/



#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    //if (self.detailItem) {
    //    self.detailDescriptionLabel.text = [self.detailItem description];
    //}
    
    // ビデオのキャプチャを開始
    AVCaptureDevice *d = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *cdi = [AVCaptureDeviceInput deviceInputWithDevice:d error:NULL];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings setObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVCaptureVideoDataOutput *cvdo = [[AVCaptureVideoDataOutput alloc] init];
    cvdo.videoSettings = settings;
    [cvdo setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [cvdo setAlwaysDiscardsLateVideoFrames:YES];
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPreset640x480;
    [session commitConfiguration]; //add Kunitake
    if ([session canAddInput:cdi]) {
        [session addInput:cdi];
        [session addOutput:cvdo];
        
        [session startRunning];
        
        // FPS測定開始(タイマー開始）
        countFPS = 0;
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(doTimer:)
                                               userInfo:nil
                                                repeats:YES
                 ];
    }
    else {
        // エラー処理
        NSLog(@"Input Err!!");
    }
    
// セル番号を取得しようとしたが、失敗
//    MasterViewController *master = [[MasterViewController alloc]init];
//    num = master.cellIndex;
    
    //MasterViewControllerで選択されたセル番号を取得
    num = [self.detailItem description].intValue;
    NSLog(@"CellNo. %d",num);
}

//FPS測定(結果画像が1sに何回表示されたか測定)
- (void)doTimer:(NSTimer *)timer
{
    NSLog(@"%d fps",countFPS);
    self.detailDescriptionLabel.text = [NSString stringWithFormat:@"%d fps", countFPS];
    countFPS = 0;
}

- (UIImage*) processWithOpenCV: (CGImageRef) cgImage
{
    // スライダ値を取得
    float gain = _levelSlider.value;
    
    //元となる画像の定義
    cv::Mat src_img = [Utils CVMatFromCGImage:cgImage];

    //選んだセルによって分岐
    switch (num) {
        case 0:
        {
            // ネガポジ反転
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 中間画像作成
            cv::Mat work_img = src_img;
            // ネガポジ反転
            src_img = ~work_img;
        }
            break;

        case 1:
        {
            // ２値化(Binary)
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 入力画像，出力画像，閾値，maxVal，閾値処理手法
            cv::threshold(src_img, src_img, gain*100, 255, cv::THRESH_BINARY);
            // スライダ値によって閾値を変更
        }
            break;

        case 2:
        {
            // ２値化(Binary_Inv)
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 入力画像，出力画像，閾値，maxVal，閾値処理手法
            cv::threshold(src_img, src_img, gain*100, 255, cv::THRESH_BINARY_INV);
            // スライダ値によって閾値を変更
        }
            break;

        case 3:
        {
            // ２値化(Trunk)
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 入力画像，出力画像，閾値，maxVal，閾値処理手法
            cv::threshold(src_img, src_img, gain*100, 255, cv::THRESH_TRUNC);
            // スライダ値によって閾値を変更
        }
            break;

        case 4:
        {
            // ２値化(ToZero)
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 入力画像，出力画像，閾値，maxVal，閾値処理手法
            cv::threshold(src_img, src_img, gain*100, 255, cv::THRESH_TOZERO);
            // スライダ値によって閾値を変更
        }
            break;

        case 5:
        {
            // ２値化(ToZero_Inv)
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 入力画像，出力画像，閾値，maxVal，閾値処理手法
            cv::threshold(src_img, src_img, gain*100, 255, cv::THRESH_TOZERO_INV);
            // スライダ値によって閾値を変更
        }
            break;

        case 6:
        {
            // ２値化(Adaptive)
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 入力画像，出力画像，maxVal，閾値決定手法，閾値処理手法，blockSize，C
            cv::adaptiveThreshold(src_img, src_img, 255-gain*100, cv::ADAPTIVE_THRESH_GAUSSIAN_C, cv::THRESH_BINARY, 7, 8);
            // スライダ値によって閾値を変更
        }
            break;

        case 7:
        {
            // 輪郭検出(Sobel)
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 入力画像，出力画像，出力画像のビット深度，xに関する微分の次数，yに関する微分の次数
            cv::Sobel(src_img, src_img, CV_32F, 1, 1);
            // 絶対値を計算し，結果を 8 ビットに変換
            cv::convertScaleAbs(src_img, src_img, 1, 0);
        }
            break;
            
        case 8:
        {
            // 輪郭検出(Laplacian)
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 入力画像，出力画像，出力画像のビット深度，2次微分フィルタを求めるために利用されるアパーチャのサイズ
            cv::Laplacian(src_img, src_img, CV_32F, 3);
            // 絶対値を計算し，結果を 8 ビットに変換
            cv::convertScaleAbs(src_img, src_img, 1, 0);
        }
            break;
            
        case 9:
        {
            // 輪郭検出(Canny)
            
            // グレースケールに変換
            cv::cvtColor(src_img, src_img, CV_RGB2GRAY);
            // 入力画像，出力画像，1番目の閾値，2番目の閾値
            cv::Canny(src_img, src_img, gain*50, gain*250);
            // スライダ値によって引数を変更
        }
            break;
            
        case 13:
        {
            //楕円フィッティング
            
            // グレースケールに変換
            cv::Mat gray_img, bin_img;
            cv::cvtColor(src_img, gray_img, CV_BGR2GRAY);
            
            std::vector<std::vector<cv::Point> > contours;
            // 画像の二値化
            cv::threshold(gray_img, bin_img, 0, 255, cv::THRESH_BINARY|cv::THRESH_OTSU);
            // 輪郭の検出
            cv::findContours(bin_img, contours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
            
            for(int i = 0; i < contours.size(); ++i) {
                size_t count = contours[i].size();
                
                if(count < gain*150 || count > gain*1000) continue;
                // （小さすぎる|大きすぎる）輪郭を除外 スライダ値で可変
                
                cv::Mat pointsf;
                cv::Mat(contours[i]).convertTo(pointsf, CV_32F);
                // 楕円フィッティング
                cv::RotatedRect box = cv::fitEllipse(pointsf);
                // 楕円の描画
                cv::ellipse(src_img, box, cv::Scalar(255,0,0), 2, CV_AA);
            }
        }
            break;
            
        case 14:
        {
            // 直線検出(Houghlines)
            
            // 中間画像の作成
            cv::Mat work_img;
            // グレースケールに変換後、canny関数で輪郭を抽出
            cv::cvtColor(src_img, work_img, CV_RGB2GRAY);
            cv::Canny(work_img, work_img, 50, 250);
            // Hough変換
            std::vector<cv::Vec2f> lines;
            // 入力画像，出力画像，距離分解能，角度分解能，閾値，*,*
            // 閾値をスライダ値で可変
            cv::HoughLines(work_img, lines, 1, CV_PI/180, gain*200, 0, 0);
            
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
                cv::line(src_img, pt1, pt2, cv::Scalar(255,0,0), 2, CV_AA);
            }
        }
            break;
            
        case 15:
        {
            // 特徴点検出(ORB)
            
            // 中間画像の作成
            cv::Mat work_img;
            // グレースケールに変換
            cv::cvtColor(src_img, work_img, CV_RGB2GRAY);
            // 入力配列，出力配列，範囲の下界，範囲の上界，正規化の種類
            cv::normalize(work_img, work_img, 0, 255, cv::NORM_MINMAX);
            
            std::vector<cv::KeyPoint> keypoints;
            std::vector<cv::KeyPoint>::iterator itk;
            
            // ORB 検出器に基づく特徴点検出
            // 閾値?をスライダ値で可変
            //n_features=300, params=default
            cv::OrbFeatureDetector detector(gain*300);
            cv::Scalar color(255,192,0);
            detector.detect(work_img, keypoints);
            for(itk = keypoints.begin(); itk!=keypoints.end(); ++itk) {
                cv::circle(src_img, itk->pt, 1, color, -1);
                cv::circle(src_img, itk->pt, itk->size, color, 1, CV_AA);
            }
           
        }
            break;
            
        case 19:
        {
            //顔検出
            
            // グレースケールに変換
            double scale = 2.0;
            cv::Mat work_img, smallImg(cv::saturate_cast<int>(src_img.rows/scale),
                                       cv::saturate_cast<int>(src_img.cols/scale),
                                       CV_8UC1);
            cv::cvtColor(src_img, work_img, CV_RGB2GRAY);
            
            // 処理時間短縮のために画像を縮小
            cv::resize(work_img, smallImg, smallImg.size(), 0, 0, cv::INTER_LINEAR);
            cv::equalizeHist( smallImg, smallImg);
            
            // 分類器の読み込み
            std::string cascadeName = "./haarcascade_frontalface_alt.xml"; //パスがわからず、保留中
            cv::CascadeClassifier cascade;
            if(!cascade.load(cascadeName))
            {
                NSLog(@"Error!!");
            }
            std::vector<cv::Rect> faces;
            /// マルチスケール（顔）探索
            // 画像，出力矩形，縮小スケール，最低矩形数，（フラグ），最小矩形
            cascade.detectMultiScale(smallImg, faces,
                                     1.1, 2,
                                     CV_HAAR_SCALE_IMAGE,
                                     cv::Size(30, 30) );
            // 分類器の読み込み
            std::string nested_cascadeName = "./haarcascade_eye.xml"; //パスがわからず、保留中
            //std::string nested_cascadeName = "./haarcascade_eye_tree_eyeglasses.xml";
            cv::CascadeClassifier nested_cascade;
            if(!nested_cascade.load(nested_cascadeName))
            {
                NSLog(@"Error!!");
            }
            
            std::vector<cv::Rect>::const_iterator r = faces.begin();
            for(; r != faces.end(); ++r) {
                // 検出結果（顔）の描画
                cv::Point face_center;
                int face_radius;
                face_center.x = cv::saturate_cast<int>((r->x + r->width*0.5)*scale);
                face_center.y = cv::saturate_cast<int>((r->y + r->height*0.5)*scale);
                face_radius = cv::saturate_cast<int>((r->width + r->height)*0.25*scale);
                cv::circle( src_img, face_center, face_radius, cv::Scalar(80,80,255), 3, 8, 0 );
                
                cv:: Mat smallImgROI = smallImg(*r);
                std::vector<cv::Rect> nestedObjects;
                /// マルチスケール（目）探索
                // 画像，出力矩形，縮小スケール，最低矩形数，（フラグ），最小矩形
                nested_cascade.detectMultiScale(smallImgROI, nestedObjects,
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
        }
            break;
            
        case 20:
        {
            // 人検出(HOG)
            
            cv::HOGDescriptor hog;
            hog.setSVMDetector(cv::HOGDescriptor::getDefaultPeopleDetector());
            
            std::vector<cv::Rect> found;
            // 画像，検出結果，閾値（SVMのhyper-planeとの距離），
            // 探索窓の移動距離（Block移動距離の倍数），
            // 画像外にはみ出た対象を探すためのpadding，
            // 探索窓のスケール変化係数，グルーピング係数
            hog.detectMultiScale(src_img, found, 0.2, cv::Size(8,8), cv::Size(16,16), 1.0, 2);
            ///*ここでエラーになる。画像の形式が違う？
            // Assertion failed (img.type() == CV_8U || img.type() == CV_8UC3) in computeGradient
            
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
        }
            break;
            
    }
    
    CGImageRef effectedCgImage = [Utils CGImageFromCVMat:src_img];
    // 何故か回転してしまうので、元に戻しています
    return [UIImage imageWithCGImage:effectedCgImage scale:1.0f
                         orientation:UIImageOrientationRight];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // イメージバッファの取得
    CVImageBufferRef    buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    // イメージバッファのロック
    CVPixelBufferLockBaseAddress(buffer, 0);
    
    // イメージバッファ情報の取得
    uint8_t*    base;
    size_t      width, height, bytesPerRow;
    base = (uint8_t*)CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    // ビットマップコンテキストの作成
    CGColorSpaceRef colorSpace;
    CGContextRef    cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(
                                      base, width, height, 8, bytesPerRow, colorSpace,
                                      kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    // 画像の加工
    CGImageRef  cgImage;
    UIImage*    image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [self processWithOpenCV: cgImage];
    
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    // イメージバッファのアンロック
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    
    // 画像の表示
    self.imageView.image = image;
    
    //FPS測定
    countFPS++;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory Warning!");
}

@end
