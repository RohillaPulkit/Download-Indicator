//
//  DownloadIndicatorView.m
//  DownloadIndicator
//
//  Created by Pulkit Rohilla on 14/12/15.
//  Copyright © 2015 PulkitRohilla. All rights reserved.
//

#import "DownloadIndicatorView.h"

@implementation DownloadIndicatorView{
   
    UIColor *fColor,*bColor;
    CAShapeLayer *backLayer, *drawingLayer;
    UIImage *imageDownload, *imageStop;
    
    float duration;
}

const static CGFloat innerMargin = 10;
const static CGFloat lineWidth = 0.5;

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //init images
    imageDownload = [[UIImage imageNamed:@"Download"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageStop = [[UIImage imageNamed:@"Stop"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    CGRect innerRect = CGRectMake(rect.origin.x + (innerMargin/2 - lineWidth), rect.origin.y + (innerMargin/2 - lineWidth), rect.size.width - innerMargin, rect.size.height - innerMargin);
    
    int radius = innerRect.size.width/2;
    
    CGPoint center = CGPointMake(CGRectGetMidX(innerRect), CGRectGetMidY(innerRect) );
    CGPoint pathCenter = CGPointMake(CGRectGetMidX(innerRect) - radius, CGRectGetMidY(innerRect) - radius);
    
    backLayer = [CAShapeLayer layer];
    backLayer.bounds = self.bounds;
    backLayer.position = center;
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                    cornerRadius:radius];
    shape.path = path.CGPath;
    shape.position = pathCenter;
    shape.fillColor = bColor.CGColor;
    
    [shape setShadowOffset:CGSizeMake(1, 1)];
    [shape setShadowOpacity:0.25];
    [shape setShadowRadius:3];
    
    UIButton *btnDownload = [[UIButton alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width/2, self.bounds.size.height/2)];
    [btnDownload setImage:imageDownload forState:UIControlStateNormal];
    [btnDownload addTarget:self action:@selector(startDownload:) forControlEvents:UIControlEventTouchUpInside];
    [btnDownload setTag:1];
    [btnDownload setTintColor:fColor];
    btnDownload.center = center;
    
    [self.layer addSublayer:shape];
    [self.layer addSublayer:backLayer];
    [self addSubview:btnDownload];
}

-(void)setForeColor:(UIColor *)foreColor{
    
    fColor = foreColor;
}

-(void)setBackColor:(UIColor *)backColor{
    
    bColor = backColor;
}

-(void)setRotationDuration:(float)rotationDuration{
    
    duration = rotationDuration;
}

#pragma mark - OtherMethods

-(void)startDownload:(UIButton *)sender{
    
    if (sender.tag == 1) {
        
        [sender setImage:imageStop forState:UIControlStateNormal];
        [sender setTag:2];
        
        [self startAnimation];
    }
    else
    {
        [sender setImage:imageDownload forState:UIControlStateNormal];
        [sender setTag:1];
        
        [self stopAnimation];
    }
    
}

-(void)startAnimation
{
    CGRect rect = self.bounds;
    
    int radius = rect.size.width/2 - 4.5;
    
    CGPoint centerForArc = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    UIBezierPath * circlePath = [UIBezierPath bezierPathWithArcCenter:centerForArc radius:radius startAngle:3*M_PI/2 endAngle:0 clockwise:YES];

    drawingLayer = [CAShapeLayer layer];
    drawingLayer.lineWidth = 3;
    drawingLayer.lineJoin = kCALineJoinBevel;
    drawingLayer.fillColor = [UIColor clearColor].CGColor;
    drawingLayer.strokeColor = fColor.CGColor;
    
    [drawingLayer setPath:circlePath.CGPath];
    [backLayer addSublayer:drawingLayer];
    

    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = duration;
    //    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    //    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [backLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

-(void)stopAnimation
{
    [drawingLayer removeFromSuperlayer];
    [backLayer removeAllAnimations];
}

@end
