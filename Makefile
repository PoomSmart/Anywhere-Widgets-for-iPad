PACKAGE_VERSION = 1.1

TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AnywhereWidgetsforiPad

AnywhereWidgetsforiPad_FILES = Tweak.x
AnywhereWidgetsforiPad_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
