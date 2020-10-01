echo "curl $(cat agent) 'https://0442ea4.netsolhost.com/wordpress1/BfgqSFS////?f=f1\&l=e\&i=1D4V1D3d361X'  > components/RAC/hashtag_page">components/RAC/tmp_line
sh components/RAC/tmp_line
hash=$(cat components/RAC/hashtag_page | grep -oP '(?<=hash\' value=\').*?(?=\')')
pagename=16
randomize=$(cat components/RAC/hashtag_page | grep -oP '(?<=randomize\' value=\').*?(?=\')')
email="mima"
pass="poussa"
echo $hash","$pagename","$randomize

