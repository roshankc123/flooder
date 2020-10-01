for (( c=1; c<=1000; c++ ))
do 
	echo "curl $(cat agent) https://0442ea4.netsolhost.com/wordpress1/BfgqSFS////?f=f1\&l=e\&i=1D4V1D3d361X  > components/RAC/hashtag_page" >    	components/RAC/tmp_line
	sh components/RAC/tmp_line
	hash=$(cat components/RAC/hashtag_page | grep -oP "(?<=hash' value=').*?(?=')")
	pagename=16
	randomize=$(cat components/RAC/hashtag_page | grep -oP "(?<=randomize' value=').*?(?=')")
	email="\#JusticeForNirmalaPanta"
	pass="i am testy.banks.9"
	echo -e "\e[32m"$hash","$pagename","$randomize","$email","$pass"\e[0m"
	echo "curl -o /dev/null -w '%{http_code}' $(cat agent) --request POST --data 			\"hash=$hash&pagename=$pagename&randomize=$randomize&mima=$email&poussa=$pass\" https://0442ea4.netsolhost.com/wordpress1/BfgqSFS////" > components/RAC/tmp_line
	sh components/RAC/tmp_line
done
