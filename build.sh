#!/bin/bash
# Usage: ./springboot-run.sh [dev|local|test]

PROFILE=${1:-local}

echo "=== Packaging Spring Boot App (Profile: $PROFILE) ==="
mvn clean package -DskipTests -T 1C

if [ $? -eq 0 ]; then
  echo "=== Launching Application ==="
  java -jar target/*.jar --spring.profiles.active=$PROFILE
else
  echo "Build failed! Aborting run."
  exit 1
fi