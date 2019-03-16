//
//  CCPullDownButton.m
//  NSTableView
//
//  Created by wujungao on 2019/3/16.
//  Copyright © 2019 com.wujungao. All rights reserved.
//

#import "CCPullDownButton.h"

#import <Masonry.h>

//CCTextField，用来演示MenuItem.view效果与使用方法
@protocol CCTextField <NSObject>

@optional
-(void)selectedItemIndex:(NSInteger)index value:(NSString *)value;

@end

@interface CCTextField : NSTextField

@property(nonatomic,weak)id<CCTextField> ccTextFieldDelegate;
@property(nonatomic,assign)BOOL selected;

@end

@interface CCTextField ()

@property(nonatomic,strong,nullable)NSTrackingArea *trackingArea;

@end

@implementation CCTextField

#pragma mark - life circle
-(instancetype)initWithFrame:(NSRect)frameRect{
    self=[super initWithFrame:frameRect];
    
    if(self){
        [self initConfig];
    }
    
    return self;
}

#pragma mark - init config
-(void)initConfig{
    
    self.font=[NSFont systemFontOfSize:12];
    self.textColor=[NSColor blueColor];
    self.backgroundColor=[NSColor clearColor];
    self.alignment=NSTextAlignmentCenter;
    self.editable=NO;
    self.selected=NO;
    self.selectable=YES;
    self.bordered=NO;
    
    self.trackingArea=[[NSTrackingArea alloc] initWithRect:self.frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow) owner:self userInfo:nil];
    
    [self addTrackingArea:self.trackingArea];
}

#pragma mark - override
-(void)mouseEntered:(NSEvent *)event{
    self.backgroundColor=[NSColor systemBlueColor];
}

-(void)mouseExited:(NSEvent *)event{
    self.backgroundColor=[NSColor clearColor];
}

-(void)mouseDown:(NSEvent *)event{
    self.textColor=[NSColor yellowColor];
    self.backgroundColor=[NSColor clearColor];
    
    if(!self.selected){
        self.selected=YES;
    }
    
    if(self.ccTextFieldDelegate &&
       [self.ccTextFieldDelegate respondsToSelector:@selector(selectedItemIndex:value:)]){
        
        [self.ccTextFieldDelegate selectedItemIndex:self.tag value:self.stringValue];
    }
}

#pragma mark -
-(void)updateTrackingAreas{
    
    [self removeTrackingArea:self.trackingArea];
    
    self.trackingArea=[[NSTrackingArea alloc] initWithRect:self.frame options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow) owner:self userInfo:nil];
    
    [self addTrackingArea:self.trackingArea];
}

@end

@interface CCPullDownButton ()<CCTextField>

/**
 @brief ccMenu用于显示menu在按钮底部（类似PopUpButton PullDown 效果）
 
 @discussion 系统默认提供了defaultMenu 和 Menu，但是它们都是用于鼠标右键左键等情况，同时也用于支持上下文的menu；
 为了不影响系统提供的功能，此处单独添加一个ccMenu，用来实现pull-down list效果；
 这个pull-down list选项值，是固定的，同时是排他性的选项值；
 适合用来改变当前环境或者规则
 */
@property(nonatomic,strong,nullable)NSMenu *ccMenu;

@end

@implementation CCPullDownButton

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//
//    // Drawing code here.
//}
#pragma mark - life circle
-(instancetype)initWithFrame:(NSRect)frameRect{
    self=[super initWithFrame:frameRect];
    if(self){
        [self initConfig];
    }
    
    return self;
}

#pragma mark - override
-(void)mouseDown:(NSEvent *)event{
    //将menu放置的位置固定在按钮左下角origin.x,origin.y-5位置处开始
    //效果相当于按钮远点处向下5个点开始
    
    //这其中最关键的事情就是：生成一个新的Event实例变量(newEvent)
    //newEvent与event最大的区别就是：location不同
    //因为menu的位置，是从这个location来计算的，如果这个location位置改变，menu将随着改变
    NSPoint point=self.frame.origin;
    
    point.x+=(self.frame.size.width-self.menuItemWidth)/2.0;
    point.y-=5;
    
    NSEvent *newEvent=[NSEvent mouseEventWithType:NSEventTypeOtherMouseUp location:point modifierFlags:event.modifierFlags timestamp:event.timestamp windowNumber:event.windowNumber context:[NSGraphicsContext currentContext] eventNumber:event.eventNumber clickCount:event.clickCount pressure:event.pressure];
    
    [NSMenu popUpContextMenu:self.ccMenu withEvent:newEvent forView:self];
}

#pragma mark - pub
-(void)addMenuItem:(nonnull NSMenuItem *)item{
    if(item==nil || item==NULL){
        return;
    }
    
    [self.ccMenu addItem:item];
}

#pragma mark - init config
-(void)initConfig{
    
    self.menuItemWidth=0;

    [self initConfigViews];
}

//initConfigViews方法用来结合CCTextField，演示用
-(void)initConfigViews{
    
    [self.ccMenu setAutoenablesItems:YES];
    
#ifdef DEBUG
    self.menuItemWidth=80;
    
    for (NSInteger i=0; i<10; i++) {
        
        NSString *str=[NSString stringWithFormat:@"item-%ld",i];
        
        CCTextField *mv=[CCTextField new];
        mv.frame=NSMakeRect(0, 0, 80, 20);//应该根据内容，实现宽高
        mv.tag=i;
        mv.ccTextFieldDelegate=self;
        mv.stringValue=str;
        if(i==0){
            mv.textColor=[NSColor yellowColor];
        }
        
        NSMenuItem *item=[[NSMenuItem alloc] initWithTitle:str action:NULL keyEquivalent:@""];
        item.tag=i;
        [item setView:mv];
        
        [self.ccMenu addItem:item];
    }
#endif
}

#ifdef DEBUG
#pragma mark - CCTextField
-(void)selectedItemIndex:(NSInteger)index value:(NSString *)value{
    
    NSDictionary *dict=@{NSFontAttributeName:[NSFont systemFontOfSize:12],
                         NSForegroundColorAttributeName:[NSColor blueColor]
                         };
    
    [self setAttributedTitle:[[NSAttributedString alloc] initWithString:value attributes:dict]];
    
    [self.ccMenu cancelTracking];
    
    [self.ccMenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CCTextField *ct=(CCTextField *)obj.view;
        if(index!=idx){
            ct.selected=NO;
            ct.textColor=[NSColor blueColor];
        }
    }];
}
#endif

#pragma mark - property
-(NSMenu *)ccMenu{
    if(!_ccMenu){
        _ccMenu=[[NSMenu alloc] initWithTitle:@"ccMenu"];
    }
    
    return _ccMenu;
}

@end
