# Динамический веб

Домашнее задание:

Варианты стенда:

nginx + php-fpm (laravel/wordpress) + python (flask/django) + js(react/angular);

nginx + java (tomcat/jetty/netty) + go + ruby;

можно свои комбинации.

Реализации на выбор:

на хостовой системе через конфиги в /etc;

деплой через docker-compose.

Для усложнения можно попросить проекты у коллег с курсов по разработке

К сдаче принимается:

vagrant стэнд с проброшенными на локалхост портами

каждый порт на свой сайт

через нжинкс Формат сдачи ДЗ - vagrant + ansible


# Выполнение

Состав стенда:  php-fpm (laravel), uwsgi (django), nodejs (react).

Ансиблом устанавливаются:

nginx

php с необходимыми модулями, php-fpm, laravel

python с необходимыми модулями, uwsgi, django

nodejs

В nodejs создаено приложение, возвращающее Hello World, в laravel и django - их дефолтные страницы.

В nginx создано три сайта на разных портах. 8001 - laravel, 8002 - uwsgi, 8003 - nodejs.

Результаты выполнения в скриншотах:

https://github.com/hataldir/otus-linux/blob/master/lesson27/screen8001.jpg

https://github.com/hataldir/otus-linux/blob/master/lesson27/screen8002.jpg

https://github.com/hataldir/otus-linux/blob/master/lesson27/screen8003.jpg
