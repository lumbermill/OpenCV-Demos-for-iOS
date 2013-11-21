//
//  DetailViewController.m
//  OpenCV_Demo14
//
//  Created by 國武　正督 on 2013/07/05.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Utils.h"
#import "AVFUtils.h"
#import "CustomUIImagePickerController.h"

@implementation DetailViewController {
    AVCaptureSession *session;

}

// ユーザーデフォルト（画像のソース選択結果）の呼び出し
//0:Library, 1:Camera ,2:Photo Album
@synthesize img_source;

// ネガポジ反転スイッチ
@synthesize invertSW;

//共通変数の定義
@synthesize effBufImage;
@synthesize fpsLabel;
@synthesize infoLabel01;
@synthesize infoLabel02;
@synthesize infoLabel03;
//@synthesize infoLabel04;

//MasterViewControllerで選択された変換処理クラス
@synthesize converter;

// ネガポジ反転インスタンス作成
id negapoji = [[NegaPosi alloc] init];

// 画像回転インスタンス作成
id orientationRight = [[OrientationRight alloc] init];

//FPS測定用変数
int countFPS;

//FPS測定用タイマー
NSTimer *timer = [[NSTimer alloc]init];

// 現在のキャプチャデバイス
AVCaptureDevice *device;
AVCaptureDeviceInput *videoInput;
AVCaptureVideoDataOutput *videoOutput;
AVCaptureConnection *videoConnection;
BOOL usingFrontCamera = NO;

// アクティビティインジケータ
UIActivityIndicatorView *indicator;

#pragma mark - Initialize
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // インフォメーションモニタラベル実装
    [self makeMonitorLabel];
    
    if (img_source == 1) {
        // リアルタイム変換時はReloadボタンで静止画をアルバムに保存する
        self.reloadBtn.title = NSLocalizedString(@"ReloadBtnTitle",@"ReloadBtnTitle");
        // changeCameraBtnは静止画変換時のみ実装
        [self makeChangeCameraBtn];
    }
    else {
        // ImgPickBtnは静止画変換時のみ実装
        [self makeImgPickBtn];
    }
    
    // ネガポジ反転スイッチ初期化
    invertSW = NO;
    self.invertBtn.tintColor = [UIColor grayColor];
    
    // スライダーの初期値を通知
    converter.gain = _levelSlider.value;
    converter.gain2nd = _levelSlider2nd.value;
    infoLabel01.text = [converter getGainFormat];
    infoLabel02.text = [converter getGain2ndFormat];

    // スライダーが変更されたとき
    [_levelSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_levelSlider2nd addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // アクティビティインジケータ作成
    indicator = [[UIActivityIndicatorView alloc]init];
    // 位置を指定（画面の中央に表示する）
    indicator.center = self.view.center;
    indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin;
    // スタイルをセット
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.color = [UIColor redColor];
    // UIActivityIndicatorViewのインスタンスをビューに追加
    [self.view addSubview:indicator];
    
}

