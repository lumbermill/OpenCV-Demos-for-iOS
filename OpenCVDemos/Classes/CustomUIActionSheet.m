//
//  CustomUIActionSheet.m
//  OpenCVDemos
//
//  Created by 國武　正督 on 2013/07/31.
//  Copyright (c) 2013年 Rz.inc. All rights reserved.
//

#import "CustomUIActionSheet.h"

@implementation CustomUIActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// 横向き対応
- (BOOL)shouldAutorotate {
    return YES;
}

// 横向き対応
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
