NASM = nasm
QEMU = qemu-system-i386

BUILD_DIR = build
VENDOR_DIR = vendor
RES_DIR = res
TMP_DIR = tmp
GIT_DIR = .git

NAME ?= TINYSOLB

TINYSOL_COM ?= $(VENDOR_DIR)/tinysol/TINYSOL.COM
TINYSOL_TEXT_ATTR ?= 0000Fh

NASM_FLAGS=-f bin -isrc/ -DTINYSOL_COM='"$(TINYSOL_COM)"' -DTINYSOL_TEXT_ATTR=$(TINYSOL_TEXT_ATTR)

IMAGE_FILENAME = $(NAME).IMG
IMAGE_144M_FILENAME = TSBF144M.IMG
IMAGE_720K_FILENAME = TSBF720K.IMG
IMAGE_360K_FILENAME = TSBF360K.IMG
ISO_FILENAME = $(NAME).ISO
ZIP_FILENAME = $(NAME).ZIP
FILE_ID_FILENAME = FILE_ID.DIZ
BOOT_CATALOG = TSBIBOOT.CAT

TARGET_IMAGE = $(BUILD_DIR)/$(IMAGE_FILENAME)
TARGET_144M_IMAGE = $(BUILD_DIR)/$(IMAGE_144M_FILENAME)
TARGET_720K_IMAGE = $(BUILD_DIR)/$(IMAGE_720K_FILENAME)
TARGET_360K_IMAGE = $(BUILD_DIR)/$(IMAGE_360K_FILENAME)
TARGET_ISO = $(BUILD_DIR)/$(ISO_FILENAME)
TARGET_FILE_ID_DIZ = $(RES_DIR)/$(FILE_ID_FILENAME)
TARGET_ZIP = $(BUILD_DIR)/$(ZIP_FILENAME)
TARGET_BOOT_CATALOG = $(BUILD_DIR)/$(BOOT_CATALOG)

SOURCES = src/boot.asm \
		  src/std.asm \
		  src/dos.asm

all: image

$(TARGET_IMAGE): $(SOURCES) $(TINYSOL_COM)
	$(NASM) $(NASM_FLAGS) -o $@ $<

image: $(TARGET_IMAGE)

floppy: image
	dd bs=512 count=2880 if=/dev/zero of=$(TARGET_144M_IMAGE)
	dd bs=737280 count=1 if=/dev/zero of=$(TARGET_720K_IMAGE)
	dd bs=368640 count=1 if=/dev/zero of=$(TARGET_360K_IMAGE)
	dd status=noxfer conv=notrunc if=$(TARGET_IMAGE) of=$(TARGET_144M_IMAGE)
	dd status=noxfer conv=notrunc if=$(TARGET_IMAGE) of=$(TARGET_720K_IMAGE)
	dd status=noxfer conv=notrunc if=$(TARGET_IMAGE) of=$(TARGET_360K_IMAGE)

iso: floppy
	$(RM) $(TARGET_ISO)
	mkisofs -quiet -V '$(NAME)' \
		-R -J -input-charset iso8859-1 \
		-o $(TARGET_ISO) \
		-m $(TARGET_ISO) \
		-m $(TMP_DIR) \
		-m $(GIT_DIR) \
		-b $(TARGET_144M_IMAGE) \
		-c $(TARGET_BOOT_CATALOG) .

qemu: image
	SDL_VIDEO_CENTERED=1 $(QEMU) -display sdl -drive file=$(TARGET_IMAGE),format=raw,if=floppy -boot a

qemu_iso:
	SDL_VIDEO_CENTERED=1 $(QEMU) -display sdl -cdrom $(TARGET_ISO) -boot d

zip: image
	zip -FSj $(TARGET_ZIP) $(TARGET_IMAGE) $(TARGET_FILE_ID_DIZ)

clean:
	$(RM) $(TARGET_IMAGE)
	$(RM) $(TARGET_144M_IMAGE)
	$(RM) $(TARGET_720K_IMAGE)
	$(RM) $(TARGET_360K_IMAGE)
	$(RM) $(TARGET_ISO)
	$(RM) $(TARGET_ZIP)

.PHONY: qemu qemu_iso zip clean
