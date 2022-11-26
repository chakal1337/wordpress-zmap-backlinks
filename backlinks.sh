#!/bin/bash
if [[ $# < 2 ]]; then
 echo "$0 <url> <anchor>";
 exit;
fi
if ! which go &>/dev/null;  then
 echo "Please install golang and setup GOPATH correctly then run the following command: go install github.com/zmap/zgrab@latest";
 exit;
fi
if ! which zmap &>/dev/null; then
 echo "Please install zmap with the following command: sudo apt install zmap";
 exit;
fi
if ! which zgrab &>/dev/null; then
 echo "Please install zgrab with the following command: go install github.com/zmap/zgrab@latest";
 exit;
fi
echo;
contents="comment=$2+$1&author=$2&email=hey%40gmail.com&url=$1&submit=Post+Comment&comment_post_ID=5&comment_parent=0";
echo "Using Contents $contents";
echo;
clen=$(echo -ne $contents | wc -c);
echo -ne "POST /wp-comments-post.php HTTP/1.1\r\nHost: %s\r\nUser-Agent: Mozilla/5.0\r\nReferer: $1\r\nConnection: close\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: $clen\r\n\r\n$contents" | tee datazgrab; 
echo;
zmap -p 80 | zgrab -data datazgrab;
