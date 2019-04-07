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
import datetime

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

        orgs = [{'basename': 'faithfulwordapp', 'shortname': 'faithfulwordapp'},
        {'basename': 'Faithful Word Baptist Church, Tempe, AZ', 'shortname': 'fwbc'},
        {'basename': 'Verity Baptist Church, Sacramento, CA', 'shortname': 'vbc'},
        {'basename': 'Word of Truth Baptist Church', 'shortname': 'wotbc'},
        {'basename': 'Faith Baptist Church', 'shortname': 'fbc'},
        {'basename': 'Liberty Baptist Church', 'shortname': 'lbc'},
        {'basename': 'Faithful Word Baptist Church LA', 'shortname': 'fwbcla'},
        {'basename': 'Temple Baptist Church', 'shortname': 'tbc'},
        {'basename': 'Verity Baptist Vancouver', 'shortname': 'vbcv'},
        {'basename': 'Pillar Baptist Church', 'shortname': 'pbc'},
        {'basename': 'Mountain Baptist Church, Fairmont, WV', 'shortname': 'mbc'},
        {'basename': 'Old Paths Baptist Church, El Paso, TX', 'shortname': 'opbc'},
        {'basename': 'Stedfast Baptist Church Houston, TX', 'shortname': 'sbc'},
        {'basename': 'All Scripture Baptist Church, Knoxville, TN', 'shortname': 'asbc'},
        {'basename': 'ibsa, USA', 'shortname': 'ibsa'},
        {'basename': 'Stedfast Baptist Church Houston, TX', 'shortname': 'sbc'}
        ]
        # generate ORGs and make a 'main' channel
        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        with sourceconn.cursor() as cur:
            for org in orgs:
                cur.execute(sql.SQL("insert into orgs(uuid, basename, shortname, updated_at, inserted_at) values (%s, %s, %s, %s, %s)"), 
                [str(uuid.uuid4()), 
                org['basename'], 
                org['shortname'],
                datetime.datetime.now(),
                datetime.datetime.now()
                ])

                sourceconn.commit()

        # add a 'Preaching', 'Music', 'Gospel' channel for each org

        with sourceconn.cursor() as cur:
            # get array of org ids
            orgquery = 'select id from orgs'
            cur.execute(orgquery)
            org_ids = []
            for row in cur:
                org_ids.extend(row)
            print('org_ids: {}'.format(org_ids))

            for org_id in org_ids:
                for channel_name in ['Preaching', 'Music', 'Gospel', 'Documentaries']:
                    cur.execute(sql.SQL("INSERT INTO channels (uuid, basename, updated_at, inserted_at, org_id) VALUES (%s, %s, %s, %s, %s)"), 
                    [str(uuid.uuid4()), 
                    channel_name, 
                    datetime.datetime.now(),
                    datetime.datetime.now(),
                    org_id
                    ])

                    sourceconn.commit()

    def convertv12gospeltoplaylists(self):
        parser = argparse.ArgumentParser(
            description='add v1.2 playlists')
        # prefixing the argument with -- means it's optional
        parser.add_argument('dbname')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])

        playlists = []

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))

        # get all the gospel categories because they contain the 
        # preaching categories
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:


            joinedgospelquery = 'select * from gospeltitles inner join gospel on gospeltitles.gospel_id = gospel.id'
            cur.execute(joinedgospelquery)
            for row in cur:
                # print('row: {}'.format(row))
                print('basename: {}'.format(row['basename']))
                
                # set the channel id based on basename title

                channel_id = 0
                if row['basename'] == 'Plan of Salvation' or row['basename'] == 'Soul-winning Motivation' or row['basename'] == 'Soul-winning Tutorials' or row['basename'] == 'Soul-winning Sermons' or row['basename'] == 'आत्मिक जीत स्पष्टीकरण':
                        channel_id = 3
                if row['basename'] == 'Word of Truth Baptist Church Sermons' or row['basename'] == 'FWBC Sermons' or row['basename'] == 'Faith Baptist Church Louisiana Sermons' or row['basename'] == 'Verity Baptist Church Sermons' or row['basename'] == 'Old Path Baptist Church Sermons' or row['basename'] == 'Liberty Baptist Church Sermons' or row['basename'] == 'Faithful Word Baptist Church LA' or row['basename'] == 'Temple Baptist Church Sermons' or row['basename'] == 'Sean Jolley Spanish' or row['basename'] == 'ASBC' or row['basename'] == 'Entire Bible Preached Project' or row['basename'] == 'Pillar Baptist Church' or row['basename'] == 'Iglesia Bautista de Santa Ana' or row['basename'] == 'FWBC Espanol' or row['basename'] == 'Win Your Wife\'s Heart by Jack Hyles' or row['basename'] == 'Justice by Jack Hyles' or row['basename'] == 'Verity Baptist Vancouver (Preaching)' or row['basename'] == 'Stedfast Baptist Church':
                        channel_id = 1
                if row['basename'] == 'Documentaries':
                    channel_id = 4

                if channel_id != 0:
                    rowdict = {
                        'ordinal': row['absolute_id'],
                        'uuid': str(uuid.uuid4()),
                        'localizedname': row['localizedname'],
                        'language_id': row['language_id'],
                        'small_thumbnail_path': None,
                        'med_thumbnail_path': None,
                        'large_thumbnail_path': None,
                        'banner_path': None,
                        'channel_id': channel_id,
                        'updated_at': datetime.datetime.now(),
                        'inserted_at': datetime.datetime.now()
                    }

                    # add playlist to corresponding channel
                    print('channel_id: {}'.format(channel_id))
    
                    # if channel_id == 1:
                    #     preaching.append(rowdict)
                    # if channel_id == 3:
                    #     gospel.append(rowdict)
                    # if channel_id == 4:
                    #     documentaries.append(rowdict)

                    playlists.append(rowdict)
            # print("preaching: {}".format(preaching))
            # print("gospel: {}".format(gospel))
            # print("documentaries: {}".format(documentaries))



            # result = cur.fetchall()
            # print("preaching: {}".format(preaching))
            # print("gospel: {}".format(preaching))
            # print("documentaries: {}".format(preaching))

        # generate playlists using the v1.2 categories and assign them
        # to the faithfulwordapp org

        # sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))

        with sourceconn.cursor() as cur:
            for playlist in playlists:
                cur.execute(sql.SQL("insert into playlists(ordinal, uuid, localizedname, language_id, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, banner_path, channel_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s ,%s ,%s ,%s ,%s ,%s)"), 
                [playlist['ordinal'],
                str(uuid.uuid4()), 
                playlist['localizedname'],
                playlist['language_id'],
                playlist['small_thumbnail_path'],
                playlist['med_thumbnail_path'],
                playlist['large_thumbnail_path'],
                playlist['banner_path'],
                playlist['channel_id'],
                datetime.datetime.now(),
                datetime.datetime.now()
                ])

                sourceconn.commit()




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
        # parser.add_argument('tablename')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])
        print('dbname: {}'.format(repr(args.dbname)))
        # print('tablename: {}'.format(repr(args.tablename)))

        preaching = []

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        # sourcecur = sourceconn.cursor()
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            # delete items with null paths
            deletequery = 'delete FROM mediagospel where path is NULL'
            cur.execute(deletequery)

            # get array of org shortnames

            orgquery = 'select shortname from orgs'
            cur.execute(orgquery)
            orgs = []
            for row in cur:
                orgs.extend(row)
            print('orgs: {}'.format(orgs))

            sourcequery = 'SELECT * FROM mediagospel'
            cur.execute(sourcequery)
            # result = cur.fetchall()
            # print("result: {}".format(result))

            for row in cur:
                # records.append(row)
                print('row: {}'.format(row))

                ## get all preaching filenames and parse-out the date preached

                path_split = row['path'].split('/')
                if path_split[0] == 'preaching':
                    # print('path_split: {}'.format(path_split))
                    
                    ## [2] is the filename leaf node
                    filename = path_split[2]
                    filename_split = filename.split('-')
                    # print('filename_split: {}'.format(filename_split))

                    ## [0] is the org name, see if we have it already in the array
                    if filename_split[0].lower() in orgs:
                        # print('found org: {}'.format(filename_split[0]))
                    
                        # if AM -> 10:00, if PM -> 19:00
                        assigned_time = '10:00' if filename_split[4] == 'AM' else '19:00'
                        preaching_date = datetime.datetime.strptime( '{}-{}-{} {}'.format(filename_split[1], filename_split[2], filename_split[3], assigned_time) , '%Y-%m-%d %H:%M')
                        # print('preaching_date: {}'.format(preaching_date))

                    else:
                        preaching_date = datetime.datetime.now() - datetime.timedelta(days=3*365)
                        # preaching_date = datetime.strptime( '{}-{}-{} {}'.format(filename_split[1], filename_split[2], filename_split[3], assigned_time) , '%Y-%m-%d %H:%M')

                        # print('path_split: {}'.format(path_split))

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
                        'updated_at': datetime.datetime.now(),
                        'playlist_id': None,
                        'med_thumbnail_path': row['med_thumbnail_path'],
                        'tags': [],
                        'inserted_at': datetime.datetime.now(),
                        'media_category': 3,
                        'presented_at': preaching_date,
                        'org_id': 1
                    }
                    preaching.append(rowdict)
                        # insertquery = 'INSERT INTO mediaitems(vendor_name) VALUES(%s)'
                        # cur.execute(insertquery)

            cur.close()
        # print('preaching: {}'.format(preaching))

        with sourceconn.cursor() as cur:
            for row in preaching:
                cur.execute(sql.SQL("insert into mediaitems(uuid, track_number, medium, localizedname, path, small_thumbnail_path, large_thumbnail_path, content_provider_link, ipfs_link, language_id, presenter_name, source_material, updated_at, playlist_id, med_thumbnail_path, tags, inserted_at, media_category, presented_at, org_id) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"), 
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
                row['presented_at'],
                row['org_id']
                ])
                # cur.execute("insert into mediaitems(uuid, track_number, medium) values ({}, {}, {})".format(row['uuid'], row['track_number'], row['medium']))
            sourceconn.commit()


    # normalizepreaching must be called AFTER addorgrows because orgs need to be present
    # 
    # GETTING STARTED:
    # get preaching file paths with:
    # ./dbimport.py migratefromwebsauna ./2019-04-02-media-item-bin.pgsql faithful_word_dev
    # ./dbimport.py addorgrows faithful_word_dev
    # ./dbimport.py normalizepreaching faithful_word_dev mediagospel

    def normalizemusic(self):
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
                print(row['path'])


if __name__ == '__main__':
    Dbimport()


