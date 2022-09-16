# VARIABLES AND DEFINES
# CFLAGS
CF_ALL	:=-Wall
# LINK FLAGS
LF_ALL	:=

# every line with sources, has a mirror in $(DIR_OUT)
# so ant/main.c, will output at $(DIR_OUT)/ant/main.o

DIR_OUT	?=.out
DIR_OBJS :=$(DIR_OUT)/.objs
DIR_BIN	?=$(DIR_OUT)/bin
DIR_SBIN?=$(DIR_OUT)/sbin
DIR_LIB	?=$(DIR_OUT)/lib
DIR_ETC	?=$(DIR_OUT)/etc

# default C compiler
CC	?=gcc
# default UNIX install utility
INST	?=install
# $(CC) - compile C 
# $(CF_ALL) - generic C flags
# $(CF_$(patsubst %/,%,$(dir $<))) - C flags, specific for
# 					directory, object
# 					file depends to
# $(CF_$@) - C flags, specific for compiled obj file
# $(LF_ALL) - generic linker flags
# $(LF_$@) - link flags, specific for file
CC_COMP	=$(CC)\
	 $(CF_ALL)\
	 $(CF_$@)\
	 $(CF_$(patsubst %/,%,$(dir $<)))\
	 -o $@ -c $<
L_LINK	=$(CC)\
	 $(LF_ALL)\
	 $(LF_$@)\
	 -o $@ $^

# sp = stack pointer
# dirstack_* = stack of directories
# d = current directory (in this very include)
# bd = mirror of d in build directory
# od = mirror of d in objs directory

define dstack_push
$(eval sp		:=$(sp).x)
$(eval dirstack_$(sp)	:=$(d))
$(eval d		:=$(dir))
$(eval bd		:=$(DIR_OUT)/$(d))
$(eval od		:=$(DIR_OBJS)/$(d))
endef

define dstack_pop
$(eval d	:=$(dirstack_$(sp)))
$(eval bd	:=$(DIR_OUT)/$(d))
$(eval od	:=$(DIR_OBJS)/$(d))
$(eval sp	:=$(basename $(sp)))
endef

define dinclude
$(foreach val,$(SUBDIRS),\
	$(eval dir:=$(d)/$(val))\
	$(eval include $(dir)/Rules.mk))
endef

# includes deps from .c files, with use of OBJS_$(d).
# parses OBJS_$(d) to get source files, than makes deps
# from it.
dincdeps =$(eval include $(patsubst %.c,\
	$(DIR_OBJS)/%.d,\
	$(patsubst $(DIR_OBJS)/%.o,%.c,$(OBJS_$(d)))) )

define rbeg
$(dstack_push)
endef

define rend

$(eval
ifneq ($(MAKECMDGOALS),clean)
$$(dincdeps)
endif
)

$(dstack_pop)

endef

dirguard=@mkdir -p $(@D)

append =$(eval $(1):=$($(1)) $(2))

# LOGIC

.PHONY: all init targets clean all

all: init targets
	@echo done

ROOT_TOP	:=ant bee

# Copy paste of $(dinclude), but for root mkfile
SUBDIRS	:=$(ROOT_TOP)
$(foreach val,$(SUBDIRS),\
	$(eval dir:=$(val))\
	$(eval include $(dir)/Rules.mk))

$(DIR_OBJS)/%.o: %.c
	$(dirguard)
	$(CC_COMP)

$(DIR_OBJS)/%.d: %.c
	$(dirguard)
	echo -n $(@D)/ > $@
	$(CC) -MM $< $(CF_$(patsubst %.c,\
	$(DIR_OBJS)/%.o,\
	$<))\
	$(CF_$(patsubst %/,%,$(dir $<)))\
	>> $@


init:
# init build tree
	mkdir -p $(DIR_OUT) \
		$(addprefix $(DIR_OUT)/,$(shell find $(ROOT_TOP) -type d))
# TGT_* CLEAN are user defined
targets: $(TGT_BIN) $(TGT_SBIN) $(TGT_ETC) $(TGT_LIB)

clean:
	rm -rf $(DIR_OUT)
clean_%:
	rm -rf $(DIR_OUT)/$(patsubst clean_%,%,$@)
	rm -rf $(DIR_OBJS)/$(patsubst clean_%,%,$@)
