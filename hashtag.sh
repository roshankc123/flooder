cursor=""
post_count=0
comment_count=0
i=0
cookie="cookie1"
while read hashtag
do
    echo $cursor > components/RAC/cursor
    while read cursor
    do
        url="https://mbasic.facebook.com/hashtag/$hashtag/?cursor=$cursor"
        echo "curl $(cat agent) -b $cookie $(cat host) '$url'  > components/RAC/hashtag_page" > components/RAC/tmp_line
        cat components/RAC/tmp_line
        sh components/RAC/tmp_line
        cat components/RAC/hashtag_page | grep -oP '(?<=story.php\?story_fbid=).*?(?=&)' | sort | uniq > components/RAC/story_id
        while read story_id
        do
            sleep 2
            echo -e "\e[32mmain fetched for story id={$story_id}\e[0m"
            main_id=$(cat components/RAC/hashtag_page | grep -oP '(?<='$story_id'&amp;id=).*?(?=&)' | uniq)
            echo -e "\e[32mfound main id={$main_id}\e[0m"
            post_count=$(($post_count+1))
            echo -e "\e[36mpost reach={$post_count}\e[0m"
            echo $main_id >> components/PSC/profile_id
            for (( c=1; c<=5; c++ ))
            do 
                echo "curl $(cat agent) -b $cookie $(cat host) 'https://mbasic.facebook.com/story.php?story_fbid="$story_id"\&id="$main_id"' > components/RAC/comment_page" > components/RAC/tmp_line
                sh components/RAC/tmp_line
                echo -e "\e[32mcommenting in story id={$story_id}\e[0m"
                fb_dtsg=$(cat components/RAC/comment_page | grep -oP '(?<=name=\"fb_dtsg\" value=\").*?(?=\")' | uniq)
                jazoest=$(cat components/RAC/comment_page | grep -oP '(?<=name=\"jazoest\" value=\").*?(?=\")' | uniq)
                comment_identifier=$(cat components/RAC/comment_page | grep -oP '(?<=comment_logging&amp;).*?(?=&)' | uniq)
                if [  -n $fb_dtsg ]  && [ $jazoest ] &&  [ -n $comment_identifier ];then 
                    # if [ $(($i%100)) == 0 ];then
                    #     p=$(($p+1))
                    #     cookie="cookie"$((($p%2)+1))
                    # fi
                    echo -e "\e[32mfb_dtsg={$fb_dtsg},jazoest={$jazoest},comment_identifier={$comment_identifier}\e[0m"
                    echo "curl -o /dev/null -w '%{http_code}' $(cat agent) -b $cookie $(cat host) --request POST --data \"fb_dtsg=$fb_dtsg&jazoest=$jazoest&comment_text=#JusticeForNirmalaPanta\" 'https://mbasic.facebook.com/a/comment.php?$comment_identifier'" > components/RAC/tmp_line
                    # cat components/RAC/tmp_line
                    status=$(sh components/RAC/tmp_line)
                    if [ $status == 302 ];then
			                echo -e "\e[32mdone commenting in story id={$story_id}\e[0m"
                        comment_count=$(($comment_count+1))
                        echo -e "\e[35mcomment reach={$comment_count}\e[0m"
		            else
		                echo -e "\e[31merror commenting in story id={$story_id}\e[0m"
                        break
		            fi
                fi
            done
            i=$(($i+1))
	    done < components/RAC/story_id
        if [ $comment_count -gt 1000 ];then
            break
        fi
        cursor=$null
        cursor=$(cat components/RAC/hashtag_page | grep -oP '(?<=cursor=).*?(?=")' | uniq)
        if [ -n $cursor ];then
            echo -e "\e[32mfound new cursor\e[0m"
            echo $cursor >> components/RAC/cursor
        fi
    done < components/RAC/cursor
    if [ $comment_count -gt 1000 ];then
            break
    fi
done < components/PSC/hashtag
