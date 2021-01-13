perl -e 'print "hello,world\n"'
perl -ne '{chomp;print "$_\n";}' test.txt
perl -e 's/scaffold_//' test.txt
perl -p -e 's/scaffold_//' test.txt
perl -p -i -e 's/scaffold_//' test.txt
perl -pie 's/\r\n/\n/g' test.txt
perl -pie 's/\n/\r\n/g' test.txt
perl -lane 'print "@F[0..4] $F[6]"' text.txt
perl -F: -lane 'print "@F[0..4]\n"' /etc/passwd
perl -ne 'print if /^START$/ .. /^END$/' file
perl -ne 'print unless /^START$/ .. /^END$/' file
perl -pe 'exit if $. > 50' file
perl -ne 'print if 15 .. 17' file
perl -lne 'print substr($_, 0, 80) = ""' file
perl -ne 'print if /comment/' file
perl -ne 'print unless /comment/' file
perl -ne 'print if /comment/ || /apple/' file
perl -e 'print sort <>' file
perl -00 -e 'print sort <>' file
perl -0777 -e 'print sort <>' file1 file2
perl -e 'print reverse <>' file1
