#! /bin/bash
# Group10: Matthias Sidler, Dominic Messmer, Tobias Flühmann

dir=~/.file-tagger/ # project dir and file
db=${dir}db
separator='{//}'

# list all files, which have a tag
list_files() {
  if [ "$(cat $db | wc -l)" -eq "0" ]; then echo "no tagged files found"; return 1; fi
  cat $db | awk -v sep=$separator '{split($0,a,sep); print a[2]}' | nl
}

# search for a specific tag and print out files, which have this tag
search_tag() {
  read -p "Enter tag: " -r tag
  results=$(grep -w -E "^\{//\}.*\{//\}($tag|$tag,.*|.*,$tag,.*|.*,$tag)\$" $db | awk -v sep={//} '{split($0,a,sep); print a[2]}')
  echo $results
}

# print out all tags of a specific file
show_entry(){
  read -p "Enter number: " -r LINE
  sed "${LINE}q;d" $db | awk -v sep=$separator '{split($0,a,sep); printf "\nFile %s\nTags %s\n", a[2], a[3]}'
}

# creates or updates the tags of a file
create_tag(){
  read -p "Enter filepath: " -r path
  read -p "Enter tags (comma separated): " -r tags
  if [ "$(grep $separator$path$separator $db | wc -l)" -eq "0" ]; then # there is no entry
    new_tags=$(echo $tags | tr , '\n' | sort -n | tr '\n' ,)
    echo $separator$path$separator${new_tags::-1} >> $db
    sort -n -o $db $db
  else # update entry
    old_entry=$(grep $separator$path$separator $db)
    old_tags=$(echo $old_entry | awk -v sep=$separator '{split($0,a,sep); print a[3]}')
    if [ "$(echo $old_tags | grep -w $tags | wc -l)" -eq "0" ]; then
      new_tags=$(echo $old_tags,$tags | tr , '\n' | sort -n | tr '\n' ,)
      sed -i -e "s@$old_entry@$separator$path$separator${new_tags::-1}@g" $db
    else
      echo "File has already this tag!"
    fi
  fi
}

# delete a tag or a whole entry
delete_tag(){
  read -p "Enter filepath: " -r path
  old_entry=$(grep $separator$path$separator $db)
  old_tags=$(echo $old_entry | awk -v sep=$separator '{split($0,a,sep); print a[3]}')
  echo "Current Tags: $old_tags"
  read -p "Enter tag (empty to delete entry): " -r tags
  if [ -z "$tags" ]; then # delete entry
    sed -i "/${separator//\//\\/}${path//\//\\/}${separator//\//\\/}/d" $db
  else # delete tag
    new_tags=$(echo $old_tags | sed "s@$tags@@" | sed "s@,,@,@" | sed 's@,$@@')
    sed -i -e "s@$old_entry@$separator$path$separator$new_tags@g" $db
  fi
}

main() {
  mkdir -p $dir
  $(touch $db)
  clear
  while true; do
    PS3='Please enter your choice: '
    options=("List Tags" "Search File" "Create/Add Tags" "Delete Tags" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "List Tags")
              printf "\nSelect File\n"
              if list_files; then show_entry; fi
              ;;
            "Search File")
                printf "\nSearch File\n"
                search_tag
                ;;
            "Create/Add Tags")
                printf "\nCreate/Add Tags\n"
                create_tag
                ;;
            "Delete Tags")
                printf "\nDelete Tags\n"
                delete_tag
                ;;
            "Quit")
                echo "bye!"
                exit
                ;;
            *) echo "invalid option $REPLY. Please enter a valid number.";;
        esac
        echo ""
        break
    done
  done
}

main
