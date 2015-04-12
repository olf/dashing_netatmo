Description
===========

A [Dashing](https://github.com/Shopify/dashing) widget to display readings from your [NetAtmo](https://www.netatmo.com) Personal Weather Station (PWS).

Dependencies
============

You need an account and Weather Station from [NetAtmo](https://www.netatmo.com).

You also need to register an own app at [NetAtmo Developer](https://dev.netatmo.com) to get access to all readings from your PWS.

Add to dashing's gemfile:
```
gem 'curb'
gem 'json'
```
and run `bundle install`.

Usage
============

Update your settings in config/netatmo.yml

Add the widget HTML to your dashboard
```
    <li data-row="1" data-col="5" data-sizex="1" data-sizey="5">
      <div data-id="netatmo" data-view="Netatmo"></div>
    </li>
```
