#! /bin/bash
# Team: Matthias Sidler, Dominic Messmer, Tobias Flühmann
dir=~/.file-tagger/
counter_file=${dir}counter
tags_desc='tags:'
path_desc='path:'

init() {
  mkdir -p $dir
}

list_files() {
  file_count=$(ls $dir | wc -l)
  if [ "$file_count" -eq "0" ]; then echo "no tagged files found"; return; fi
  for filename in $dir*; do
    basename=$(basename $filename)
    printf "name: $basename - "
    echo $(head -n 1 ${filename})
  done
}

show_entry(){
  read -p "Enter number: " -r line
  path=${dir}${line}
  file_path=$(head -n 1 $path)
  tags=$(tail -n 1 $path)
  echo "$file_path" 
  echo "$tags" 
}

# Read numbers from $dir and increase by one
next_number(){
  $(touch $counter_file)
  count=$(cat $counter_file)
  if [ -z "$count" ]; then count=-1; fi
  count="$(($count + 1))"
  echo $count > $counter_file
  echo $count
}

create_tag(){
  filename=$(next_number)
  # Enter file path, enter tag
  read -p "Enter filepath: " -r line
  echo "$path_desc $line"  >> ${dir}${filename}
  read -p "Enter tags (comma separated): " -r line
  echo "$tags_desc $line"  >> ${dir}${filename}
}

# so in dem stil:
# printf ", $tag" >> $file_path
update_tag(){
  read -p "Enter number:" -r line
  file_path=${dir}${line}
  read -p "Enter new tag: " -r tag
  printf ", $tag" >> $file_path
}

# tbd
delete_tag(){
sleep 0.1
}

delete_entry(){
  read -p "Enter number:" -r line
  file_path=${dir}${line}
  rm $file_path
}

main() {

  init
  PS3='Please enter your choice: '
  options=("option 1" "option 2" "option 3" "option 4" "option 5" "quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "option 1")
              echo "stored files:"
              list_files
              show_entry
              ;;
          "option 2")
              echo "create tag"
              create_tag
              ;;
          "option 3")
              echo "add tag"
              list_files
              update_tag
              ;;
          "option 4")
              echo "delete tag"
              delete_tag
              ;;
          "option 5")
              echo "delete entry"
              list_files
              delete_entry
              ;;
          "quit")
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

main
