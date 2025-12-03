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
	@echo "Environment variables are now available. Examples:"
	@echo "  . ./setenv.sh          # Source to set variables in your shell"
	@echo "  echo \$$sysfs_i2c_22      # Access I2C interface (use i2cdetect -l to see device types)"
	@echo "  echo \$$sysfs_ttyFT0      # Access UART interface"

uninstall:
	@echo "Unloading hid-ft260 module"
	sudo rmmod hid-ft260 2>/dev/null || true
	@echo "Module unloaded successfully."


