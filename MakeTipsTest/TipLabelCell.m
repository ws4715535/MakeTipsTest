//
//  TipLabelCell.m
//  MakeTipsTest
//
//  Created by ws on 16/9/9.
//  Copyright © 2016年 ws. All rights reserved.
//

#import "TipLabelCell.h"

@implementation TipLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.m_textView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
