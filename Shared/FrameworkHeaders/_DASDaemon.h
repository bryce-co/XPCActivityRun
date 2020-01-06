@class _DASActivity;

@interface _DASDaemon: NSObject

- (void)forceRunActivities:(nonnull NSArray<NSString *> *)activities;
- (nullable _DASActivity *)getActivityWithName:(nonnull NSString *)name;

@end
