#!/usr/bin/env python

import argparse
import sys
# import http.client
import json
import os
import subprocess
import psycopg2
import psycopg2.extras
from psycopg2 import sql
import uuid
from datetime import datetime

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
        # move_preaching = '\"INSERT INTO mediaitems (uuid, localizedname, path, language_id, presenter_name, source_material, track_number, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, updated_at, inserted_at, media_category) SELECT uuid, localizedname, path, language_id, presenter_name, source_material, track_number, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, updated_at, inserted_at, 4 FROM mediagospel WHERE path LIKE \'%preaching%\';\"'

        # os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, move_preaching))

    # addorgrows must be called AFTER migratefromwebsauna because the db has to migrated from the websauna/alembic schema and imported first
    # 
    # GETTING STARTED:
    # get preaching file paths with:
    # ./dbimport.py migratefromwebsauna ./2019-04-02-media-item-bin.pgsql faithful_word_dev
    # ./dbimport.py addorgrows faithful_word_dev
    # ./dbimport.py normalizepreaching faithful_word_dev mediaitems

    def addorgrows(self):
        parser = argparse.ArgumentParser(
            description='create orgs table and add rows')
        # prefixing the argument with -- means it's optional
        parser.add_argument('dbname')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])

        # generate ORGs and make a 'main' channel

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'kjvrvg\', \'kjvrvg\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Faithful Word Baptist Church, Tempe, AZ\', \'fwbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Verity Baptist Church, Sacramento, CA\', \'vbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Word of Truth Baptist Church\', \'wotbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Faith Baptist Church\', \'fbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Liberty Baptist Church\', \'lbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Faithful Word Baptist Church LA\', \'fwbcla\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Temple Baptist Church\', \'tbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Verity Baptist Vancouver\', \'vbcv\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Pillar Baptist Church\', \'pbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Mountain Baptist Church, Fairmont, WV\', \'mbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Old Paths Baptist Church, El Paso, TX\', \'opbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Stedfast Baptist Church Houston, TX\', \'sbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'All Scripture Baptist Church, Knoxville, TN\', \'asbc\', now(), now());\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO orgs (uuid, basename, shortname, updated_at, inserted_at) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'ibsa, USA\', \'ibsa\', now(), now());\"'))

        # add a 'main' channel for each org

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 1);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 2);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 3);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 4);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 5);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 6);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 7);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 8);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 9);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 10);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 11);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 12);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 13);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 14);\"'))

        os.system('\"/Applications/Postgres.app/Contents/Versions/11/bin/psql\" -U postgres -d {0} -c {1}'.format(args.dbname, '\"INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (md5(random()::text || clock_timestamp()::text)::uuid, \'Main\', now(), now(), 15);\"'))

    # normalizepreaching must be called AFTER addorgrows because orgs need to be present
    # 
    # GETTING STARTED:
    # get preaching file paths with:
    # ./dbimport.py migratefromwebsauna ./2019-04-02-media-item-bin.pgsql faithful_word_dev
    # ./dbimport.py addorgrows faithful_word_dev
    # ./dbimport.py normalizepreaching faithful_word_dev mediagospel

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

        preaching = []

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        # sourcecur = sourceconn.cursor()
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            # delete items with null paths
            deletequery = 'delete FROM mediagospel where path is NULL'.format(args.tablename)
            cur.execute(deletequery)

            # get array of org shortnames

            orgquery = 'select shortname from orgs'
            cur.execute(orgquery)
            orgs = []
            for row in cur:
                orgs.extend(row)
            print('orgs: {}'.format(orgs))

            sourcequery = 'SELECT * FROM {}'.format(args.tablename)
            cur.execute(sourcequery)
            # result = cur.fetchall()
            # print("result: {}".format(result))

            for row in cur:
                # records.append(row)
                # print(row['path'])

                ## get all preaching filenames and parse-out the date preached

                path_split = row['path'].split('/')
                if path_split[0] == 'preaching':
                    print('path_split: {}'.format(path_split))
                    
                    ## [2] is the filename leaf node
                    filename = path_split[2]
                    filename_split = filename.split('-')
                    print('filename_split: {}'.format(filename_split))

                    ## [0] is the org name, see if we have it already in the array
                    if filename_split[0].lower() in orgs:
                        print('found org: {}'.format(filename_split[0]))
                    
                        # if AM -> 10:00, if PM -> 19:00
                        assigned_time = '10:00' if filename_split[4] == 'AM' else '19:00'
                        preaching_date = datetime.strptime( '{}-{}-{} {}'.format(filename_split[1], filename_split[2], filename_split[3], assigned_time) , '%Y-%m-%d %H:%M')
                        print('preaching_date: {}'.format(preaching_date))

                        rowdict = {
                            'uuid': str(uuid.uuid4()),
                            'track_number': row['track_number'],
                            'medium': 'audio',
                            'localizedname': row['localizedname'],
                            'path': row['path'],
                            'small_thumbnail_path': row['small_thumbnail_path'],
                            'large_thumbnail_path': row['large_thumbnail_path'],
                            'content_provider_link': None,
                            'ipfs_link': None,
                            'language_id': row['language_id'],
                            'presenter_name': row['presenter_name'],
                            'source_material': row['source_material'],
                            'updated_at': datetime.now(),
                            'playlist_id': None,
                            'med_thumbnail_path': row['med_thumbnail_path'],
                            'tags': [],
                            'inserted_at': datetime.now(),
                            'media_category': 3,
                            'presented_at': preaching_date
                        }
                        preaching.append(rowdict)
                        # insertquery = 'INSERT INTO mediaitems(vendor_name) VALUES(%s)'
                        # cur.execute(insertquery)
            cur.close()
        print('preaching: {}'.format(preaching))

        # cur.execute("insert into mytable (jsondata) values (%s)", [Json({'a': 100})])

        with sourceconn.cursor() as cur:
            for row in preaching:
                cur.execute(sql.SQL("insert into mediaitems(uuid, track_number, medium, localizedname, path, small_thumbnail_path, large_thumbnail_path, content_provider_link, ipfs_link, language_id, presenter_name, source_material, updated_at, playlist_id, med_thumbnail_path, tags, inserted_at, media_category, presented_at) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"), 
                [row['uuid'], 
                row['track_number'], 
                row['medium'],
                row['localizedname'],
                row['path'],
                row['small_thumbnail_path'],
                row['large_thumbnail_path'],
                row['content_provider_link'],
                row['ipfs_link'],
                row['language_id'],
                row['presenter_name'],
                row['source_material'],
                row['updated_at'],
                row['playlist_id'],
                row['med_thumbnail_path'],
                row['tags'],
                row['inserted_at'],
                row['media_category'],
                row['presented_at']
                ])
                # cur.execute("insert into mediaitems(uuid, track_number, medium) values ({}, {}, {})".format(row['uuid'], row['track_number'], row['medium']))
            sourceconn.commit()




if __name__ == '__main__':
    Dbimport()


