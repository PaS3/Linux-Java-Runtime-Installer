#!/bin/bash

echo "Site verison:

$(curl -s https://www.java.com/en/download/linux_manual.jsp | egrep "Version | Update" | sed 's/<\/h4>//g; s/<h4\ class=\"sub\">//g; s/Recommended//g')

Local version:

$(java -version)

Local dir:

$(ls /usr/lib/jvm | grep jre)

"

fn_download_link=$(curl -s https://www.java.com/en/download/linux_manual.jsp | egrep "\"Download Java software for Linux x64\""| grep -o 'href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^href=["'"'"']//' -e 's/["'"'"']$//'| tail -1)
fn_file_name=$(curl -s $fn_download_link | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'| gawk -F? '{print $1}' | gawk -F/ '{print $NF}')
folder_ver=$(echo $fn_file_name | sed 's/\-/1\./1 ; s/u/\.0_/1' | gawk -F- '{print $1}') 

if [[ ! -d /usr/lib/jvm/$folder_ver ]]; then
    echo "Update required for some reason? [bugs] [security] [simplification] Fixes"	
    wget --output-document=$fn_file_name $fn_download_link
else 
   echo -e "Latest JRE installed!

So do not need to mess with [bugs] [security] [simplification]

"
  exit 0
fi

#read -p "Switch version" new_pat
echo -e "Installing java from the given directory containing [ bin ] [ lib ] [ man ].
"
echo "Installing java:"
#java lib root:
#/usr/lib/jvm

echo 
echo "Checking directorty"

if [ ! -d /usr/lib/jvm ]; then 
   sudo mkdir /usr/lib/jvm
else
   echo "Skip step - directory exists."
fi

echo -e "
Decompressing java to /usr/lib/jvm"
sudo tar zxvf $fn_file_name -C /usr/lib/jvm/

echo
read -p "Manual mode update alternatives:"
echo -e "Installing alternatives:

sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/$folder_ver/bin/java 1
"
echo "Setting up alternatives

sudo update-alternatives --set java /usr/lib/jvm/$folder_ver/bin/java
"
read
#$ export JAVA_HOME=<path_to_java>
#sudo ln -s  $i_bin_dir/* /usr/bin/
#sudo ln -s /usr/share/man/man1/ 

echo "Adding mozilla plugin:"

# Get java plugin dir for local browser types for install... 

sudo rm -fv /usr/lib/mozilla/plugins/libnpjp2.so
sudo ln -s /usr/lib/jvm/$folder_ver/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins/

echo "Clearn up."

sudo rm -vfr /usr/lib/jvm/$(ls /usr/lib/jvm/ | grep jre| egrep -v "$folder_ver")
rm -vf $fn_file_name

echo "Done."


