#!/usr/bin/env python

import argparse
import sys
# import http.client
import json
import os
import subprocess
import psycopg2
import psycopg2.extras

class Dbimport(object):
    def __init__(self):
        parser = argparse.ArgumentParser(
            description='stream a file to a streaming service',
            usage='''dev|prod <pgsql file> <dbname>

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

    def migratefromwebsauna(self):
        parser = argparse.ArgumentParser(
            description='dbimport v1.3 pgsql file')
        # prefixing the argument with -- means it's optional
        parser.add_argument('pgfile')
        parser.add_argument('dbname')
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
        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/pg_restore\" -U postgres --clean --dbname={0} {1}'.format(args.dbname, args.pgfile) )

        subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', 'SET session_replication_role = DEFAULT;'])

        # os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format('faithful_word_dev', '\"INSERT INTO musictitles (uuid, localizedname, language_id, music_id) SELECT md5(random()::text || clock_timestamp()::text)::uuid, basename, \'en\', id from music;\"'))

        subprocess.call(['mix', 'ecto.migrate'])

        # add preaching to mediaitems
        move_preaching = '\"INSERT INTO mediaitems (uuid, localizedname, path, language_id, presenter_name, source_material, track_number, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, updated_at, inserted_at, media_category) SELECT uuid, localizedname, path, language_id, presenter_name, source_material, track_number, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, updated_at, inserted_at, 4 FROM mediagospel WHERE path LIKE \'%preaching%\';\"'

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, move_preaching))

    # normalizepreaching must be called AFTER migratefromwebsauna because the db has to migrated from the websauna/alembic schema and imported first
    # 
    # GETTING STARTED:
    # get preaching file paths with:
    # ./dbimport.py migratefromwebsauna ./2019-02-22-add-v12-api-bin-export.sql faithful_word_dev
    # ./dbimport.py normalizepreaching faithful_word_dev mediaitems
    
    def normalizepreaching(self):
        parser = argparse.ArgumentParser(
            description='dbimport v1.3 pgsql file')
        # prefixing the argument with -- means it's optional

        parser.add_argument('dbname')
        parser.add_argument('tablename')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])
        print('dbname: {}'.format(repr(args.dbname)))
        print('tablename: {}'.format(repr(args.tablename)))

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        # sourcecur = sourceconn.cursor()
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:
            sourcequery = 'SELECT * FROM {}'.format(args.tablename)
            cur.execute(sourcequery)
            # result = cur.fetchall()
            # print("result: {}".format(result))
            for row in cur:
                # records.append(row)
                print(row['path'])
                # print('row: {}\n'.format(row))
            cur.close()


if __name__ == '__main__':
    Dbimport()


