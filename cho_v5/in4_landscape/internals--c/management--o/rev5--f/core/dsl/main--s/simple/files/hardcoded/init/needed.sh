## sssd
cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/sssd_basic.conf /etc/sssd/sssd.conf	
sed -i "s/%ORG%/$Org/" /etc/sssd/sssd.conf	
sed -i "s/%NET%/$Net/" /etc/sssd/sssd.conf	
rm -f /etc/systemd/system/rev5_sssd.service  				&& ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/_systemd/rev5_sssd.service 		/etc/systemd/system/  
systemctl disable sssd && systemctl stop sssd && systemctl enable rev5_sssd && systemctl restart rev5_sssd
##
	
		systemctl enable rev5.timer && systemctl restart rev5.timer

		
		## rsyslog

##

## DRBD

zypper ar -p 10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/data_safety--c:/replication--o:/block--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:data_safety--c:replication--o:block--f.repo
zypper in drbd9-kmp-default drbd9 drbd-utils


spiceusbredirection=4
# This adds intel hd audio emulated card used for spice audio
soundhw="hda"
