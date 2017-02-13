//
//  TileView.h
//  DragTiles
//
//  Created by yxhe on 16/5/26.
//  Copyright © 2016年 yxhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternModel.h"
@class TileButton;

@protocol TileButtonDelegate<NSObject>

@optional

- (void)tileButtonClicked:(TileButton *)tileBtn;

@end


@interface TileButton : UIButton

@property(nonatomic,strong)PatternModel *patternModel;
@property (nonatomic, assign) id<TileButtonDelegate> delegate;

@property (nonatomic, assign) NSInteger index; //index in the tile array


-(void)setDelButtonIcon:(NSString*)delIcon;

- (void)setTileText:(NSString *)text clickText:(NSString *)clickText; //set the tile text outside the class

- (void)tileLongPressed; //tile longpressed and begin to move, called outside

- (void)tileSuspended; //the tile touched pressed but not moved, called outside

- (void)tileSettled; //cancel press or settle the tile to new place, called outside

-(void)tileSettl;
@end
