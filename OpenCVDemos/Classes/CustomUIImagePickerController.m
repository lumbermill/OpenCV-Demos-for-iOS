//
//  CustomUIImagePickerController.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/31.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "CustomUIImagePickerController.h"

@interface CustomUIImagePickerController ()

@end

@implementation CustomUIImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 横向き対応
- (BOOL)shouldAutorotate {
    return YES;
}

// 横向き対応
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
