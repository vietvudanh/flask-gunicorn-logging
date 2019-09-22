#!/usr/bin/env bash
CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# START vars
LOG_FILE="$CWD/log.log"
NUM_WORKER=3
PORT=5000
TIMEOUT=60
APP_WSGI=app:app
OUTPUT=nohup.out
API_PID=API_PI

export APP_SETTINGS=DevConfig
# END vars

# virtualenv
DIR_VENV=$(ls | grep env)
if [[ ! -z $DIR_ENV ]]; then
  . ./$DIR_ENV/bin/activate
  echo "activate virtualenv"
fi

# START functions declare
function usage {
  echo "$(basename $0), params: [$(echo $LIST_FUNCS)]"
}

function log {
  echo "$(date)  $1" | tee -a $LOG_FILE
}

function check {
  ps aux | grep gunicorn | grep $APP_WSGI
}

function install {
  python -m pip install -r requirements.txt
}

function clean {
  rm logs/*
}

function start {
  gunicorn \
    --workers=$NUM_WORKER \
    --bind=0.0.0.0:$PORT \
    --timeout=$TIMEOUT \
    --access-logfile $CWD/logs/gunicorn-access.log \
    --access-logformat '%(h)s %(l)s %(u)s %(t)s "%(r)s" %(s)s %(b)s "%(f)s" "%(a)s" "%(L)s"' \
    --error-logfile $CWD/logs/gunicorn-error.log \
    --log-level=DEBUG \
    --daemon \
    $APP_WSGI

  if [[ ! "$?" -eq "0" ]]; then
    echo 'error'
    cat $OUTPUT
  else
    echo $! >$API_PID
    echo "Process ID $(cat $API_PID)"
  fi
}

function stop {
  check | awk '{print $2}' | xargs -L1 kill -9
}

function restart {
  stop
  start
}

function load_test {
  hey -n 5 -c 5 \
    http://localhost:$PORT/
}

# define custom functions here

LIST_FUNCS=$(declare -F | cut -d ' ' -f3 | sed 's/usage\|log//')
# END functions declare

# main body
case $# in
1) # i just need one parmas
  if [[ -n $(echo "$LIST_FUNCS" | xargs -n1 echo | grep -e "^$1$") ]]; then
    echo "'$1' match"
    echo "run \`$1\`"
    type $1
    $1
  else
    echo "'$1' not match"
    usage
  fi
  ;;
*)
  usage
  ;;
esac