// MasterViewへ戻るときのイベント
- (void)viewDidDisappear:(BOOL)animated
{
    // キャプチャ停止
    [session stopRunning];
    
    // タイマー停止
    [timer invalidate];
        
    [super viewDidDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    // img_source = 1 だったらリアルタイム変換モード
    if (img_source == 1) {
        
        // ビデオキャプチャの定義
        
        // セッションの定義
        session = [[AVCaptureSession alloc] init];
        session.sessionPreset = AVCaptureSessionPreset640x480;
        [session beginConfiguration];

        // デバイスの定義
        // フロントカメラを使っていたとき
        if(usingFrontCamera)
        {
            // フロントカメラを検索
            for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
                if ([d position] == AVCaptureDevicePositionFront) {
                    device = d;
                    usingFrontCamera = YES;
                    break;
                }
                else {
                    // フロントカメラがなければデフォルトのカメラを使用
                    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                    usingFrontCamera = NO;
                }
            }
        }
        // フロントカメラを使っていなかったとき
        else {
            // デフォルトのカメラを使用
            device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            usingFrontCamera = NO;
        }
        
        // キャプチャ入力の定義
        videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
        
        // セッションに入力を追加
        bool canInputSession = NO;
        if ([session canAddInput:videoInput]) {
            [session addInput:videoInput];
            canInputSession = YES;
        }
        
        // キャプチャ出力の定義
        videoOutput =  [[AVCaptureVideoDataOutput alloc] init];
        NSMutableDictionary *settings = [NSMutableDictionary dictionary];
        [settings setObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        videoOutput.videoSettings = settings;
        [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        [videoOutput setAlwaysDiscardsLateVideoFrames:YES];

        // セッションに出力を追加
        bool canOutputSession = NO;
        if ([session canAddOutput:videoOutput]) {
            [session addOutput:videoOutput];
            canOutputSession = YES;
        }
        
        // ビデオ入力のAVCaptureConnectionを取得 <- addInputとaddOutputが終わってから
        videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
        // 本体の向きをAVFoundationへ通知
        //  自動的に向きを取得
        videoConnection.videoOrientation = [AVFUtils videoOrientationFromDeviceOrientation:[UIDevice currentDevice].orientation];
        //  強制的にPortraitで固定（Landscapeをサポートしないとき）
        //videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        
 
        [session commitConfiguration];
        
        // ビデオのキャプチャを開始
        if (canInputSession && canOutputSession)
        {
            [session startRunning];
            [self startTimer];
        }
        else {
            // エラー処理
            NSLog(@"Session Err!!");
        }
    }
    [super viewDidAppear:animated];
}


#pragma mark - OpenCV
// キャプチャ中は常に呼び出される
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    // イメージバッファの取得
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(buffer, 0);

    uint8_t* base = (uint8_t*)CVPixelBufferGetBaseAddress(buffer);
    size_t width = CVPixelBufferGetWidth(buffer);
    size_t height = CVPixelBufferGetHeight(buffer);
    cv::Mat src = cv::Mat(height,width,CV_8UC4,base);

    // イメージバッファから画像を作成
    //UIImage *image = [AVFUtils imageFromSampleBuffer:sampleBuffer];
    
    // 画像の加工
    self.imageView.image = [self processWithOpenCV: src];
    
    // フロントカメラの場合は左右反転
    if (usingFrontCamera) {
        self.imageView.Transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
    }
    else {
        self.imageView.Transform = CGAffineTransformMakeScale(1.0f, 1.0f);        
    }
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    
    //FPS測定
    countFPS++;
}

// 静止画の変換と表示
- (void) photoImageViewing {
    
    // 画像を選択してないとエラーになるので回避処理
    if (effBufImage) {
 
        // アクティビティインジケータを表示
        [indicator startAnimating];
        // RunLoopに戻らないと表示されないので、一瞬戻す
        [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0]];
        
        // 画像の加工
        cv::Mat src = [Utils CVMatFromUIImage:effBufImage];
        UIImage *effectImage;
        effectImage = [self processWithOpenCV: src];
        
        // アクティビティインジケータが動いていたら止める
        if (indicator.isAnimating) {
            [indicator stopAnimating];
        }
        
        //加工した画像の表示
        self.imageView.image = effectImage;
        
        // 静止画をアルバムに保存
        //UIImageWriteToSavedPhotosAlbum(effectImage, nil, nil, nil);
        
        // インフォメーションラベル更新
        [self refreshInfoLabel];
    }
}

// OpenCV関数を使って画像を変換します
- (UIImage*) processWithOpenCV: (cv::Mat) src_img
{
    // 元となる画像の定義
    // cv::Mat src_img = [Utils CVMatFromUIImage:image];
    
    // Saved Photos 選択時は変換前に回転させる
    if (img_source == 2) {
        src_img = [orientationRight convert:src_img];
    }
    
   // 変換処理
    src_img = [converter convert:src_img];
    if(src_img.channels() >= 3){
        cv::cvtColor(src_img, src_img, CV_BGR2RGB);
    }
    
    // ネガポジ反転有効時
    if (invertSW) {
        src_img = [negapoji convert:src_img];
    }
    
    UIImage *effectedImage = [Utils UIImageFromCVMat:src_img];
    
    return effectedImage;
}


#pragma mark - Button
// 右上のボタン（写真選択）を押したとき
- (void)photoButtonTouched
{
    // num = 0 or 2 だったら静止画変換モード
    // num = 3（キャンセル）だとフォトライブラリ
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    switch (img_source) {
        case 0: {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        }
        case 1: {
            //sourceType = UIImagePickerControllerSourceTypeCamera;
            //カメラはAVFoundationクラスで実装
            break;
        }
        case 2: {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        }
        case 3: {
            NSLog(@"Cancel");
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
    }
    
    // 使用可能かどうかチェックする
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        // イメージピッカーを作る
        // 横向き対応のため、カスタムクラスを使う
        UIImagePickerController* picker = [[CustomUIImagePickerController alloc]init];
        picker.sourceType = sourceType;
        picker.delegate = self;

        // イメージピッカーを表示する
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else {
        // エラー処理
        NSLog(@"Photo Err!!");
    }
    
}

// UIImagePickerの呼び出し
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    effBufImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        // 静止画の変換と表示
        [self photoImageViewing];
        
    }];
}

