# Долгоиграющий процесс

Запуск на сервере:

```bash
chmod +x alive.sh
nohup ./alive.sh >stdout.log 2>stderr.log < /dev/null &
echo $! > alive.pid
exit
```

При закрытии SSH-сессии оболочка может получить SIGHUP и передать его
своим заданиям. `nohup` устанавливает игнорирование SIGHUP, которое
наследует скрипт. `&` запускает его в фоне, а перенаправления отсоединяют
его от терминала. Вход берётся из `/dev/null`.

После повторного входа:

```bash
ps -p "$(cat alive.pid)" -o pid,ppid,stat,etime,args
tail -f stdout.log stderr.log
```

`tail -f` показывает новые строки без остановки процесса. Пустой
`stderr.log` означает, что скрипт ничего не записал в stderr.
Ctrl+C завершает `tail`, а скрипт продолжает работать.

После проверки:

```bash
kill "$(cat alive.pid)"
```

Переподключение и проверка записаны в `process.cast`.
Вывод процесса сохранён в `stdout.log` и `stderr.log`.
