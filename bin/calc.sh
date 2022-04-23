echo "Enter program name found in test directory: "
read name
path="../test/"
directory="$path$name"
ruby load.rb $directory