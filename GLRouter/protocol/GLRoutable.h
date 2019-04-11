//
//  PTRoutable.h
//  GLRouter
//
//  Created by sunlantao on 2019/2/26.
//  Copyright © 2019 sunlantao. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GLRouterMode){
    kkGLRouterModeRoot,
    kkGLRouterModePresent,
    kkGLRouterModePush,
    kkGLRouterModeShowOnKeywindow,
    kkGLRouterModeShowOnTopView
};

@protocol GLRoutable <NSObject>

@end

@protocol GLViewRoutable <GLRoutable>

@required
- (NSString *)schemeURL;
- (GLRouterMode)routerMode;
- (id)sourceView;//view or viewcontroller;

@end
