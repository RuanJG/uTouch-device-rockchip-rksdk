LOCAL_PATH := $(call my-dir)

# Use BUILD_PREBUILT instead of PRODUCT_COPY_FILES to bring in the NOTICE file.
include $(CLEAR_VARS)
LOCAL_PREBUILT_LIBS := libftfontUpdate.so
LOCAL_MODULE_TAGS := eng
include $(BUILD_MULTI_PREBUILT)


