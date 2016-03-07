deploy with Capistrano
======================

1. удаляем из репозитория конфигурационные файлы
------------------------------------------------

**помещаем в `.gitignor`, если они еще не там:**

    config/database.yml
    config/private_pub.yml

**делаем копии файлов (к примеру с расширением `.sample`), если их еще нет:**

    cp config/private_pub.yml config/private_pub.yml.sample
    cp config/database.yml config/database.yml.sample

**удаляем из репозитория оригинальные файлы:**

    git rm config/private_pub.yml
    git rm config/database.yml

**пушим в репозиторий:**

    git add .
    git commit -m "rm from repository: config/private_pub.yml, ... "

**сливаем ветку в `master`, пушим на `GitHub`**


2. подключаем Capistrano
------------------------

**добавляем в `Gemfile` в группу `development`:**

    group :development do

      ......

      gem 'capistrano', require: false
      gem 'capistrano-bundler', require: false
      gem 'capistrano-rails', require: false
      gem 'capistrano-rvm', require: false
    end

**и запускаем `bundle` ...**

**после установки гемов стартуем:**

    cap install

**в рабочей директории добавляются файлы:**

- deploy.rb
- config/deploy/production.rb
- config/deploy/staging.rb
- Capfile
- lib/capistrano/tasks

**редактируем `Capfile`, добавляем библиотеки, которые не нужны при запуске "рельс" (и мы их отметили `require: false`), но нужны при запуске `Capistrano`:**

    require 'capistrano/rvm'
    require 'capistrano/bundler'
    require 'capistrano/rails'

**переходим к файлу `deploy.rb`, который является "основным скриптом деплоя" и редактируем**

1. *меняем имя приложения, например:*

        set :application, 'qna'

2. *указываем адрес репозитория в формате SSH)*

        set :repo_url, 'git@example.com:me/my_repo.git'

3. *разкомментируем и меняем `deploy_to`, например:*

        set :deploy_to, '/home/deployer/qna'

4. *добавляем после `deploy_to` переменную пользователя от которого будет происходить деплой:*

        set :deploy_user, 'deployer'

5. *разкомментируем и редактируем переменную* `linked_files`

        set :linked_files, fetch(:linked_files, [])
          .push('config/database.yml', 'config/private_pub.yml')

6. *разкомментируем строку с переменной* `linked_dirs`

        set :linked_dirs, fetch(:linked_dirs, [])
          .push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

7. *остальные закомментированные переменные можно удалить (или оставить закомментированными)*
8. *приводим `namespace :deploy` блок к виду:*

        namespace :deploy do
          desc 'Restart application'
          task :restart do
            on roles(:app), in: :sequence, wait: 5 do
              execute :touch, release_path.join('tmp/restart.txt')
            end
          end

          after :publishing, :restart
        end

**теперь редактируем `config/deploy/production.rb`**

1. *задаем роли сервера, (указываем своего пользователя и свой домен), например:*

        role :app, %w{deployer@82.196.4.197}
        role :web, %w{deployer@82.196.4.197}
        role :db,  %w{deployer@82.196.4.197}

        set :rails_env, :production

2. *задаем "праймари сервер" (указываем своего пользователя и свой домен)*

        server '82.196.4.197', user: 'deployer', roles: %w{app db web}, primary: true

3. *конфигурируем опции для SSH (путь к ключу зависит от ОС, ниже для убунту):*

        set :ssh_options, {
          keys: %w(/home/user_name/.ssh/id_rsa),
          forward_agent: true,
          auth_methods: %w(publickey password)
        }


3. проверяем наличия всего необходимого для деплоя на сервере
-------------------------------------------------------------

можно посмотреть все команды доступные для `Capistrano` вызвав в консоли

        cap -T

**для проверки готовности сервера к деплою воспользуемся командой:**

        cap production deploy:check

если порт для коннекта был изменен, то она вернет ошибку и надо будет добавить в `ssh_options` строчку с указанием порта, например:

        port: 4321

теперь снова запускаем

        cap production deploy:check

если ранее не добавить файл, то здесь вернется ошибка

            ERROR linked file /home/deployer/qna/shared/config/database.yml does not exist

