//
//  PatternModel.h
//  DragTiles
//
//  Created by 周杰 on 2017/2/13.
//  Copyright © 2017年 yxhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PatternModel : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)UIColor *backColor;
@property(nonatomic,strong)NSString *closeImage;
@property(nonatomic,strong)NSString *iconImage;

@property(nonatomic,strong)NSString *placeImage;
@property(nonatomic,strong)UIFont *font;
@property(nonatomic,strong)UIColor *textColor;

@property(nonatomic,strong)id other;
@end