// 右上のボタン（カメラのフロント/バック切り替え）を押したとき
- (void)changeCameraBtnTouched
{
    // フロントカメラを使っていたとき
    if(usingFrontCamera)
    {
        // デフォルトのカメラを使用
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        usingFrontCamera = NO;
    }

    // フロントカメラを使っていなかったとき
    else {
        // フロントカメラを検索
        for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            if ([d position] == AVCaptureDevicePositionFront) {
                device = d;
                usingFrontCamera = YES;
                break;
            }
            else {
                // フロントカメラがなければデフォルトのカメラを使用
                device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
                usingFrontCamera = NO;
            }
        }        
    }

    // セッション切り替え
    [self sessionTransfer];
    
}

// デバイス(UIView)回転時に呼び出されるメソッド
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {

    if(interfaceOrientation == UIInterfaceOrientationPortrait){
        NSLog(@"ホームボタン下");
    }
    else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        NSLog(@"ホームボタン上");
    }
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        NSLog(@"ホームボタン右");
    }
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        NSLog(@"ホームボタン左");
    }

     if (img_source == 1) {
        // セッション切り替え
        [self sessionTransfer];
     }
}

// セッション切り替え
- (void)sessionTransfer {

    [session stopRunning];
    [session beginConfiguration];
    [session removeInput:videoInput];
    videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:videoInput];
    videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    // 本体の向きをAVFoundationへ通知
      // 自動的に向きを取得
    videoConnection.videoOrientation = [AVFUtils videoOrientationFromDeviceOrientation:[UIDevice currentDevice].orientation];
      // 強制的にPortraitで固定（Landscapeをサポートしないとき）
    //videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    [session commitConfiguration];
    [session startRunning];

}



// Reloadボタンで変換やり直し
- (IBAction)reloadBtn:(id)sender
{
    // ソースタイプ：静止画のとき
    if (img_source != 1)
    {
        [self photoImageViewing];
    }
    else {
        // リアルタイム変換時は静止画をアルバムに保存
        AudioServicesPlaySystemSound(1108);
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
    }
}

// Invertボタンでネガポジ反転
- (IBAction)invertBtn:(id)sender
{
    // ネガポジ反転スイッチ切り替え
    if (invertSW)
    {
        invertSW = NO;
        self.invertBtn.tintColor = [UIColor grayColor];
        // 色が変わらない..??
        //AudioServicesPlaySystemSound(1109);
    }
    else
    {
        invertSW = YES;
        self.invertBtn.tintColor = [UIColor magentaColor];
        //AudioServicesPlaySystemSound(1305);
    }
}


#pragma mark - Timer

// インフォメーションラベル更新
- (void)refreshInfoLabel
{
    infoLabel03.text = [NSString stringWithFormat:@"Memory usage\n %@",[Utils convertByteToKB:[Utils getMemoryUsage]]];
}


// FPS測定開始(タイマー開始）
- (void)startTimer
{
    countFPS = 0;
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(doTimer:)
                                           userInfo:nil
                                            repeats:YES
             ];
}

//FPS測定(結果画像が1sに何回表示されたか測定)
- (void)doTimer:(NSTimer *)timer
{
    NSLog(@"%d fps",countFPS);
    fpsLabel.text = [NSString stringWithFormat:@"%d fps", countFPS];
    countFPS = 0;
    
    // インフォメーションラベル更新
    [self refreshInfoLabel];
}


// スライダ値を取得
- (IBAction) sliderValueChanged:(UISlider *)sender {
}
- (IBAction)levelSlider:(UISlider *)sender {
    converter.gain = [sender value];
    infoLabel01.text = [converter getGainFormat];
}
- (IBAction)levelSlider2nd:(UISlider *)sender {
    converter.gain2nd = [sender value];
    infoLabel02.text = [converter getGain2ndFormat];
}



