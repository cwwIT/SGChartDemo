//
//  SGDrawBaseView.m
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import "SGChartBaseView.h"

@implementation SGChartBaseView


#pragma mark layer path init
-(CALayer *)createLayerByType:(NSInteger)type{
    
    CGFloat w = self.frame.size.width-1.0;
    CGFloat h = w;
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, w, h);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    return layer;
}
//描边线
- (SGShapeLayer *)createLayer {
    
    SGShapeLayer *layer = [SGShapeLayer layer];
    layer.strokeColor = [UIColor darkGrayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    return layer;
}
//填充
- (SGShapeLayer *)createFillLayer {
    
    SGShapeLayer *layer = [SGShapeLayer layer];
    layer.strokeColor = [UIColor clearColor].CGColor;
    layer.fillColor = kSGMTDBlueColor.CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    return layer;
}

- (SGBezierPath *)createPath {
    SGBezierPath *path = [SGBezierPath bezierPath];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    return path;
}


@end
