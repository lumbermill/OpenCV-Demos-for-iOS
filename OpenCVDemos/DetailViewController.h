//
//  DetailViewController.h
//  OpenCV_Demo14
//
//  Created by 國武　正督 on 2013/07/05.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <opencv2/opencv.hpp>
#import "Converter.h"
#import "NegaPosi.h"


@interface DetailViewController : UIViewController
<AVCaptureVideoDataOutputSampleBufferDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    UIPopoverController *popover;    
}

@property Converter *converter;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *levelSlider;

//@property (strong, nonatomic) NSIndexPath *detailItem;
//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic) UIImage *effBufImage;
@property (nonatomic) UIImagePickerControllerSourceType sourceType;

@property (nonatomic) int img_source;
@property (nonatomic) UILabel *fpsLabel;
@property (nonatomic) UILabel *infoLabel01;
@property (nonatomic) UILabel *infoLabel02;
@property (nonatomic) UILabel *infoLabel03;
//@property (nonatomic) UILabel *infoLabel04;
@property (nonatomic) bool invertSW;

@property (assign, nonatomic) BOOL usingFrontCamera;

- (IBAction)invertBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *invertBtn;

- (IBAction)reloadBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadBtn;

- (IBAction)backButtonEvent:(id)sender;


@end
