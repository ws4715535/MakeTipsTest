//
//  TipFooterView.m
//  MakeTipsTest
//
//  Created by ws on 16/9/9.
//  Copyright © 2016年 ws. All rights reserved.
//

#import "TipFooterView.h"

@implementation TipFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//
//- (IBAction)setLocationPoint {
//}
//
//
//
//- (IBAction)addText {
//}
//
//
//- (IBAction)addImage {
//}
//
//
//- (IBAction)addTips {
//}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.m_ovalView.layer.cornerRadius = 15;
    self.m_ovalView.layer.borderWidth = 1;
    self.m_ovalView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.m_ovalView.layer.masksToBounds = YES;
//    self.m_ovalView.backgroundColor = [UIColor blackColor];
}

@end
