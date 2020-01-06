@protocol DASActivityOmnibusSchedulingAdditions

- (void)forceRunActivities:(nonnull NSArray<NSString *> *)activities completion:(void (^ __nonnull)(NSError * __nullable))completion;

@end

