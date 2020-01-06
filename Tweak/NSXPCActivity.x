#import "DASActivityOmnibusSchedulingAdditions.h"

%hook NSXPCInterface

-(void)setProtocol:(Protocol *)originalProtocol {
    if (protocol_isEqual(originalProtocol, objc_getProtocol("_DASActivityOmnibusScheduling"))) {
        Protocol *modifiedProtocol = objc_getProtocol("_DASActivityOmnibusSchedulingModified");
        if (!modifiedProtocol) {
            %log(@"Did not find existing modified protocol, creating new one");
            modifiedProtocol = objc_allocateProtocol("_DASActivityOmnibusSchedulingModified");
            protocol_addProtocol(modifiedProtocol, originalProtocol);
            protocol_addProtocol(modifiedProtocol, @protocol(DASActivityOmnibusSchedulingAdditions));
            objc_registerProtocol(modifiedProtocol);
        } else {
            %log(@"Found existing modified protocol");
        }

        %orig(modifiedProtocol);
        return;
    }

    %orig;
}

%end
