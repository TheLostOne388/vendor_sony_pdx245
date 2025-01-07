LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := odm_files
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := sony

ODM_COPY_FILES := \
    $(LOCAL_PATH)/etc/build.prop:$(TARGET_COPY_OUT_ODM)/etc/build.prop \
    $(LOCAL_PATH)/etc/fs_config_dirs:$(TARGET_COPY_OUT_ODM)/etc/fs_config_dirs \
    $(LOCAL_PATH)/etc/fs_config_files:$(TARGET_COPY_OUT_ODM)/etc/fs_config_files \
    $(LOCAL_PATH)/etc/group:$(TARGET_COPY_OUT_ODM)/etc/group \
    $(LOCAL_PATH)/etc/NOTICE.xml.gz:$(TARGET_COPY_OUT_ODM)/etc/NOTICE.xml.gz \
    $(LOCAL_PATH)/etc/passwd:$(TARGET_COPY_OUT_ODM)/etc/passwd \
    $(LOCAL_PATH)/etc/ueventd.rc:$(TARGET_COPY_OUT_ODM)/etc/ueventd.rc \
    $(LOCAL_PATH)/etc/ueventd.somc-platform.rc:$(TARGET_COPY_OUT_ODM)/etc/ueventd.somc-platform.rc

# SELinux files
ODM_COPY_FILES += \
    $(LOCAL_PATH)/etc/selinux/odm_file_contexts:$(TARGET_COPY_OUT_ODM)/etc/selinux/odm_file_contexts \
    $(LOCAL_PATH)/etc/selinux/odm_hwservice_contexts:$(TARGET_COPY_OUT_ODM)/etc/selinux/odm_hwservice_contexts \
    $(LOCAL_PATH)/etc/selinux/odm_mac_permissions.xml:$(TARGET_COPY_OUT_ODM)/etc/selinux/odm_mac_permissions.xml \
    $(LOCAL_PATH)/etc/selinux/odm_property_contexts:$(TARGET_COPY_OUT_ODM)/etc/selinux/odm_property_contexts \
    $(LOCAL_PATH)/etc/selinux/odm_seapp_contexts:$(TARGET_COPY_OUT_ODM)/etc/selinux/odm_seapp_contexts \
    $(LOCAL_PATH)/etc/selinux/odm_sepolicy.cil:$(TARGET_COPY_OUT_ODM)/etc/selinux/odm_sepolicy.cil \
    $(LOCAL_PATH)/etc/selinux/odm_service_contexts:$(TARGET_COPY_OUT_ODM)/etc/selinux/odm_service_contexts \
    $(LOCAL_PATH)/etc/selinux/precompiled_sepolicy:$(TARGET_COPY_OUT_ODM)/etc/selinux/precompiled_sepolicy

LOCAL_PREBUILT_MODULE_FILE := $(ODM_COPY_FILES)

include $(BUILD_PREBUILT)