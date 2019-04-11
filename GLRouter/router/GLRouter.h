//
//  GLRouter.h
//  GLRouter
//
//  Created by sunlantao on 2019/3/5.
//  Copyright © 2019 sunlantao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GLRoutable.h"

//! Project version number for GLRouter.
FOUNDATION_EXPORT double GLRouterVersionNumber;
//! Project version string for GLRouter.
FOUNDATION_EXPORT const unsigned char GLRouterVersionString[];

@interface GLRouter : NSObject

@property (nonatomic, strong, nullable) id<GLViewRoutable> rootRouter;

+ (instancetype)sharedRouter;

- (void)perform:(id<GLViewRoutable>)sourceView completion:(void (^ __nullable)(void))completion;
- (void)remove:(id<GLViewRoutable>)sourceView completion:(void (^ __nullable)(void))completion;

@end

@interface GLRouter(Navigation)

- (UINavigationController *)navigationController;
- (UIViewController *)viewController;

@end
