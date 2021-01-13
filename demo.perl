use 5.24.0;
use utf8;
use strict;
use warnings;
#s/被替换的/要替换为/ 默认一次
#s\被替换的/要替换的/g 可多次 跟m// 一样可以换为m{} 绑定变量也是
#用=～
#@aaa = split/拆分的/，被拆分的
#join ”“，@y 与split相反
#全局m 一个变量会储存到数组  两个变量会储存到哈希




BEGIN{
    $SIG{__DIE__}=sub{
        my $error = shift;
        say "catch a error: $error";
        die $error;
    };
}
END{
    
}

