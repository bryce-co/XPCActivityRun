extern NSString *const XPCActivityRunErrorDomain;

typedef NS_ENUM(int, XPCActivityRunErrorCode) {
    XPCActivityRunErrorCodeInternalTypeError   = 1000,
    XPCActivityRunErrorCodeMissingEntitlements = 1001,
    XPCActivityRunErrorCodeNoActivityWithName  = 1002
};
