
### ZYPPER ###
rm /etc/zypp/repos.d/*
zypper ar -cf http://download.opensuse.org/repositories/openSUSE:/Leap:/42.1/standard standard::leap42.1
zypper ar -cf http://download.opensuse.org/update/leap/42.1/oss update_oss::leap42.1
zypper ar -cf http://download.opensuse.org/update/openSUSE-stable update_oss::stable
##SOME STANDARD
zypper ar -cf http://download.opensuse.org/repositories/network/openSUSE_Leap_42.1/network.repo

##CONE CENTER
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/services--c:/virtualization--o:/vm--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:services--c:virtualization--o:vm--f.repo
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/logitoring--c:/messagebus--o:/syslog--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:logitoring--c:messagebus--o:syslog--f.repo
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/internals--c:/management--o:/infrastructure--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:internals--c:management--o:infrastructure--f.repo
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/internals--c:/linux_sys--o:/kernel_leap42_2--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:internals--c:linux_sys--o:kernel_leap42_2--f.repo


zypper  --gpg-auto-import-keys ref
zypper --non-interactive in --force kernel-default grub2 aaa_base kmod binutils
#Xen
zypper --non-interactive in --force spice-vdagent xen-tools-domU xen-libs
zypper --non-interactive in --force hostname iproute2 wicked-service dbus-1 SuSEfirewall2 strace
zypper --non-interactive in --force bash-completion systemd-bash-completion aaa_base-extras sudo
zypper --non-interactive in --force openssh
zypper --non-interactive in --force rsyslog rsyslog-module-relp rsyslog-module-mmnormalize 
zypper --non-interactive in --force btrfsprogs e2fsprogs sysfsutils
zypper --non-interactive in --force sssd sssd-tools 
zypper --non-interactive in --force yast2-security
zypper --non-interactive in --force mc vim lsof less strace 
#MISC
zypper --non-interactive in --force rsync subversion git sysstat tcpdump telnet wget
#curl deltarpm expect sysfsutils exim atop diff
zypper --non-interactive --gpg-auto-import-keys dup
 ###
 
 ### BOOT, GRUB2 init ###
grub2-install /dev/loop60
#DOUBLE
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
###

sh /tmp/3.init_common.sh

### REV5 - SYSTEMD ###
systemctl enable sshd
systemctl enable rev5_init_auto_xen
###
#######

### RM ALL LOGS & TRACES ###
rm /etc/resolv.conf
rm -f /var/log/*/*
rm -f /var/log/*.log
rm /root/.bash_history
rm -rf /tmp/*
history -c
exit 
