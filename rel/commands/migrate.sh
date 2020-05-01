#!/bin/sh

release_ctl eval --mfa "Db.ReleaseTasks.migrate/1" --argv -- "$@"