#pragma mark - Label
// FPSモニタラベルを作成
- (void)makeMonitorLabel
{
    
    // FPSモニタラベル設置
    CGRect rect = CGRectMake(0, 0, 100, 20);
    fpsLabel = [[UILabel alloc]initWithFrame:rect];
    
    // FPSモニタラベルのテキストを設定
    fpsLabel.text = @"0 fps";
    
    // FPSモニタラベルのテキストのフォントを設定
    fpsLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    
    // FPSモニタラベルのテキストの色を設定
    fpsLabel.textColor = [UIColor yellowColor];
    
    // FPSモニタラベルのテキストの影を設定
    //fpsLabel.shadowColor = [UIColor grayColor];
    //fpsLabel.shadowOffset = CGSizeMake(1, 1);
    
    // FPSモニタラベルのテキストの位置を設定
    fpsLabel.textAlignment = NSTextAlignmentCenter;
    
    // FPSモニタラベルのテキストの行数設定
    fpsLabel.numberOfLines = 1; // 0の場合は無制限
    
    // FPSモニタラベルの背景色を設定
    fpsLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    
    // FPSモニタラベルをビューに追加
    [self.view addSubview:fpsLabel];
    
    
    // インフォメーションモニタラベル設置
    CGRect rect01 = CGRectMake(0, 20, 100, 40);
    infoLabel01 = [[UILabel alloc]initWithFrame:rect01];
    CGRect rect02 = CGRectMake(0, 60, 100, 40);
    infoLabel02 = [[UILabel alloc]initWithFrame:rect02];
    CGRect rect03 = CGRectMake(0, 100, 100, 40);
    infoLabel03 = [[UILabel alloc]initWithFrame:rect03];
    
    // インフォメーションモニタラベルの書式設定
    infoLabel01.text = [NSString stringWithFormat:@"Information\n  -  "];
    infoLabel01.textColor = [UIColor whiteColor];
    infoLabel01.shadowColor = [UIColor blackColor];
    infoLabel01.shadowOffset = CGSizeMake(1, 1);
    infoLabel01.font = [UIFont fontWithName:@"Helvetica" size:14];
    infoLabel01.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    infoLabel01.numberOfLines = 0; // 0の場合は無制限
    infoLabel02.text = [NSString stringWithFormat:@"Information\n  -  "];
    infoLabel02.textColor = infoLabel01.textColor;
    infoLabel02.shadowColor = infoLabel01.shadowColor;
    infoLabel02.shadowOffset = infoLabel01.shadowOffset;
    infoLabel02.font = infoLabel01.font;
    infoLabel02.backgroundColor = infoLabel01.backgroundColor;
    infoLabel02.numberOfLines = 0; // 0の場合は無制限
    infoLabel03.text = [NSString stringWithFormat:@"Memory usage\n %@",[Utils convertByteToKB:[Utils getMemoryUsage]]];
    infoLabel03.textColor = infoLabel01.textColor;
    infoLabel03.shadowColor = infoLabel01.shadowColor;
    infoLabel03.shadowOffset = infoLabel01.shadowOffset;
    infoLabel03.textAlignment = NSTextAlignmentRight;
    infoLabel03.font = infoLabel01.font;
    infoLabel03.backgroundColor = infoLabel01.backgroundColor;
    infoLabel03.numberOfLines = 0; // 0の場合は無制限
    
    [self.view addSubview:infoLabel01];
    [self.view addSubview:infoLabel02];
    [self.view addSubview:infoLabel03];

}

// システム標準画像を使ったボタン作成
- (void)makeImgPickBtn
{
        // 静止画変換時は画像ファイル選択ボタンを実装する
        UIBarButtonItem *imgPickBtn = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCompose  // スタイル指定（使い方は不適切..)
                                       target:self  // デリゲートのターゲットを指定
                                       action:@selector(photoButtonTouched)  // ボタンが押されたときに呼ばれるメソッドを指定
                                       ];
        self.navigationItem.rightBarButtonItem = imgPickBtn;
}

// システム標準画像を使ったボタン作成
- (void)makeChangeCameraBtn
{
    // リアルタイム変換時はフロント or バックカメラ切り替えボタンを実装する
    UIBarButtonItem *changeCameraBtn = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  // スタイル指定（使い方は不適切..)
                                        target:self  // デリゲートのターゲットを指定
                                        action:@selector(changeCameraBtnTouched)  // ボタンが押されたときに呼ばれるメソッドを指定
                                        ];
    self.navigationItem.rightBarButtonItem = changeCameraBtn;
}



#pragma mark - Error
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Memory Warning!");
}

@end
