#!/bin/bash
output="./Output"
github=0
commit=1
query="secret_key"
figlet(){
echo "H4sIACg5nl4AA41NwQ0AMQj6OwXfvlzgRjFxEYY/sL2kzzNpQUREqwAMHO4WlzakEWlCHJCn7ErD1uTkhDHKG0XIp8deZolPawzMF95d4zq5zwlUMqXw8trTOtlzjyKV6mGyNWd4otz/FS/+q73tCAEAAA=="|base64 -d|gunzip
}
read -r -d '' HEADER << EOM
<usage> $0 [OPTIONS] .\n
Enter --help or -h for more informations\n
Disclaimer: This tool is for educational purposes only! Use it at your own risk\n
EOM

read -r -d '' HELP << EOM
<usage> $0 [OPTIONS] .\n
Disclaimer: This tool is for educational purposes only! Use it at your own risk\n
-h|--help) Display help menu\n
-f|--file) Enter a list containing websites links\n
-e| --extract ) Specify what to extract , We only accept email now\n 
-o| --output ) Specify the output file\n
-g| --github ) Search in github commits using Git Search API\n
-q| --query ) Specify the query to search for github Search\n

EOM



header(){
	figlet
	echo -e "\n$HEADER"
}
help(){
	figlet
	echo -e "\n$HELP"
	exit
}
gitFormat(){
	echo "================">>$output
	echo -ne "Commit URL: ">>$output
	echo $out|cut -d "%" -f1>>$output
	echo -ne "\nAuthor Name: ">>$output
	echo $out|cut -d "%" -f2>>$output
	echo -ne "\nAuthor Email: ">>$output
        echo $out|cut -d "%" -f3>>$output
 	echo -ne "\nRepo Full name: ">>$output
        echo $out|cut -d "%" -f4>>$output
	echo -ne "\nCommit message: ">>$output
	echo $out|cut -d "%" -f5>>$output

}

gitsearch(){
	if [[ $output == "./Output" ]]; then
		printf "[!] No output file specified ! Using the default value %s \n" $output
	fi
	for j in {1..15};do
	wget -q -m -O /tmp/tempjunk --header "Accept: application/vnd.github.cloak-preview" https://api.github.com/search/commits?q=$query\&page=$j
		for i in {0..29}; do
			url=$(cat /tmp/tempjunk |jq ".items[$i].html_url")
			name=$(cat /tmp/tempjunk |jq ".items[$i].commit.author.name")
			email=$(cat /tmp/tempjunk |jq ".items[$i].commit.author.email")
			reponame=$(cat /tmp/tempjunk |jq ".items[$i].repository.full_name")
			msg=$(cat /tmp/tempjunk |jq ".items[$i].commit.message")
			out="${url}%"
			out+="${name}%"
			out+="${email}%"
			out+="${reponame}%"
			out+="${msg}%"
			if echo $out|grep -q "null";then
				echo "[!] No more results to fetch "
				exit
			fi
			gitFormat 
		done
	done
	rm /tmp/tempjunk 2>/dev/null
}

##### Function to extract #####

extract(){
	figlet
	toextract=$1
	if [[ $toextract == "email" ]] && [[ !$github ]]; then
		if [[ -z $filename ]]; then
			>&2 printf "[-] You have to specify the filename ! \n"
			exit 1
		fi
		printf "[+] Extracting %s in progress ..\n" $toextract
		cat $filename |while read line;do
			wget -q -O /tmp/tempjunk2 $line
			cat /tmp/tempjunk2 |grep -E -o "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b"|uniq >>$output			
		done
		printf "[+] Extracted Successfully in %s \n" $output
		rm /tmp/tempjunk2
		exit
	elif [[ $github -eq 1 ]]; then
		if [[ $query == "secret_key" ]]; then
			printf "[!] No query option specified ! using the default value %s \n" $query 		
		fi
		printf "[+] Extracting in progress ..\n"
		gitsearch
		exit
	fi
	>&2 echo "[-] Check --help for the correct options ! an option is probably missing"	
}

##### OPTIONS #####

if [[ -z $1 ]]; then
	header
	exit
fi

while [ "$1" != "" ]; do
    case $1 in
        -f | --file ) shift
                      filename=$1
        ;;
        -h | --help ) help
                      exit
        ;;
	-e | --extract ) shift 
			 extract=$1
        ;;
	-o | --output ) shift
			output=$1
	;;
	-g| --github ) shift
		       github=1
	;;
	-q| --query ) shift
		       query=$1
	;;
	  * ) header
            exit 1
    esac
    shift
done

##### MAIN #####

extract $extract
