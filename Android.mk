LOCAL_PATH := $(call my-dir)
ifeq ($(TARGET_DEVICE),S685LN)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
