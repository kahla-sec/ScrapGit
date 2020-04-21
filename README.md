# ScraGit #

![FIGLET](https://imgur.com/p6UNh64.png)

It's a simple tool permitting to extract emails from websites and search for a special query in github commits using **Github Search API**

**Disclaimer:** This tool is for educational purposes only! Use it at your own risk

## Idea ##

A lot of unaware developers forget the session Secret Key or JWT key hardcoded in their projects when they publish it in Github , so to become more familiar with bash scripting
i decided to develop this little tool that do some basic search in github commits. It also extracts emails from a list of websites .

## How to Install ? ##

### Dependencies: ###

**jq** for json parsing:

> apt-get install jq

Now you only have to clone the project and start scraping \o/

## How to use ? ##

![HELP](https://imgur.com/tkSi3Nb.png)

### Extracting Emails ###

-1) You have to specify the file containing the websites from which you will extract the emails using **-f** or **--file** option

-2) You have to specify **--extract email** or **-e email**

-3) It's optional but you can specify where to output the results using **--output-- or **-o**

### Searching in Github commits ###

-1) You have to specify **--github** option 

-2) You have to specify the query option using **-q** or **--query** or the default one will be used ("secret_key")

-3) It's optional but you can specify where to output the results using **--output-- or **-o**

## TODO ##

+ Support Shodan

+ Improve Github Search API usage

+ Extract other informations from websites
