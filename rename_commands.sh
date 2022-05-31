






####################### Remove single quotes from filenames & folders (recursively -- not verbose): #####################
Dry Run:
for file in * ; do echo ${file}| sed -e "s/ / /g" -e "s/[\[{\\']//g" ; done

Rename command:
for file in * ; do mv ${file}|sed -e "s/ / /g" -e "s/[\[{\\']//g" ; done




############### REMOVE '' QUOTES - RENAME FILES & FOLDERS (RECURSIVELY to replace period & space with underscore - e.g. 1. Filename = 1_Filename --- verbose ) ######################
Dry Run:
for file in *; do dest="${file//[[:space:]]/_}" && echo "$file = ${dest//[^[:alnum:]._ ]/}"; done

Rename command:
for file in *; do dest="${file//[[:space:]]/_}" &&  mv -i "$file" "${dest//[^[:alnum:]._-]/}"; done

Note: If files/folders have '' in the names then run the remove single quote command above first)


###################### Match FILES ONLY that start with "1. Filename" & RECURSIVELY to replace period & space with underscore - e.g. 1. Filename = 1_Filename --- verbose ) ######################
Dry Run:
set -- *.*
for file; do
	echo "$file == ${file//. /_}"
done

Rename cmd:
#!/bin/bash

set -- *.*
for file; do
	mv -- "$file" "${file//. /_}"
done


############################### rename folders by removing everything before the first _ characater ########################
Dry Run:
rename -n 's/[^_]*[_]//' *

Rename cmd:
rename 's/[^_]*[_]//' *



################################REPLACE PERIOD IN WITH SPACE IN FOLDERS##############################################################
mv -- "$file = ${file//./ }"


##############################################################EPLACE PERIOD WITH SPACE IN FOLDERS (top level only):  ################
for i in *.*; do
    [ -d "$i" ] || continue
    echo "$i == ${i//./ }"
done

############################################################## REPLACE PERIOD WITH SPACE IN FOLDERS (top level only) ################
dir=/home/rtorrent/radarr
while IFS= read -r -d  '' dir; do
    echo "$dir = ${dir//./ }"
done < <(find . -maxdepth 1 -type d -name '*.*' -print0)
