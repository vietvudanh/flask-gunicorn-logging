# Logging with flask-gunicorn-logging

`flask` use `logging`, but `gunicorn` also has its own loggers and handlers.

This project demonstrate how to intergrate those two.

# Problems

## Rotate

`gunicorn` recommended using [`logrotate`](http://docs.gunicorn.org/en/latest/install.html?highlight=logrotate#debian-gnu-linux) instead of logging default rotate handers.

## Split to smaller files

Normally I would put each level in its own log. So, how? Maybe `logstash` later? Usually log would be inserted into `Elasticsearch` for analyze, monitoring anyway.

@vietvu