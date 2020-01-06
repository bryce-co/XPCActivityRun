include $(THEOS)/makefiles/common.mk

TOOL_NAME = xpcactivityrun
xpcactivityrun_CFLAGS = -fobjc-arc -I../Shared -I../Shared/FrameworkHeaders
xpcactivityrun_FILES = $(wildcard *.m) $(wildcard ../Shared/*.m)
include $(THEOS_MAKE_PATH)/tool.mk

internal-stage::
	mv $(THEOS_STAGING_DIR)/usr/bin/xpcactivityrun $(THEOS_STAGING_DIR)/usr/bin/xpc-activity-run
	ldid -Sentitlements.xml $(THEOS_STAGING_DIR)/usr/bin/xpc-activity-run
