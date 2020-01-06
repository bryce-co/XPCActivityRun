@class _DASDaemon;

@interface _DASDaemonClient: NSObject

@property (nonatomic, strong, nonnull, readwrite) NSXPCConnection *connection;
@property (nonatomic, strong, nonnull, readwrite) _DASDaemon *daemon;

- (void)forceRunActivities:(nonnull NSArray<NSString *> *)activities;

@end
