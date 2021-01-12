#!/bin/bash
curl -s https://www.snort.org/downloads/community/md5s |\
  grep community |\
  grep -v snort3 \
  > /etc/snort/rules/md5_new

res=`diff /etc/snort/rules/md5_cur /etc/snort/rules/md5_new |\
  wc -l`

if [$res = 0]; then
  echo -e "\n=== snort rules updater ===\n`date`\nno update" >> /var/log/snort/updater
else
  wget -P /var/tmp/ https://www.snort.org/downloads/community/community-rules.tar.gz
  tar zxvf /var/tmp/community-rules.tar.gz -C /var/tmp
  mv -f /var/tmp/community-rules/community.rules /etc/snort/rules
  rm -rf /var/tmp/community-rules*
  echo -e "\n=== snort rules updater ===\n`date`\nupdated" >> /var/log/snort/updater
fi

