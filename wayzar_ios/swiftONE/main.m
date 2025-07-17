//
//  main.m
//  iOSSample
//
//  Created by LiuGaoSheng on 2021/4/23.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UnityToiOSManger.h"

int main(int argc, char * argv[]) {
    printf("main");
    NSString * appDelegateClassName;
    [UnityToiOSManger sharedInstance].gArgc = argc;
    [UnityToiOSManger sharedInstance].gArgv = argv;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
