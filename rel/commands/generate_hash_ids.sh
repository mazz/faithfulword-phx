#!/bin/sh

release_ctl eval --mfa "Db.ReleaseTasks.generate_hash_ids/1" --argv -- "$@"
