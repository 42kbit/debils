
include $(BSE_PROFILE_DIR)/$(BS_PROFILE).mk

# VARIABLES AND DEFINES
# CFLAGS

CF_ALL	:=-Wall -Wextra
ASF_ALL	:=-Wall -Wextra

OPTLVL	?=-O2

ifeq ($(DEBUG),n)
CF_ALL	+=$(OPTLVL)
ASF_ALL	+=
else
CF_ALL	+=$(OPTLVL) -g
ASF_ALL	+=$(OPTLVL) -g
endif

# LINK FLAGS
LF_ALL	:=