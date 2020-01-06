#import <objc/runtime.h>
#import "_DASDaemon.h"
#import "_DASDaemonClient.h"
#import "NSXPCConnection+Internal.h"
#import "XPCActivityRunError.h"

%hook _DASDaemonInterface

+ (void)startDASDaemon {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bundleDidLoadNotification:) name:NSBundleDidLoadNotification object:nil];

    %orig;
}

%new
+ (void)bundleDidLoadNotification:(NSNotification*)notification {
    NSArray* loadedClasses = [notification.userInfo objectForKey:NSLoadedClasses];
    if ([loadedClasses containsObject:@"_DASDaemonClient"]) {
        Class targetClass = NSClassFromString(@"_DASDaemonClient");
        SEL newSelector = @selector(forceRunActivities:completion:);
        Method newMethod = class_getInstanceMethod(self, newSelector);

        class_addMethod(targetClass,
            newSelector,
            method_getImplementation(newMethod),
            method_getTypeEncoding(newMethod));
    }
}

%new
- (void)forceRunActivities:(NSArray *)activities completion:(void (^)(NSError *))completion {
    // The expectation is that this method is actually called on an instance
    // of `_DASDaemonClient` (enabled via the call to `class_addMethod`
    // in +[_DASDaemonInterface bundleDidLoadNotification:]
    if (![(_DASDaemonClient *)self isKindOfClass:NSClassFromString(@"_DASDaemonClient")]) {
        %log(@"`forceRunActivities:completion:` called on a non-DASDaemonClient class");
        NSError *error = [NSError errorWithDomain:XPCActivityRunErrorDomain
                                             code:XPCActivityRunErrorCodeInternalTypeError
                                         userInfo:nil];
        completion(error);
        return;
    }

    _DASDaemonClient *daemonClient = (_DASDaemonClient *)self;

    // Check calling process' entitlements
    if (![[[daemonClient connection] valueForEntitlement:@"com.apple.duet.activityscheduler.allow"] boolValue]) {
        %log(@"`forceRunActivities:completion:` called by process without \"com.apple.duet.activityscheduler.allow\" entitlement");
        NSError *error = [NSError errorWithDomain:XPCActivityRunErrorDomain
                                             code:XPCActivityRunErrorCodeMissingEntitlements
                                         userInfo:nil];
        completion(error);
        return;
    }

    // Check all given activies to make sure they exist
    for (NSString *activityName in activities) {
       if ([daemonClient.daemon getActivityWithName:activityName] == nil) {
            NSString *logMessage = [NSString stringWithFormat:@"`forceRunActivities:completion:` encountered unknown activity with name \"%@\"", activityName];
            %log(logMessage);
            NSError *error = [NSError errorWithDomain:XPCActivityRunErrorDomain
                                                 code:XPCActivityRunErrorCodeNoActivityWithName
                                             userInfo:@{@"activityName": activityName}];
            completion(error);
            return;
       }
    }

    // Run all activities
    [daemonClient forceRunActivities:activities];
    completion(nil);
}

%end
