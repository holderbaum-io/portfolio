#!/bin/bash

set -eu

ensure_venv() {
  if [ ! -d venv ]; then
    virtualenv -p "$(which python3)" venv
    ./venv/bin/pip install weasyprint
  fi

  if [ requirements.txt -nt venv ]; then
    ./venv/bin/pip install weasyprint
    touch ./venv
  fi
}

task_usage() {
  echo "usage: $0 build | watch"
  exit 1
}

task_build() {
  ensure_venv

  ./venv/bin/weasyprint invoice.html invoice.pdf
}

task_watch() {
  ensure_venv

  task_build

  while inotifywait ./*.html ./*.css;
  do
    task_build
  done
}

cmd="${1:-}"
shift || true
case "$cmd" in
  build) task_build ;;
  watch) task_watch ;;
  *) task_usage ;;
esac
