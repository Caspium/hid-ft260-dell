KRELEASE ?= $(shell uname -r)
KBUILD ?= /lib/modules/$(KRELEASE)/build
MODDIR ?= /lib/modules/$(KRELEASE)/kernel/drivers/hid
obj-m += hid-ft260.o

all:
	$(MAKE) -C $(KBUILD) M=$(PWD) modules

clean:
	$(MAKE) -C $(KBUILD) M=$(PWD) clean

install: all
	@echo "Loading hid-ft260.ko module"
	sudo rmmod hid-ft260 2>/dev/null || true
	sudo insmod hid-ft260.ko
	@echo "Module loaded successfully."
	@echo ""
	@echo "Detected FT260 devices:"
	@chmod +x setenv.sh
	@./setenv.sh
	@echo ""

uninstall:
	@echo "Unloading hid-ft260 module"
	sudo rmmod hid-ft260 2>/dev/null || true
	@echo "Module unloaded successfully."


