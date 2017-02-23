//
//  PatternView.m
//  DragTiles
//
//  Created by 周杰 on 2017/2/13.
//  Copyright © 2017年 yxhe. All rights reserved.
//

#import "PatternView.h"
#import "TileButton.h"
#import "UIButton+WebCache.h"
#define ALIPAY_ANIMATION


 CGFloat tile_space = 1; //the space between tiles

 NSInteger tile_in_line = 3; //the inital max tile number in one line

CGFloat both_space = 0;
CGFloat top_bottom_space = 0;
//define the enum of tilte state


@interface PatternView ()<TileButtonDelegate>
{
    //the __block prefix can make it accessed in the block
    __block CGPoint startPos; //the touch point
    __block CGPoint originPos; //the tile original point
    
//    enum TouchState touchState; //the tile touch state
    NSInteger currentTileCount; //the tile count up to now
    
    NSInteger preTouchID; //the button ID pretouched
    
}
@property (nonatomic, strong) NSMutableArray *tileArray; //the titles array
@property(nonatomic,strong)NSMutableArray *titleModelArray;
@property(nonatomic,assign)enum TouchState touchState;
@end

@implementation PatternView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews
{
    [super layoutSubviews];
//    [self reloadate];
}
-(BOOL)isEdit
{
    if (self.touchState == MOVE || self.touchState == SUSPEND) {
        return YES;
    }else
    {
        return NO;
    }
}
-(void)setPatternDataArray:(NSArray *)patternDataArray
{
    _patternDataArray = patternDataArray;
    self.titleModelArray = _patternDataArray.mutableCopy;
}
-(NSMutableArray*)tileArray
{
    if (_tileArray == nil) {
        _tileArray = @[].mutableCopy;
    }
    return _tileArray;
}
-(void)reloaDate
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self.tileArray removeAllObjects];
    
    currentTileCount = 0;
    if (self.tile_space) {
        tile_space = [self.tile_space floatValue];
    }
    if (self.tile_in_line) {
        tile_in_line = [self.tile_in_line integerValue];
    }
    if (self.both_space) {
        both_space = [self.both_space floatValue];
    }
    if (self.top_bottom_space) {
        top_bottom_space = [self.top_bottom_space floatValue];
    }
    
    for (PatternModel *patternModel in self.patternDataArray) {
        
        CGFloat tileSize = (self.frame.size.width - both_space*2 - tile_space * (tile_in_line-1)) / tile_in_line;
        
        //add the tiles
        NSInteger xID = currentTileCount % tile_in_line; //tile id of column
        NSInteger yID = currentTileCount / tile_in_line; //tile id of row
        
        CGFloat tileHeight = self.tile_height?[self.tile_height floatValue]:tileSize;
        
        TileButton *tile = [[TileButton alloc] initWithFrame:CGRectMake( xID * (tile_space + tileSize) + both_space,
                                                                         yID * (tile_space + tileHeight) + top_bottom_space,
                                                                        tileSize, tileHeight)];
        tile.patternModel = patternModel;
        [tile setImage:[UIImage imageNamed:patternModel.placeImage] forState:UIControlStateNormal];
        if ([patternModel.iconImage hasPrefix:@"http"]) {
            [tile sd_setImageWithURL:[NSURL URLWithString:patternModel.iconImage] forState:UIControlStateNormal];
        }else
        {
            [tile setImage:[UIImage imageNamed:patternModel.iconImage] forState:UIControlStateNormal];
        }
        tile.backgroundColor = patternModel.backColor;
        tile.titleLabel.font = patternModel.font;
        tile.titleLabel.textColor = patternModel.textColor;
        
         [tile setTileText:patternModel.title clickText:nil];
        [tile addTarget:self action:@selector(tileClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tile setDelButtonIcon:patternModel.closeImage];
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] init];
         longGesture.minimumPressDuration = 0.5;
        [longGesture addTarget:self action:@selector(onLongGresture:)];
        [tile addGestureRecognizer:longGesture];
        
        
//        UIPanGestureRecognizer *pangestureRecognizer = [[UIPanGestureRecognizer alloc] init];
//        [pangestureRecognizer addTarget:self action:@selector(pangesture:)];
//        [tile addGestureRecognizer:pangestureRecognizer];
        
        //add the Click event
        [tile addTarget:self action:@selector(tileClicked:) forControlEvents:UIControlEventTouchUpInside];
        tile.delegate = self; //make the main view can respond to the deletebutton
        
        [self addSubview:tile];
        
        [self.tileArray addObject:tile]; //add tile to array
        
        tile.index = currentTileCount; //set the tile index in the array
        //set the button text
        currentTileCount++; //increase the tile count
        if(tile.frame.origin.y + tileHeight > self.frame.size.height)
        {
            self.contentSize = CGSizeMake(self.contentSize.width, tile.frame.origin.y + tileHeight + top_bottom_space);
            
        }else
        {
            self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        }
    }
    
    //make the scroll view contain the tile
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
 {
         if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
         {
             if (self.isEdit == NO) {
                 return YES;
             }else
             {
                 return NO;
             }
        }
         else
         {
            return  NO;
        }

 }

