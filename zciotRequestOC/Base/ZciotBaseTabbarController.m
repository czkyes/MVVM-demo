//
//  ZciotBaseTabbarController.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/21.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "ZciotBaseTabbarController.h"
#import "ZciotNavigationController.h"
@interface ZciotBaseTabbarController ()<UITabBarControllerDelegate>

@end

@implementation ZciotBaseTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _navs = [NSMutableArray new];
    for (int i = 0 ; i<_views.count; i++) {
        ZciotNavigationController *nav = [[ZciotNavigationController alloc]initWithRootViewController:_views[i]];
        UIImage *norImg = [UIImage imageNamed:_tabNorImgs[i]];
        UIImage *selImg = [UIImage imageNamed:_tabSelImgs[i]];
        [norImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [selImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.title = _tabTitles[i];
        nav.tabBarItem.selectedImage = selImg;
        nav.tabBarItem.image = norImg;
        nav.topViewController.title = _tabTitles[i];//导航栏标题
        [_navs addObject:nav];
    }
    _titleHighlightedColor = UIColorFromRGB(0xea6d66);
    _titleNorColor = UIColorFromRGB(0x868686);
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:_titleNorColor} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:_titleHighlightedColor} forState:UIControlStateSelected];
    self.viewControllers = _navs;
    if (_navs.count>0) {
        self.tabBarController.selectedViewController = _navs[0];
    }
    
    self.tabBar.translucent = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
