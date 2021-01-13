@array =(1..10);
print "@array\n";
@array_sort =sort sort @array;
print "@array_sort\n";
@array_reverse = reverse @array;
print "@array_reverse";
$aaa = join ':', @array;
print "$aaa"
