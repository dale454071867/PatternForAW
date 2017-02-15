//
//  PatternView.h
//  DragTiles
//
//  Created by 周杰 on 2017/2/13.
//  Copyright © 2017年 yxhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternModel.h"
///没做重用别太多会卡

enum TouchState
{
    UNTOUCHED,
    SUSPEND,
    MOVE
};

@protocol PatternViewDelegate;
@interface PatternView : UIScrollView
@property(nonatomic,assign,readonly) BOOL isEdit;//是否在编辑状态
@property(nonatomic,assign)BOOL isCanEdit;///是否可以编辑
@property(nonatomic,assign)BOOL isCanMove;///是否可以拖动,允许拖动需要允许编辑
@property(nonatomic,strong)NSArray *patternDataArray;///用作初始化的数组,以PatternModel初始化
@property(nonatomic,strong)NSNumber *tile_in_line;///一行多少个,默认3个
@property(nonatomic,strong)NSNumber *tile_space;///间隙多少，默认1
@property(nonatomic,strong)NSNumber *both_space;//两边的间隙，默认0
@property(nonatomic,strong)NSNumber *top_bottom_space;//上下两端的距离，默认0
@property(nonatomic,strong)NSNumber *tile_height;//每个的高度，默认正方形
@property(nonatomic,strong,readonly) NSArray *nowPatternDataArray;///现在的数组
@property(nonatomic,assign)id<PatternViewDelegate> patternDelegate;
-(void)closeEdit;///关闭编辑
-(void)beginEdit;///开始编辑
-(void)reloadate;///刷新
@end

@protocol PatternViewDelegate <NSObject>
///点击cell的时候
-(void)patternView:(PatternView*)patternView clickIndex:(NSInteger)index patternModel:(PatternModel*)patternModel;
///移动后或删除后返回处理后的顺序
-(void)patternView:(PatternView*)patternView changedList:(NSArray*)patternDataArray;
///开始编辑了
-(void)patternViewBeginEdit:(PatternView*)patternView;
///结束编辑了
-(void)patternViewEndEdit:(PatternView*)patternView;
@end
