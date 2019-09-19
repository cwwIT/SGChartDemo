//
//  SGHistogramModel.h
//  SGBlueTooth
//
//  Created by sungrow on 2019/9/18.
//  Copyright © 2019 CWW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SGChartHeader.h"

NS_ASSUME_NONNULL_BEGIN
//柱状图 模型
@interface SGHistogramModel : NSObject

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat lineWidth; 
@property (nonatomic,assign) CGFloat lineSpace;
@property (nonatomic,assign) CGFloat index;     //数组中的下标
@property (nonatomic,copy) NSString *time;      //时间
@property (nonatomic,copy) NSString *PV;        //电量

@end

NS_ASSUME_NONNULL_END
