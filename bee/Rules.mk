SUBDIRS_$(d)	:=sub

COBJS_$(d)	:=$(od)/sum.o

OBJS_$(d)	:=$(COBJS_$(d))
TGTS_$(d)	:=$(bd)/libsum.so

CF_$(d)		:=-O2 -I$(d)/include
LF_$(TGTS_$(d))	:=-shared

$(call append,TGT_LIB,$(d))

$(d): $(TGTS_$(d))
	cp -r $@/include $(bd)
$(TGTS_$(d)):	$(OBJS_$(d))
	$(L_LINK)

