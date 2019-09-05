ARCHS = armv7 armv7s arm64
TARGET=iphone:latest:7.1

include theos/makefiles/common.mk

TWEAK_NAME = phonemanager
phonemanager_FILES = Tweak.xm
phonemanager_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

TOOL_NAME = wmanager
wmanager_FILES = main.mm

include $(THEOS_MAKE_PATH)/tool.mk

after-install::
	install.exec "killall -9 SpringBoard"
