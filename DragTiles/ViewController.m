//
//  ViewController.m
//  DragTiles
//
//  Created by yxhe on 16/5/26.
//  Copyright © 2016年 yxhe. All rights reserved.
//

#import "ViewController.h"
#import "TileButton.h"
#import "PatternView.h"
//conditional build to switch on two animations
//#define ALIPAY_ANIMATION


//const NSInteger tile_space = 5; //the space between tiles
//
//const NSInteger tile_in_line = 4; //the inital max tile number in one line
//
////define the enum of tilte state
//enum TouchState
//{
//    UNTOUCHED,
//    SUSPEND,
//    MOVE
//};

@interface ViewController ()<TileButtonDelegate,PatternViewDelegate>
//{
//    //the __block prefix can make it accessed in the block
//    __block CGPoint startPos; //the touch point
//    __block CGPoint originPos; //the tile original point
//    
//    enum TouchState touchState; //the tile touch state
//    NSInteger currentTileCount; //the tile count up to now
//    
//    NSInteger preTouchID; //the button ID pretouched
//   
//}
//
//@property (nonatomic, strong) NSMutableArray *tileArray; //the titles array
//@property (nonatomic, strong) UIScrollView *scrollview; //the scrollview
//@property(nonatomic,strong)NSMutableArray *titleStringArray;
@property(nonatomic,strong)PatternView *patternView;
@end

@implementation ViewController



- (IBAction)begin:(id)sender {
    if (!self.patternView.isEdit) {
        [self.patternView  beginEdit];
    }else
    {
        [self.patternView closeEdit];
    }
}

- (void)viewDidLoad
{
    self.patternView = [PatternView new];
    self.patternView.patternDelegate = self;
    NSMutableArray *array = @[].mutableCopy;
    for (NSInteger i = 0; i<100; i++) {
        PatternModel *patternModel = [PatternModel new];
        patternModel.title = [NSString stringWithFormat:@"%ld",i];
        patternModel.backColor = [UIColor blueColor];
        patternModel.iconImage = @"allkpis";
        patternModel.closeImage = @"guanbi";
        [array addObject:patternModel];
    }
    
    self.patternView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-100);
    self.patternView.patternDataArray = array;
    self.patternView.isCanEdit = YES;
    self.patternView.isCanMove = YES;
    self.patternView.tile_height = @(100);
    self.patternView.tile_in_line = @(3);
    self.patternView.both_space = @(0);
    self.patternView.tile_space = @(1);
    [self.view addSubview:self.patternView];
    
    [self.patternView reloadate];
    
}
///开始编辑了
-(void)patternViewBeginEdit:(PatternView*)patternView
{
    
}
///结束编辑了
-(void)patternViewEndEdit:(PatternView*)patternView
{
    
}
//删除后返回处理顺序
-(void)patternView:(PatternView*)patternView removeList:(NSArray*)patternDataArray
{
    
}
///移动后后返回处理后的顺序
-(void)patternView:(PatternView*)patternView changedList:(NSArray*)patternDataArray
{
    
}
@end
