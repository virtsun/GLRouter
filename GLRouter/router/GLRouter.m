//
//  GLRouter.m
//  GLRouter
//
//  Created by sunlantao on 2019/3/5.
//  Copyright © 2019 sunlantao. All rights reserved.
//

#import "GLRouter.h"

@interface GLRouter(){
    NSHashTable *__hashRouter_;
}

@end

@implementation GLRouter

+ (instancetype)sharedRouter{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
    
}

- (id)init{
    
    if (self = [super init]){
        __hashRouter_ = [NSHashTable hashTableWithOptions:NSMapTableWeakMemory];
    }
    
    return self;
}

- (void)perform:(id<GLViewRoutable>)router completion:(void (^ __nullable)(void))completion{
    NSAssert(([router conformsToProtocol:@protocol(GLViewRoutable)]), @"source class is not a class of PTRoutable");
    
    __unused id scheme = [router schemeURL];
    GLRouterMode mode = [router routerMode];
    id sourceView = [router sourceView];
    
    switch (mode) {
            case kkGLRouterModePush:
            [[self navigationController] pushViewController:(UIViewController *)sourceView animated:YES];
            break;
            case kkGLRouterModePresent:
            [[self viewController] presentViewController:(UIViewController *)sourceView animated:YES completion:completion];
            break;
            case kkGLRouterModeShowOnKeywindow:
            break;
            case kkGLRouterModeShowOnTopView:
            break;
            
        default:
            break;
    }
    
    if (mode != kkGLRouterModePresent && completion){
        completion();
    }
    
    [self->__hashRouter_ addObject:router];
}
- (void)remove:(id<GLViewRoutable>)router completion:(void (^ __nullable)(void))completion{
    NSAssert(([router conformsToProtocol:@protocol(GLViewRoutable)]), @"source class is not a class of PTRoutable");
    GLRouterMode mode = [router routerMode];
    id sourceView = [router sourceView];
    
    switch (mode) {
            case kkGLRouterModePush:
            [((UIViewController *)sourceView).navigationController popViewControllerAnimated:YES]; break;
            case kkGLRouterModePresent:
            [((UIViewController *)sourceView) dismissViewControllerAnimated:YES completion:completion]; break;
            case kkGLRouterModeShowOnKeywindow:
            break;
            case kkGLRouterModeShowOnTopView:
            break;
            
        default:
            break;
    }
    if (mode != kkGLRouterModePresent && completion){
        completion();
    }
}

@end


@implementation GLRouter(Navigation)

- (UIViewController *)viewController{
    
    UIResponder *next = [self->__hashRouter_.allObjects lastObject];

    if (!next){
        UIViewController *rootVC = (UIViewController *)[self.rootRouter sourceView];

        if ([self.rootRouter isKindOfClass:[UITabBarController class]]){
            UITabBarController *tabBarVC = (UITabBarController *)rootVC;
            UIViewController *vc = [tabBarVC selectedViewController];
            if ([vc isKindOfClass:[UINavigationController class]]){
                return ((UINavigationController *)vc).topViewController;
            }else{
                return vc;
            }
        }else if ([self.rootRouter isKindOfClass:[UINavigationController class]]){
            return ((UINavigationController *)rootVC).topViewController;
        }else{
            return rootVC;
        }
    }
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)[((id<GLViewRoutable>)next) sourceView];;
        }
        
        next = next.nextResponder;
    } while (next);
    
    return nil;
}

- (UINavigationController *)navigationController{
    UIResponder *next = [self->__hashRouter_.allObjects lastObject];
    if (!next){
        UIViewController *rootVC = (UIViewController *)[self.rootRouter sourceView];

        if ([rootVC isKindOfClass:[UITabBarController class]]){
            UITabBarController *tabBarVC = (UITabBarController *)rootVC;
            UIViewController *vc = [tabBarVC selectedViewController];
            if ([vc isKindOfClass:[UINavigationController class]]){
                return (UINavigationController *)vc;
            }
        }else if ([rootVC isKindOfClass:[UINavigationController class]]){
            return ((UINavigationController *)rootVC);
        }
    }
    
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)[((id<GLViewRoutable>)next) sourceView];
        }
        
        next = next.nextResponder;
    } while (next);
    
    return nil;
}
@end

