deploy with capistrano
======================

удаляем из репозитория конфигурационные файлы
---------------------------------------------

помещаем в `.gitignor`, если они еще не там:

- config/database.yml
- config/private_pub.yml

делаем копии файлов (к примеру с расширением `.sample`), если их еще нет:

- cp config/private_pub.yml config/private_pub.yml.sample
- cp config/database.yml config/database.yml.sample

удаляем из репозитория оригинальные файлы:

- git rm config/private_pub.yml
- git rm config/database.yml

пушим в репозиторий:

    git add .
    git commit -m "rm from repository: config/private_pub.yml, ... "

сливаем ветку в `master`




`secrets.yml`
