//
//  WSTextView.m
//  MakeTipsTest
//
//  Created by ws on 16/9/9.
//  Copyright © 2016年 ws. All rights reserved.
//

#import "WSTextView.h"

NSString * TextViewRemovedNotification = @"TextViewRemovedNotification";
@implementation WSTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        _index = -1;  // 防止默认为0
    }
    return self;
}

- (void)deleteBackward {
    [super deleteBackward];

    if (self.text.length == 0) {
        // remove that row in tableView
        [[NSNotificationCenter defaultCenter] postNotificationName:TextViewRemovedNotification object:nil userInfo:@{ @"info" : [NSNumber numberWithInteger:_index]}];
        NSLog(@"REMOVE >>>>>>");
        
    }

}

@end
