echo "curl $(cat agent) $(cat cookie) $(cat host) https://mbasic.facebook.com/story.php?story_fbid=111481227347328\&id=100054563540381 > components/RAC/user_page" > components/RAC/tmp_line
sh components/RAC/tmp_line
echo -e "\e[32mcommenting in own story\e[0m"
echo "curl $(cat agent) $(cat cookie) $(cat host) --request POST --data \"fb_dtsg=$(cat components/RAC/user_page | grep -oP '(?<=name=\"fb_dtsg\" value=\").*?(?=\")' | uniq)&jazoest=$(cat components/RAC/user_page | grep -oP '(?<=name=\"jazoest\" value=\").*?(?=\")' | uniq)&comment_text=#JusticeForNirmalaPanthA\" https://mbasic.facebook.com/a/comment.php?$(cat components/RAC/user_page | grep -oP '(?<=comment_logging&amp;).*?(?=&)' | uniq)">components/RAC/tmp_line
sh components/RAC/tmp_line
cursor=""
post_count=0
comment_count=0
i=0
while read hashtag
do
    echo $cursor > components/RAC/cursor
    while read cursor
    do
        url="https://mbasic.facebook.com/hashtag/$hashtag/?cursor=$cursor"
        echo "curl $(cat agent) $(cat cookie) $(cat host) $url  > components/RAC/hashtag_page" > components/RAC/tmp_line
        sh components/RAC/tmp_line
        cat components/RAC/hashtag_page | grep -oP '(?<=story.php\?story_fbid=).*?(?=&)' | sort | uniq > components/RAC/story_id
        while read story_id
        do
            echo -e "\e[32mmain fetched for story id={$story_id}\e[0m"
            main_id=$(cat components/RAC/hashtag_page | grep -oP '(?<='$story_id'&amp;id=).*?(?=&)' | uniq)
            echo -e "\e[32mfound main id={$main_id}\e[0m"
            post_count=$(($post_count+1))
            echo -e "\e[36mpost reach={$post_count}\e[0m"
            echo $main_id >> components/PSC/profile_id
            echo "curl $(cat agent) $(cat cookie) $(cat host) https://mbasic.facebook.com/story.php?story_fbid="$story_id"\&id="$main_id" > components/RAC/comment_page" > components/RAC/tmp_line
            sh components/RAC/tmp_line
            echo -e "\e[32mcommenting in story id={$story_id}\e[0m"
            fb_dtsg=$(cat components/RAC/comment_page | grep -oP '(?<=name=\"fb_dtsg\" value=\").*?(?=\")' | uniq)
            jazoest=$(cat components/RAC/comment_page | grep -oP '(?<=name=\"jazoest\" value=\").*?(?=\")' | uniq)
            comment_identifier=$(cat components/RAC/comment_page | grep -oP '(?<=comment_logging&amp;).*?(?=&)' | uniq)
            for (( c=1; c<=30; c++ ))
            do  
                echo "\e[32mfb_dtsg={$fb_dtsg},jazoest={$jazoest},comment_identifier={$comment_identifier}\e[0m"
                > components/RAC/status
                echo "curl -o /dev/null -w '%{http_code}' $(cat agent) $(cat cookie) $(cat host) --request POST --data \"fb_dtsg=$fb_dtsg&jazoest=$jazoest&comment_text=#JusticeForNirmalaPanta\" https://mbasic.facebook.com/a/comment.php?$comment_identifier > components/RAC/status" > components/RAC/tmp_line
                sh components/RAC/tmp_line
                if [ $(cat components/RAC/status) == 302 ];then
			        echo -e "\e[32mdone commenting in story id={$story_id}\e[0m"
                    comment_count=$(($comment_count+1))
                    echo -e "\e[35mcomment reach={$comment_count}\e[0m"
		        else
		            echo -e "\e[31merror commenting in story id={$story_id}\e[0m"
		        fi
            done
            i=$(($i+1))
	    done < components/RAC/story_id
        cursor=$null
        cursor=$(cat components/RAC/hashtag_page | grep -oP '(?<=cursor=).*?(?=")' | uniq)
        if [ -n $cursor ];then
            echo -e "\e[32mfound new cursor\e[0m"
            echo $cursor >> components/RAC/cursor
        fi
    done < components/RAC/cursor
done < components/PSC/hashtag
echo "curl $(cat agent) $(cat cookie) $(cat host) https://mbasic.facebook.com/story.php?story_fbid=111481227347328\&id=100054563540381 > components/RAC/user_page" > components/RAC/tmp_line
sh components/RAC/tmp_line
echo -e "\e[32mcommenting in own story\e[0m"
echo "curl $(cat agent) $(cat cookie) $(cat host) --request POST --data \"fb_dtsg=$(cat components/RAC/user_page | grep -oP '(?<=name=\"fb_dtsg\" value=\").*?(?=\")' | uniq)&jazoest=$(cat components/RAC/user_page | grep -oP '(?<=name=\"jazoest\" value=\").*?(?=\")' | uniq)&comment_text=#JusticeForNirmalaPantha\" https://mbasic.facebook.com/a/comment.php?$(cat components/RAC/user_page | grep -oP '(?<=comment_logging&amp;).*?(?=&)' | uniq)">components/RAC/tmp_line
sh components/RAC/tmp_line