#! /bin/bash
# Team: Matthias Sidler, Dominic Messmer, Tobias Flühmann
DIR="~/.file-tagger/"
init() {
  mkdir -p $DIR
}

list_files() {
  files=`ls ~/.file-tagger/`
  echo $files
  PS3="Please select a file to show tags"
  read -p "Input Selection:" -r line
  path=${DIR}${line}
  file=$(cat $path)
  echo $file 
}

create_tag(){
# Enter file path, enter tag
sleep 0.1
}

main() {

  init
  PS3='Please enter your choice: '
  options=("option 1" "option 2" "option 3" "quit")
  select opt in "${options[@]}"
  do
      case $opt in
          "option 1")
              echo "stored files:"
              list_files
              ;;
          "option 2")
              echo "delete tag"
              ;;
          "option 3")
              echo "you chose choice $REPLY which is $opt"
              ;;
          "quit")
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

main
