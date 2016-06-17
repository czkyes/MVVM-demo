//
//  ZciotNavigationController.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/21.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "ZciotNavigationController.h"

@interface ZciotNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation ZciotNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.delegate = self;
    }
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor]; //左barbutton颜色
    
    self.navigationBar.barTintColor = UIColorFromRGB(0xdd302e);//navigationBar颜色
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                      
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    // Do any additional setup after loading the view.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&(self.viewControllers.count>1);
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
