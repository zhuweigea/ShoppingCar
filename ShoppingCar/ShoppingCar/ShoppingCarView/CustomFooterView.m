//
//  CustomFooterView.m
//  demos
//
//  Created by 朱伟阁 on 2019/2/16.
//  Copyright © 2019 朱伟阁. All rights reserved.
//

#import "CustomFooterView.h"

@implementation CustomFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return self;
}

@end
