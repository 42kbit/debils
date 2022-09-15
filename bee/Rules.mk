$(dstack_push)

OBJS_$(d)	:=$(od)/sum.o
TGTS_$(d)	:=$(bd)/libsum.so

CF_$(d)		:=-O2 -I$(d)/include
LF_$(TGTS_$(d))	:=-shared

$(call append,TGT_LIB,$(d))

$(d): $(TGTS_$(d))
	cp -r $@/include $(bd)
$(TGTS_$(d)):	$(OBJS_$(d))
	$(L_LINK)

include $(patsubst %.c,\
	$(DIR_OBJS)/%.d,\
	$(patsubst $(DIR_OBJS)/%.o,%.c,$(OBJS_$(d))))

$(dincdeps)
$(dstack_pop)
