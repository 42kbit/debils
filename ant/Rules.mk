$(rbeg)

OBJS_$(d)	:=$(od)/main.o $(od)/dir/another.o
TGTS_$(d)	:=$(bd)/a.out

# flag specicic for file
CF_$(od)/main.o		:=-pedantic
CF_$(od)/dir/another.o 	:=-Wextra
# flag specific for directory
CF_$(d)			:=-O2
CF_$(d)/dir		:=-O0

CF_$(d)/dir		:=-Ibee/include

LF_$(TGTS_$(d))		:=-L$(DIR_OUT)/bee -lsum

# target named via direcotry
$(call append,TGT_BIN,$(d))

$(d): $(TGTS_$(d))
$(TGTS_$(d)): $(DIR_OUT)/bee/libsum.so $(OBJS_$(d))
	$(L_LINK)

$(rend)
