# Centos Install
pip2 install supervisor
echo_supervisord_conf > /etc/supervisord/supervisord.conf
echo "files = conf.d/*.conf" >> /etc/supervisord/supervisord.conf
wget https://gist.githubusercontent.com/mozillazg/6cbdcccbf46fe96a4edd/raw/2f5c6f5e88fc43e27b974f8a4c19088fc22b1bd5/supervisord.service -O /usr/lib/systemd/system/supervisord.service
# uncomment "[include]" in the last two line
# uncomment below in the front
```
[supervisorctl]
serverurl=unix:///usr/local/var/run/supervisor.sock ; use a unix:// URL  for a unix socket
;serverurl=http://127.0.0.1:9001 ; use an http:// url to specify an inet socket
;username=chris              ; should be same as in [*_http_server] if set
;password=123                ; should be same as in [*_http_server] if set
;prompt=mysupervisor         ; cmd line prompt (default "supervisor")
;history_file=~/.sc_history  ; use readline history if available 
```

systemctl start supervisord
systemctl enable supervisord
