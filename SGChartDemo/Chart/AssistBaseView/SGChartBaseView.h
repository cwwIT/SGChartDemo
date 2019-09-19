//
//  SGDrawBaseView.h
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGShapeLayer.h"
#import "SGBrokenLineModel.h"
#import "SGHistogramModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SGChartBaseView : UIView

-(CALayer *)createLayerByType:(NSInteger)type;
//描边线
- (SGShapeLayer *)createLayer;
//填充
- (SGShapeLayer *)createFillLayer;

- (SGBezierPath *)createPath;

@end

NS_ASSUME_NONNULL_END
