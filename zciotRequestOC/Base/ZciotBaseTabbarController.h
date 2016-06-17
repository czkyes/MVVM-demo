//
//  ZciotBaseTabbarController.h
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/21.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZciotBaseTabbarController : UITabBarController
@property (nonatomic,strong)NSMutableArray *navs;
@property (nonatomic,strong)NSArray *views;
@property (nonatomic,strong)NSArray *tabTitles;
@property (nonatomic,strong)NSArray *tabNorImgs;
@property (nonatomic,strong)NSArray *tabSelImgs;
@property (nonatomic,strong)UIColor *titleHighlightedColor;
@property (nonatomic,strong)UIColor *titleNorColor;

@end