#pragma mark - gesture callbacks

- (void)onLongGresture:(UILongPressGestureRecognizer *)sender
{
    [self handleSequenceMove:sender];

}
//-(void)pangesture:(UIPanGestureRecognizer*)panGesture
//{
//    if ( touchState == SUSPEND ||  touchState == MOVE) {
//        [self handleSequenceMove:panGesture];
//    }
//}
-(void)beginEdit
{
    for (TileButton *titleButton in self.tileArray) {
        
        [titleButton tileSuspended];
    }
    self.touchState = SUSPEND;

}///开始编辑
//method 2: move the tiles inorder like Alipay, the order in array remains in sequence always
- (void)handleSequenceMove:(UIGestureRecognizer *)sender
{
    if (self.isCanEdit == NO) {
        return;
    }
    
    TileButton *tile_btn = (TileButton*)sender.view; //get the dragged tilebutton
    switch(sender.state)
    {
            case UIGestureRecognizerStateBegan:
            startPos = [sender locationInView:sender.view];
            originPos = tile_btn.center;
            for (TileButton *titleButton in self.tileArray) {
                
                [titleButton tileSuspended];
            }
            if (self.touchState == UNTOUCHED) {
                self.touchState = SUSPEND;
            }
            [self bringSubviewToFront:tile_btn];
            preTouchID = tile_btn.index; //save the ID of pretouched title
            [tile_btn tileLongPressed];
            break;
            case UIGestureRecognizerStateChanged:
        {
            if (NO == self.isCanMove) {
                return;
            }
            [tile_btn tileLongPressed];
            self.touchState = MOVE; //the tile will move
            CGPoint newPoint = [sender locationInView:sender.view];
            CGFloat offsetX = newPoint.x - startPos.x;
            CGFloat offsetY = newPoint.y - startPos.y;
            
            tile_btn.center = CGPointMake(tile_btn.center.x + offsetX, tile_btn.center.y + offsetY);
            
            //get the intersect tile ID
            NSInteger intersectID = -1;
            for(NSInteger i = 0; i < _tileArray.count; i++)
            if(tile_btn != _tileArray[i] && CGRectContainsPoint([_tileArray[i] frame], tile_btn.center))
            {
                intersectID = i;
                break;
            }
            
            if(intersectID != -1)
            {
                if(labs(intersectID - tile_btn.index) == 1) //if the tiles are adjacent then move directly
                {
                    __block TileButton *collisionButton = _tileArray[intersectID];
                    __block CGPoint tempOriginPos = collisionButton.center; //the new origin point
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        collisionButton.center = originPos; //move the other title to the moved tile's origin pos
                        originPos = tempOriginPos; //save the temp origin point in case the block shake
                        
                    }];
                    
                    //exchange the tile index of the array
                    [_tileArray exchangeObjectAtIndex:tile_btn.index withObjectAtIndex:intersectID];
                    //tile_btn still point to the moving tile, just swap the index
                    NSInteger tempID = collisionButton.index;
                    collisionButton.index = tile_btn.index;
                    tile_btn.index = tempID;
                    
                    
                    //                    NSLog(@"tilebtn index:%d, intersect index:%d", [_tileArray[tile_btn.index] index], [_tileArray[collisionButton.index] index]);
                    
                }
                else if(intersectID - tile_btn.index >1) //move the tiles to the left in order
                {
                    CGPoint preCenter = originPos;
                    CGPoint curCenter;
                    //exchange the pointer in array and swap the index,at last the tile_btn is at the new right place
                    for(NSInteger i = tile_btn.index + 1; i <= intersectID; i++)
                    {
                        __block TileButton *movedTileBtn = _tileArray[i];
                        
                        curCenter = movedTileBtn.center;
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            movedTileBtn.center = preCenter;
                        }];
                        preCenter = curCenter; //save the precenter
                        
                        movedTileBtn.index--; //reduce the tile index
                        _tileArray[i-1] = movedTileBtn; //move the pointer one by one
                        
                        
                    }
                    originPos = preCenter;
                    tile_btn.index = intersectID; //exchange the ID
                    _tileArray[intersectID] = tile_btn; //now make the last pointer point to the tile_btn
                    //                    NSLog(@"new tile btn index: %d", [_tileArray[tile_btn.index] index]);
                }
                else //move the tile to right in order
                {
                    CGPoint preCenter = originPos;
                    CGPoint curCenter;
                    //exchange the pointer in array and swap the index,at last the tile_btn is at the new right place
                    for(NSInteger i = tile_btn.index - 1; i >= intersectID; i--)
                    {
                        __block TileButton *movedTileBtn = _tileArray[i];
                        curCenter = movedTileBtn.center;
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            movedTileBtn.center = preCenter;
                        }];
                        preCenter = curCenter; //save the precenter
                        
                        movedTileBtn.index++; //reduce the tile index
                        _tileArray[i+1] = movedTileBtn; //move the pointer one by one
                        
                    }
                    originPos = preCenter;
                    tile_btn.index = intersectID; //exchange the ID
                    _tileArray[intersectID] = tile_btn; //now make the last pointer point to the tile_btn
                    //                    NSLog(@"new tile btn index: %d", [_tileArray[tile_btn.index] index]);
                }
                
                
                //test the display if the array is inorder
             
                
            }
            
        }
            break;
            case UIGestureRecognizerStateEnded:
        {
            //   [tile_btn tileSuspended];
            [UIView animateWithDuration:0.3 animations:^{
                tile_btn.center = originPos;
            }];
            if(self.touchState == MOVE) //only if the pre state is MOVE, then settle, otherwise leave it suspend
            {
                if (self.patternDelegate && [_patternDelegate respondsToSelector:@selector(patternView:changedList:)]) {
                    [self.patternDelegate patternView:self changedList:[self changedList] ];
                }
                _touchState = SUSPEND;
            }
            [tile_btn tileSettl]; //settle the tile to the new position(no need to use delay operation here)
            
        }
            
            break;
        default:
            break;
    }
    
}

