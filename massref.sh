#!/usr/bin/env /bin/zsh
if [[ $# < 3 ]]; then
 echo "$0 <url> <anchor> <rate>";
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
while true; do
  echo -ne "GET / HTTP/1.1\r\nHost: %s\r\nUser-Agent: Mozilla/5.0 +($2)\r\nReferer: $1\r\nConnection: close\r\n\r\n" | tee datazgrab; 
  echo "Running...";
  masscan -p 80 0.0.0.0/0 --exclude 255.255.255.255 --rate $3 2>/dev/null | grep --color=never -oP "(?<=on\s).*" | sed -e "s/\s//g" | zgrab -data datazgrab -timeout 2 -gomaxprocs 5 &>/dev/null;
done
