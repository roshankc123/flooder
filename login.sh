i=1
while read ids
do
    read email pass <<< $ids
    echo " curl $(cat agent) $(cat host) https://mbasic.facebook.com > components/RAC/login_page" > components/RAC/tmp_line
    sh components/RAC/tmp_line
    lsd=$(cat components/RAC/login_page | grep -oP '(?<=lsd" value=").*?(?=")' | uniq)
    jazoest=$(cat components/RAC/login_page | grep -oP '(?<=jazoest" value=").*?(?=")' | uniq)
    m_ts=$(cat components/RAC/login_page | grep -oP '(?<=m_ts" value=").*?(?=")' | uniq)
    li=$(cat components/RAC/login_page | grep -oP '(?<=li" value=").*?(?=")' | uniq)
    try_number=$(cat components/RAC/login_page | grep -oP '(?<=try_number" value=").*?(?=")' | uniq)
    unrecognized_tries=$(cat components/RAC/login_page | grep -oP '(?<=unrecognized_tries" value=").*?(?=")' | uniq)
    echo "$lsd,$jazoest,$m_ts,$li,$try_number,$unrecognized_tries"
    echo "curl -c cookie$i $(cat agent) $(cat host) --request POST --data \"lsd=$lsd&jazoest=$jazoest&m_ts=$m_ts&li=$li&try_number==$try_number&unrecognized_tries=$unrecognized_tries&email=$email&pass=$pass\" https://mbasic.facebook.com/login/device-based/regular/login/" > components/RAC/tmp_line
    sh components/RAC/tmp_line
    i=$(($i+1))
done < components/PSC/ids