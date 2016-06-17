//
//  PublicWeiboViewModel.h
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "ViewModelClass.h"

@interface PublicWeiboViewModel : ViewModelClass


//获取电子围栏列表
-(void) fetchDianziWeilan:(NSDictionary *)dition address:(NSString *)address;
@end