**подключаемся консолью к серверу и добавляем файл `database.yml`**

1. *переходим в директорию `qna/shared/config`*
2. *открываем новый файл в редакторе: `nano database.yml`*
3. *добавляем в файл код:*

        production:
          adapter: postgresql
          encoding: unicode
          database: qna_production
          user: postgres
          password: 'some_password'
          pool: 20

4. *сохраняем, закрываем*

**добавляем аналогичным образом в ту же папку `private_pub.yml`**
код берем из локального `private_pub.yml.sample`, раздела `production`
заменяем `example.com` на наш `IP`, желательно изменить `secret_token`
пример кода:

        production:
          server: "http://example.com/faye"
          secret_token: "643d087cce8b92ebdb32ffeb3313c40d845cf8bac04d0ae1f36cf744be76c56d"
          signature_expiration: 3600 # one hour


**вспоминаем про  файл `secrets.yml`**
перед тем как его создать на сервере добавляем новые гемы в `Gemfile`

        gem 'dotenv'
        gem 'dotenv-deployment', require: 'dotenv/deployment'

(запускаем `bundle`)

**возвращаемся к файлу `deploy.rb` и добавляем в список "линкованных" файлов `.env`**

1. *создаем этот файл (`.env`) на сервере в `qna/shared`*
2. *генерируем `secret` в директории своего проекта терминальной командой `rake secret`*
3. *присваиваем полученное значение переменной `SECRET_KEY_BASE` в файле `.env`*
4. *добавляем в файл переменные для соцсетей*

        FACEBOOK_APP_ID=
        FACEBOOK_APP_SECRET=
        ......
        ......

4. *сохраняем, закрываем*

**приводим локальный файл `secrets.yml` в разделе `production` к виду:**

        production:
          secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
          facebook_app_id: <%= ENV["FACEBOOK_APP_ID"] %>
          facebook_app_secret: <%= ENV["FACEBOOK_APP_SECRET"] %>
          twitter_app_id: <%= ENV["TWITTER_APP_ID"] %>
          twitter_app_secret: <%= ENV["TWITTER_APP_SECRET"] %>

(для своего набора соцсетей)

**добаляем обновленные файлы `Gemfile, Gemfile.lock, secrets.yml` в `git` и пушим на `GitHub`, чтобы при деплое с репозитория забирался уже обновленные файлы**

**еще раз запускаем**

        cap production deploy:check

все должно пройти без ошибок

4. деплой
---------

**запускаем в консоли (из локальной директории приложения)**

        cap production deploy

в процессе установки на сервер гемов может появиться ошибка связанная с `mysql2`

        DEBUG [f53f2ac3]  An error occurred while installing mysql2 (0.4.3), and Bundler cannot continue.
        Make sure that `gem install mysql2 -v '0.4.3'` succeeds before bundling.

нужно доустановить на сервер недостающую библиотеку

        sudo apt-get install libmysqlclient-dev

снова запускаем 

        cap production deploy

есил возникает ошибка связанная с `JAVA` машиной, добавляем в `Gemfile` гем `therubyracer`, запускаем бандл, добавляем `Gemfile` в `git` и на `GitHub`

еще раз запускаем 

        cap production deploy

выскакивает ошибка

        DEBUG [cf0a8dbc]  rake aborted!
        DEBUG [cf0a8dbc]  PG::ConnectionBad: FATAL:  Peer authentication failed for user "postgres"

**нужно отредактировать файл конфигурации `PostgreSQL`**

1. *на сервере `sudo nano etc/postgresql/9.3./main/pg_hba.conf`*
2. *в конце файла конфигурации в табличке заменить все `peer` на `md5`*
3. *сохранить и выйти*
4. *запустить в командной строке: `sudo service postgresql restart`*

**вспоминаем, что еще нужно создать БД** и идем консоль `PG`:

        sudo -u postgres psql
        Password: 
        psql (9.3.11)
        Type "help" for help.

        postgres=# CREATE DATABASE qna_production;
        CREATE DATABASE
        postgres=# \q

**запускаем**

        cap production deploy

