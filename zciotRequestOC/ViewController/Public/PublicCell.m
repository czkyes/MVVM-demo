//
//  PublicCell.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "PublicCell.h"

@implementation PublicCell
-(void) setValueWithDic : (PublicModel *)publicModel
{
//    _userName.text = publicModel.userName;
//    _date.text = publicModel.date;
//    _weiboText.text = publicModel.text;
//    [_headImageView setImageWithURL:publicModel.imageUrl];
    self.textLabel.text = publicModel.name;
    //self.detailTextLabel.text = publicModel.date;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
