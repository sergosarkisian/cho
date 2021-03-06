#!/bin/bash

### ON HV ###
mkfs.btrfs  -L "storage" ./storage.raw 
###

### TMP ###
zypper ar -cf http://download.opensuse.org/repositories/filesystems/openSUSE_Leap_42.2/filesystems.repo
zypper --gpg-auto-import-keys dup
###

### ZYPPER  ###
 zypper --non-interactive in unixODBC unixODBC-devel bison flex gcc make gcc-c++ pcre-devel zlib-devel patch m4 glibc binutils glibc-devel libaio1 libaio-devel libelf0 libelf1 libelf-devel numactl libtool libstdc++6 libstdc++-devel libgcc_s1 expat libopenssl-devel binutils-devel glibc-devel-32bit libaio-devel-32bit unixODBC-32bit libgthread-2_0-0-32bit gcc-32bit gcc-c++-32bit gcc48-32bit libgcc_s1-32bit glibc-32bit binutils-devel-32bit
 zypper --non-interactive in http://ftp.novell.com/partners/oracle/orarun-2.0-1.4.0.x86_64.rpm
 chkconfig oracle off
 rm /etc/init.d/oracle
 #?? raw service
###

### AS INIT  ###
mkdir -p /media/storage/as
 btrfs subvolume create /media/storage/as/oracle
 #data
mkdir -p /media/storage/as/oracle/data
 btrfs subvolume create /media/storage/as/oracle/data/master
 btrfs subvolume create /media/storage/as/oracle/data/archive
 btrfs subvolume create /media/storage/as/oracle/data/export
 btrfs subvolume create /media/storage/as/oracle/data/import
 #
 
 #cone
 btrfs subvolume create /media/storage/as/oracle/cone
 mkdir -p /media/storage/as/oracle/cone/plsql_compile
#

 #logs
 btrfs subvolume create /media/storage/as/oracle/logs
 mkdir -p /media/storage/as/oracle/logs/adump
 mkdir -p /media/storage/as/oracle/logs/bdump
 mkdir -p /media/storage/as/oracle/logs/cdump
 mkdir -p /media/storage/as/oracle/logs/udump
 mkdir -p /media/storage/as/oracle/logs/audit
 mkdir -p /media/storage/as/oracle/logs/network
#
 
#conf
 btrfs subvolume create /media/storage/as/oracle/conf
 mkdir -p /media/storage/as/oracle/conf/_context
 mkdir -p /media/storage/as/oracle/conf/_generated
 #
 
 # misc
 btrfs subvolume create /media/storage/as/oracle/misc/
 mkdir -p /media/storage/as/oracle/misc/flash_recovery_area
 mkdir -p /media/storage/as/oracle/misc/tmp
 #

mkdir -p /media/storage/as/oracle/home
 
 ##FIX!!!
setfacl -m g::rx  /media/storage/as/oracle
setfacl -m o::rx  /media/storage/as/oracle
setfacl -m g::rx  /media/storage/as
setfacl -m o::rx  /media/storage/as
##
###


### TS INIT  ###
mkdir -p /media/storage/ts/services--c/database--o/rdbms--f
btrfs subvolume create /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw

mkdir -p /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
setfacl -R -m u:oracle:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
setfacl -R -m d:u:oracle:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
setfacl -R -m g:oinstall:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
setfacl -R -m d:g:oinstall:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/

##FIX!!
setfacl -m g::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
setfacl -m o::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
setfacl -m g::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw
setfacl -m o::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw
setfacl -m g::rx  /media/storage/ts/services--c/database--o/rdbms--f
setfacl -m o::rx  /media/storage/ts/services--c/database--o/rdbms--f
setfacl -m g::rx  /media/storage/ts/services--c/database--o
setfacl -m o::rx  /media/storage/ts/services--c/database--o
setfacl -m g::rx  /media/storage/ts/services--c/
setfacl -m o::rx  /media/storage/ts/services--c/
setfacl -m g::rx  /media/storage/ts
setfacl -m o::rx  /media/storage/ts
##
###


### ORACLE INIT  - /etc ###
rm -f /etc/systemd/system/in4__oracle10g.service && cp  /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/_systemd/in4__oracle10g.service /etc/systemd/system/
rm -f  /etc/profile.d/oracle.sh && ln -s /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/profile.d_oracle.sh /etc/profile.d/oracle.sh
touch /etc/oratab && chown oracle:oinstall /etc/oratab && chmod 750 /etc/oratab
###


###  ORACLE USER & PERMS  ###
usermod -s /bin/bash oracle 
usermod -d /media/storage/as/oracle/home oracle 

chmod 755 /media/storage/as
chown -R oracle:oinstall /media/storage/as/oracle
setfacl -R -m u:oracle:rwx /media/storage/as/oracle
setfacl -R -m d:u:oracle:rwx /media/storage/as/oracle
setfacl -R -m g:oinstall:rwx /media/storage/as/oracle
setfacl -R -m d:g:oinstall:rwx /media/storage/as/oracle
###


### ORACLE DB  ###
cd  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
wget http://public.edss.ee/software/Linux/Oracle/in4_oracle10g--g_ee.tar.gz && tar -xzf ./in4_oracle10g--g_ee.tar.gz
 chown -R oracle:oinstall /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
###

### FIREWALL ###
rm -f /etc/sysconfig/SuSEfirewall2.d/services/in4__oracle10g && ln -s  /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/_firewall/in4__oracle10g /etc/sysconfig/SuSEfirewall2.d/services/
###


### CREATE RO SNAPSHOT  ###
btrfs subvolume delete /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g
btrfs subvolume snapshot -r /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g
###
