#!/bin/sh
cd `dirname $0`
git reset --hard
git pull

git submodule update --init
for i in gfwlist genpac
do
	(cd $i;git pull origin master)
done

(cd genpac;python setup.py install)

genpac \
	--pac-proxy "SOCKS5 127.0.0.1:1081" \
	--gfwlist-url - \
	--gfwlist-local gfwlist/gfwlist.txt \
	-o gfwlist.pac
sed -e '5d' -e '3d' -i gfwlist.pac

git add .
git commit -m "[$(LANG=C date)]auto update"
git push origin master
