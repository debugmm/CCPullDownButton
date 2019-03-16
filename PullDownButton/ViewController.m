//
//  ViewController.m
//  PullDownButton
//
//  Created by wujungao on 2019/3/16.
//  Copyright © 2019 com.wujungao. All rights reserved.
//

#import "ViewController.h"

#import "CCPullDownButton.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self initConfigCCPullDownButton];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark -
-(void)initConfigCCPullDownButton{
    
    CCPullDownButton *btn=[CCPullDownButton new];
    
    NSDictionary *dict=@{NSFontAttributeName:[NSFont systemFontOfSize:12],
                         NSForegroundColorAttributeName:[NSColor blueColor]
                         };
    
    [btn setAttributedTitle:[[NSAttributedString alloc] initWithString:@"item-0" attributes:dict]];
    [btn setImage:[NSImage imageNamed:@"test_icon"]];
    [btn setImagePosition:NSImageRight];
    btn.frame=NSMakeRect(100, 100, 100, 15);
    [btn setBordered:NO];
    
    [self.view addSubview:btn];
}


@end
