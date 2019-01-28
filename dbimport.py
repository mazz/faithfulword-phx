#!/usr/bin/env python

import argparse
import sys
# import http.client
import json
import os
import subprocess

class Dbimport(object):
    def __init__(self):
        parser = argparse.ArgumentParser(
            description='stream a file to a streaming service',
            usage='''dbimport <pgsql file>

''')
        parser.add_argument('command', help='Subcommand to run')
        # parse_args defaults to [1:] for args, but you need to
        # exclude the rest of the args too, or validation will fail
        args = parser.parse_args(sys.argv[1:2])
        if not hasattr(self, args.command):
            print('Unrecognized command')
            parser.print_help()
            exit(1)
        # use dispatch pattern to invoke method with same name
        getattr(self, args.command)()

    def dbimport(self):
        parser = argparse.ArgumentParser(
            description='dbimport v1.3 pgsql file')
        # prefixing the argument with -- means it's optional
        parser.add_argument('pgfile')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])
        print('pgfile: {}'.format(repr(args.pgfile)))
        # psql -c "SELECT * FROM my_table"
        # mix ecto.drop; mix ecto.create ; mix ecto.migrate
        subprocess.call(['mix', 'ecto.drop'])
        subprocess.call(['mix', 'ecto.create'])
        subprocess.call(['mix', 'ecto.migrate'])

        subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', 'SET session_replication_role = replica;'])

        # os.system("psql -U postgres -d {0} -f {1}".format('faithful_word_dev', args.pgfile) )

        #import db
        os.system("pg_restore -U postgres --clean --dbname={0} {1}".format('faithful_word_dev', args.pgfile) )

        subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', 'SET session_replication_role = DEFAULT;'])

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format('faithful_word_dev', '\"INSERT INTO musictitles (uuid, localizedname, language_id, music_id) SELECT md5(random()::text || clock_timestamp()::text)::uuid, basename, \'en\', id from music;\"'))

if __name__ == '__main__':
    Dbimport()
