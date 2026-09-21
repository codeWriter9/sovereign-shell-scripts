#!/bin/bash
# Usage: ./kill-port.sh [port_number]

PORT=${1:-8080}

PID=$(lsof -t -i:$PORT)

if [ -z "$PID" ]; then
  echo "No process running on port $PORT."
else
  echo "Killing process $PID running on port $PORT..."
  kill -9 $PID
  echo "Port $PORT freed."
fi