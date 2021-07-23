# DIRECTORIES
SRC_DIR := ./src
OBJ_DIR := ./obj
INCLUDE_DIR := ./include
SYSROOT_DIR := ../../sysroot
LIB_INSTALL_DIR := $(SYSROOT_DIR)/los/lib
INCLUDE_INSTALL_DIR := $(SYSROOT_DIR)/los

# SOURCE FILES
SRC_FILES := $(shell find $(SRC_DIR) -name '*.cpp')

# OBJECT FILES
OBJ_FILES := $(SRC_FILES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# TARGET
TARGET := ./libc++.a

# PROGRAMS
CC := clang++
CC_FLAGS := --target=x86_64-los --sysroot=$(SYSROOT_DIR) -Wall -g -I$(INCLUDE_DIR) -c

AR := ar
AR_FLAGS := rcs

# COLORS
CYAN := \033[36;1m
RESET := \033[0m

# RULES
all: dirs $(TARGET) $(CRT0)

install: all
	@cp -r $(INCLUDE_DIR) $(INCLUDE_INSTALL_DIR)

clean:
	@rm -rf $(OBJ_DIR)/*
	@rm -f $(TARGET)

# COMPILATION RULES
.SECONDEXPANSION:

$(TARGET): $(OBJ_FILES)
	@echo "   $(CYAN)Archiving$(RESET) $@ . . ."
	@$(AR) $(AR_FLAGS) $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $$(@D)/.
	@echo "   $(CYAN)Compiling$(RESET) $^ . . ."
	@$(CC) $(CC_FLAGS) -o $@ $^

# DIRECTORY RULES
$(OBJ_DIR)/.:
	@mkdir -p $@

$(OBJ_DIR)%/.:
	@mkdir -p $@

dirs:
	@mkdir -p $(OBJ_DIR)
	
# . RULES
.PRECIOUS: $(OBJ_DIR)/. $(OBJ_DIR)%/.
.PHONY: dirs
