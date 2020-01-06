include $(THEOS)/makefiles/common.mk

SUBPROJECTS = CommandLine Tweak
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 dasd"