и все должно пройти успешно, и можно посмотреть приложение по его адресу в броузере

5. запуск фоновых процессов
---------------------------

**запускаем `sidekiq`**

1. *устанавливаем гем `gem 'capistrano-sidekiq', require: false` в группу `development`*
2. *в `Capfile` добавляем `require 'capistrano/sidekiq'`*
3. *в файл `config/deploy/production.rb` добавляем строку`set :stage, :production`*

здесь нужно не забыть запусить бандлер

**добавляем на сервере директорию для загрузки изображений**
в `deploy.rb` дописываем к прилинкованным директориям (linked_dirs) `public/uploads`

снова

        cap production deploy

в логе можно увидеть строки, подтверждающие успешный запуск `sidekiq`:

    INFO [1536907e] Running ~/.rvm/bin/rvm default do bundle exec sidekiq --index 0 --pidfile /home/deployer/qna/shared/tmp/pids/sidekiq-0.pid --environment production --logfile /home/deployer/qna/shared/log/sidekiq.log --daemon as deployer@82.196.4.197
    DEBUG [1536907e] Command: cd /home/deployer/qna/releases/20160306142845 && ~/.rvm/bin/rvm default do bundle exec sidekiq --index 0 --pidfile /home/deployer/qna/shared/tmp/pids/sidekiq-0.pid --environment production --logfile /home/deployer/qna/shared/log/sidekiq.log --daemon

**для работы `Sphinx` необходимо чтобы он был запущен в фоне, а также нужно регулярное обновление индексов**

1. *если еще не установлен гем `whenever`, то прописываем его в `Gemfile` (бандл) и, чтобы создался файл расписания, запускаем*

        wheneverize .

2. *в расписание (`config/schedule.rb`) добавляем задачу обновления индекса, к примеру:*

        every 60.minutes do
          rake "ts:index"
        end

3. *добавляем в `git` файлы `Gemfile, Gemfile.lock, config/schedule.rb`, пушим на `GitHub`*
4. *в `Capfile` пишем*

        require 'whenever/capistrano'

"деплоим" изменения

        cap production deploy

**`PrivatePub`**

1. *в список `linked_files` (`deploy.rb`) добавляем `config/private_pub_thin.yml`*
2. *создаем этот файл на сервере в папке `shared`, со следующим содержимым:*

        ---
        port: 9292
        environment: production
        rackup: private_pub.ru
        daemonize: true

3. *редактируем файл `private_pub.yml` на сервере: нужно добавить порт (9292) в строке указываеющей на сервер `faye`, к примеру:*

          server: "http://example.com:9292/faye"

4. *в `deploy.rb` пишем кастомные задачи для `Capistrano`, чтобы он мог пускать `PrivatePub` (в нашем случае три задачи: старт, стоп, рестарт)*

        namespace :private_pub do
          desc 'Start private_pub server'
          task :start do
            on roles(:app) do
              within current_path do
                with rails_env: fetch(:rails_env) do
                  execute :bundle, "exec thin -C config/private_pub_thin.yml start"
                end
              end
            end
          end

          desc 'Stop private_pub server'
          task :stop do
            on roles(:app) do
              within current_path do
                with rails_env: fetch(:rails_env) do
                  execute :bundle, "exec thin -C config/private_pub_thin.yml stop"
                end
              end
            end
          end

          desc 'Restart private_pub server'
          task :restart do
            on roles(:app) do
              within current_path do
                with rails_env: fetch(:rails_env) do
                  execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
                end
              end
            end
          end
        end

5. *запускаем (или перезапускаем, т.е. `restart` вместо `start`) `PrivatePub`*

        cap production private_pub:start

   *сервер должен доложить, что `private_pub` запущен (если возвращается ошибка о том, что не получается найти `config/private_pub_thin.yml`, должно помочь `cap production deploy`, после чего повторяем запуск/перезапуск `PrivatePub`)*

6. добавляем в конце `deploy.rb` команду для перезапуска `PrivatePub` после завершения деплоя:

        after 'deploy:restart', 'private_pub:restart'

7. проверяем работу последнего добавленного хука:

        cap production deploy

все должно работать!