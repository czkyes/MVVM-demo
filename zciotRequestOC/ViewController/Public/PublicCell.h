//
//  PublicCell.h
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicModel.h"
@interface PublicCell : UITableViewCell
@property (strong, nonatomic)UILabel *userName;
@property (strong, nonatomic)UILabel *date;
@property (strong, nonatomic)UIImageView *headImageView;
@property (strong, nonatomic)UITextView *weiboText;
-(void) setValueWithDic : (PublicModel *)publicModel;
@end