-(NSArray*)nowPatternDataArray
{
    return [self changedList];
}
-(NSArray*)changedList
{
    NSMutableArray *patternArray = @[].mutableCopy;
    for (TileButton *titleButton in self.tileArray) {
        [patternArray addObject:titleButton.patternModel];
    }
    return patternArray;
}
#pragma mark - button callbacks
- (void)tileClicked:(TileButton *)button
{
    
    if(self.touchState == SUSPEND || self.touchState == MOVE)
    {
//        for (TileButton *tileButton in self.tileArray) {
//            [tileButton tileSettled];
//        }
//        self.touchState = UNTOUCHED;
    }
    else if(self.touchState == UNTOUCHED)
    {
        if (_patternDelegate && [_patternDelegate respondsToSelector:@selector(patternView:clickIndex:patternModel:)]) {
            [_patternDelegate patternView:self clickIndex:button.index patternModel:button.patternModel];
        }
     
    }
    
}
-(void)closeEdit///关闭编辑
{
    if(self.touchState == SUSPEND || self.touchState == MOVE)
    {
        for (TileButton *tileButton in self.tileArray) {
            [tileButton tileSettled];
        }
        self.touchState = UNTOUCHED;
        NSLog(@"suspend canceld");
    }
}
-(void)setTouchState:(enum TouchState)touchState
{
    _touchState = touchState;
    if (_touchState == SUSPEND) {
        if (_patternDelegate && [_patternDelegate respondsToSelector:@selector(patternViewBeginEdit:)]) {
            [_patternDelegate patternViewBeginEdit:self];
        }
    }else if(_touchState == UNTOUCHED)
    {
        if (_patternDelegate && [_patternDelegate respondsToSelector:@selector(patternViewEndEdit:)]) {
            [_patternDelegate patternViewEndEdit:self];
        }
    }
}
//tile delete button clicked
- (void)tileButtonClicked:(TileButton *)tileBtn
{
    //remove the button and adjust the tilearray
    
    
    //remember the deleted tile's infomation
    NSInteger startIndex = tileBtn.index;
    CGPoint preCenter = tileBtn.center;
    CGPoint curCenter;
    
    //[_tileArray removeObject:tileBtn]; //delete the tile
    //exchange the pointer in array and swap the index,at last the tile_btn is at the new right place
    for(NSInteger i = startIndex + 1; i < _tileArray.count; i++)
    {
        __block TileButton *movedTileBtn = _tileArray[i];
        curCenter = movedTileBtn.center;
        
        [UIView animateWithDuration:0.3 animations:^{
            movedTileBtn.center = preCenter;
        }];
        preCenter = curCenter; //save the precenter
        
        movedTileBtn.index--; //reduce the tile index
        _tileArray[i-1] = movedTileBtn; //move the pointer one by one
        
    }
    
    [_tileArray removeLastObject]; //every time remove the last object
    
    //must remove the tileBtn from the view
    [tileBtn removeFromSuperview]; //we can also use performselector so that button disappears with animation
    //test the display if the array is inorder

    if (self.patternDelegate && [_patternDelegate respondsToSelector:@selector(patternView:removeList:)]) {
        [self.patternDelegate patternView:self removeList:[self changedList] ];
    }
    
}

@end
