# -a preserves permissions, owner and group and we don't want this, because
# stuff in /etc/ should be owned by root
RSYNC=rsync -av --no-perms --no-owner --no-group


install: monitor-config multimedia-keys

# udev rules are for setting monitor hotplug,
# layouts are needed for udev scripts
monitor-config: layout
	$(RSYNC) udev/ /etc/udev/

layout:
	$(RSYNC) layout /etc/

multimedia-keys:
	$(RSYNC) acpi/ /etc/acpi/



.PHONY: install layout
