################################################################################
#
# flycast
#
################################################################################
# Version: Commits on Dec 10, 2022
FLYCAST_VERSION = 223504a2065d55238ae232dfa92b33d98c223b4c
FLYCAST_SITE = https://github.com/flyinghead/flycast.git
FLYCAST_SITE_METHOD=git
FLYCAST_GIT_SUBMODULES=YES
FLYCAST_LICENSE = GPLv2
FLYCAST_DEPENDENCIES = sdl2 libpng libzip libcurl libao libminiupnpc

FLYCAST_CONF_OPTS += -DLIBRETRO=OFF

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_X86_64_ANY),y)
    FLYCAST_CONF_OPTS += -DUSE_OPENGL=ON
else ifeq ($(BR2_PACKAGE_BATOCERA_GLES3),y)
    FLYCAST_CONF_OPTS += -DUSE_GLES=ON -DUSE_GLES2=OFF -DUSE_OPENGL=ON
else ifeq ($(BR2_PACKAGE_BATOCERA_GLES2),y)
    FLYCAST_CONF_OPTS += -DUSE_GLES2=ON -DUSE_GLES=OFF -DUSE_OPENGL=ON
endif

ifeq ($(BR2_PACKAGE_BATOCERA_VULKAN),y)
    FLYCAST_CONF_OPTS += -DUSE_VULKAN=ON
else
    FLYCAST_CONF_OPTS += -DUSE_VULKAN=OFF
endif

# RPI: use the legacy Broadcom GLES libraries
ifeq ($(BR2_PACKAGE_BATOCERA_RPI_VCORE),y)
    FLYCAST_CONF_OPTS += -DUSE_VIDEOCORE=ON
endif

ifeq ($(BR2_PACKAGE_HAS_LIBMALI),y)
    FLYCAST_DEPENDENCIES += libmali
    FLYCAST_CONF_OPTS += -DUSE_MALI=ON
endif

ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RG552),y)
    FLYCAST_CONF_OPTS += -DRG552=ON
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_BCM2711),y)
    FLYCAST_CONF_OPTS += -DRPI4=ON
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_RK3326),y)
    FLYCAST_CONF_OPTS += -DRK3326=ON
else ifeq ($(BR2_PACKAGE_BATOCERA_TARGET_S922X),y)
    FLYCAST_CONF_OPTS += -DS922X=ON
endif

define FLYCAST_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/flycast $(TARGET_DIR)/usr/bin/flycast
	# evmapy files
	mkdir -p $(TARGET_DIR)/usr/share/evmapy
	cp $(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/emulators/flycast/*.keys $(TARGET_DIR)/usr/share/evmapy
endef

$(eval $(cmake-package))
