#import <Foundation/Foundation.h>
#import "DASActivityOmnibusSchedulingAdditions.h"
#import "NSXPCInterface.h"
#import "XPCActivityRunError.h"

int main(int argc, char *argv[], char *envp[]) {
    NSArray<NSString *> *arguments = [[NSProcessInfo processInfo] arguments];

    if (arguments.count <= 1
        || [arguments containsObject:@"-h"]
        || [arguments containsObject:@"--help"]) {
        fprintf(stdout, "Usage: xpc-activity-run [activity name 1] [activity name 2] [...]\n");
        exit(0);
    }         

    NSXPCConnection *xpcConnection = [[NSXPCConnection alloc] initWithMachServiceName:@"com.apple.duetactivityscheduler" options:0];
    xpcConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(DASActivityOmnibusSchedulingAdditions)];
    [xpcConnection resume];

    id<DASActivityOmnibusSchedulingAdditions> scheduler = [xpcConnection remoteObjectProxyWithErrorHandler:^(NSError *error) {
        fprintf(stderr, "XPC Error: %s\n", [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
        exit(1);
    }];

    NSArray<NSString *> *activityNames = [arguments subarrayWithRange:NSMakeRange(1, arguments.count - 1)];
    [scheduler forceRunActivities:activityNames completion:^(NSError *error) {
        if (error) {
            NSString *errorDescription = nil;
            if ([error.domain isEqualToString:XPCActivityRunErrorDomain]) {
                switch (error.code) {
                    case XPCActivityRunErrorCodeInternalTypeError:
                        errorDescription = @"Encountered unexpected type error in `dasd` tweak. This is a bug.";
                        break;
                    case XPCActivityRunErrorCodeMissingEntitlements:
                        errorDescription = @"xpc-activity-run is missing \"com.apple.duet.activityscheduler.allow\" entitlement. Add it with ldid or jtool2.";
                        break;
                    case XPCActivityRunErrorCodeNoActivityWithName:
                        errorDescription = [NSString stringWithFormat:@"Could not find activity with name \"%@\"",
                                                     error.userInfo[@"activityName"] ?: @"(unknown name)"];
                        break;
                }
            }

            if (errorDescription) {
                fprintf(stderr, "Error: %s\n", [errorDescription cStringUsingEncoding:NSUTF8StringEncoding]);
            } else {
                fprintf(stderr, "Unknown Error: %s\n", [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
            }

            exit(1);
        }

        exit(0);
    }];

    CFRunLoopRun();
}
