include $(THEOS)/makefiles/common.mk

TWEAK_NAME = xpcactivityruntweak
xpcactivityruntweak_CFLAGS = -fobjc-arc -I../Shared -I../Shared/FrameworkHeaders
xpcactivityruntweak_FILES = $(wildcard *.x) $(wildcard ../Shared/*.m)
include $(THEOS_MAKE_PATH)/tweak.mk
