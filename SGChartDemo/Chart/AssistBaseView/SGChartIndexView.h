//
//  ExcodeTypeView.h
//  Coinuex
//
//  Created by cww on 2018/7/19.
//  Copyright © 2018年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGChartHeader.h"

//分页导航试图
//分类高度
#define kExcodeTypeViewHeight 40

typedef void(^ExcodeTypeClick)(NSString *type);

@interface SGChartIndexView : UIScrollView


@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *bts;
@property (nonatomic,strong) UIView *line;


@property (nonatomic,copy) ExcodeTypeClick excodeTypeClick;

-(instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array;

@end
