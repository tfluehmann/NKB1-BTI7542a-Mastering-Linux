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
  for filename in $dir*; do
    basename=$(basename $filename)
    printf "name: $basename - "
    echo $(head -n 1 ${filename})
  done
  show_entry
}

show_entry(){
  read -p "Enter number:" -r line
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
  if [ -z "$count" ]; then
    count=-1
  fi
  count="$(($count + 1))"
  echo $count > $counter_file
  echo $count
}

create_tag(){
  filename=$(next_number)
  # Enter file path, enter tag
  read -p "Enter filepath:" -r line
  echo "$path_desc $line"  >> ${dir}${filename}
  read -p "Enter tags (comma separated):" -r line
  echo "$tags_desc $line"  >> ${dir}${filename}
}


main() {

  init
  PS3='Please enter your choice: '
  options=("option 1" "option 2" "option 3" "option 4" "quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "option 1")
              echo "stored files:"
              list_files
              ;;
          "option 2")
              echo "create tag"
              create_tag
              ;;
          "option 3")
              echo "add tag"
              update
              ;;
          "option 4")
              echo "delete tag"
              ;;
          "quit")
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

main
