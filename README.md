# cisco79xx-to-asterisk
Connect cisco phones 7911/7942/6961/6941/6921 to asterisk
Example configs and firmwares 

Put it to \tftpboot and configure tftp service 

# How to check service:
netstat -ltunp | grep tftp
udp        0      0 0.0.0.0:69              0.0.0.0:*                           1177/atftpd   
