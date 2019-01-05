//
//  DownloadIndicatorView.h
//  DownloadIndicator
//
//  Created by Pulkit Rohilla on 14/12/15.
//  Copyright © 2015 PulkitRohilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DownloadIndicatorView

-(void)didStartDownload;
-(void)didStopDownload;

@end

IB_DESIGNABLE
@interface DownloadIndicatorView : UIView

@property (assign) id<DownloadIndicatorView> delegate;

@property (strong, nonatomic) IBInspectable UIColor *foreColor;
@property (strong, nonatomic) IBInspectable UIColor *backColor;

@property (nonatomic) IBInspectable float rotationDuration;

@end
