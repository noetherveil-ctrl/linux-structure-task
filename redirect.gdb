set $out = (int)creat("stdout.log", 0644)
set $err = (int)creat("stderr.log", 0644)
set $in = (int)open("/dev/null", 0)
if $out < 0 || $err < 0 || $in < 0
    quit 1
end
call (int)dup2($out, 1)
call (int)dup2($err, 2)
call (int)dup2($in, 0)
call (int)close($out)
call (int)close($err)
call (int)close($in)
detach
