//
//  HotAddressListSectionHeader.m
//  bither-ios
//
//  Copyright 2014 http://Bither.net
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "HotAddressListSectionHeader.h"
#import "UIImage+ImageWithColor.h"
#import "UIColor+Util.h"

#define kBackgroundColor (0xE1EBF2)
#define kBackgroundColorPressed (0xCEE2F5)

#define kFontSize (17)
#define kTextColor (0x0099cc)
#define kMargin (5)

#define kPadding (10)

@interface HotAddressListSectionHeader(){
    NSUInteger _section;
}

@end

@implementation HotAddressListSectionHeader

-(instancetype)initWithSize:(CGSize)size isPrivate:(BOOL)isPrivate section:(NSUInteger)section delegate:(NSObject<SectionHeaderPressedDelegate>*)delegate{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if(self){
        self.delegate = delegate;
        _section = section;
        BOOL folded = NO;
        if(delegate && [delegate respondsToSelector:@selector(isSectionFolded:)]){
            folded = [delegate isSectionFolded:section];
        }
        [self isPrivate:isPrivate isFolded:folded];
    }
    return self;
}

-(void)isPrivate:(BOOL)isPrivate isFolded:(BOOL)isFolded{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    btn.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor parseColor:kBackgroundColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor parseColor:kBackgroundColorPressed]] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    UIImageView *ivIndicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_item_address_group_indicator"]];
    ivIndicator.frame = CGRectMake(kPadding, (self.frame.size.height - ivIndicator.frame.size.height)/2, ivIndicator.frame.size.width, ivIndicator.frame.size.height);
    if(isFolded){
        ivIndicator.transform = CGAffineTransformIdentity;
    }else{
        ivIndicator.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    ivIndicator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:ivIndicator];
    
    UIImage *typeImage = nil;
    if(isPrivate){
        typeImage = [UIImage imageNamed:@"address_type_private"];
    }else{
        typeImage = [UIImage imageNamed:@"address_type_watchonly"];
    }
    UIImageView *ivType = [[UIImageView alloc]initWithImage:typeImage];
    ivType.frame = CGRectMake(self.frame.size.width - ivType.frame.size.width - kPadding, (self.frame.size.height - ivType.frame.size.height)/2, ivType.frame.size.width, ivType.frame.size.height);
    ivType.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:ivType];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(ivIndicator.frame) + kMargin, 0, self.frame.size.width - ivIndicator.frame.size.width - ivType.frame.size.width - kMargin * 2, self.frame.size.height)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:kFontSize];
    lbl.textColor = [UIColor parseColor:kTextColor];
    lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if(isPrivate){
        lbl.text = NSLocalizedString(@"Hot Wallet Address", nil);
    }else{
        lbl.text = NSLocalizedString(@"Cold Wallet Address", nil);
    }
    [self addSubview:lbl];
}

-(void)pressed:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderPressed:)]){
        [self.delegate sectionHeaderPressed:_section];
    }
}

@end
