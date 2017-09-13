ARCHS = armv7 armv7s arm64
TARGET=iphone:latest:10.3

ADDITIONAL_OBJCFLAGS = -fobjc-arc
	
include theos/makefiles/common.mk

TWEAK_NAME = wechatscraper
wechatscraper_FILES = Tweak.xm
wechatscraper_FRAMEWORKS = UIKit WebKit CoreGraphics Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
