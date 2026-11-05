# Долгоиграющий процесс

На Ubuntu установил `gdb`. Сначала запустил скрипт как обычную команду:

```bash
chmod +x alive.sh
shopt -s huponexit
./alive.sh
```

Нажал Ctrl+Z и продолжил тот же процесс в фоне:

```bash
bg
pid=$(jobs -p %+)
echo "$pid" > alive.pid
disown -h "$pid"
ls -l /proc/"$pid"/fd/{0,1,2}
sudo gdb -q -nx -batch -p "$pid" -x redirect.gdb
ls -l /proc/"$pid"/fd/{0,1,2}
exit
```

`disown -h` говорит Bash не пересылать этому заданию `SIGHUP` при
закрытии сессии. GDB подключается к уже запущенному процессу. Команды
в `redirect.gdb` открывают файлы в его рабочем каталоге и через `dup2`
заменяют дескрипторы 1 и 2. Дескриптор 0 теперь указывает на `/dev/null`.
В конце GDB отсоединяется, PID остаётся прежним.

После повторного входа:

```bash
pid=$(cat alive.pid)
ps -p "$pid" -o pid,ppid,stat,etime,args
tail -f stdout.log stderr.log
```

В `process.cast` видны запуск и смена дескрипторов, в `reconnect.cast` —
тот же PID и новые строки в логе после повторного входа. `stderr.log`
пустой, потому что скрипт ничего не пишет в stderr. Ctrl+C останавливает
только `tail`. По окончании проверки процесс можно остановить `kill "$pid"`.
