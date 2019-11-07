#!/bin/sh

release_ctl eval --mfa "Db.ReleaseTasks.seed/1" --argv -- "$@"
