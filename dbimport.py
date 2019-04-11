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

        self.addorgrows()
    def addorgrows(self):
        # parser = argparse.ArgumentParser(
        #     description='create orgs table and add rows')
        # parser.add_argument('dbname')
        # args = parser.parse_args(sys.argv[2:])

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
        {'basename': 'All Scripture Baptist Church, Knoxville, TN', 'shortname': 'asbc'},
        {'basename': 'ibsa, USA', 'shortname': 'ibsa'},
        {'basename': 'Stedfast Baptist Church Houston, TX', 'shortname': 'sbc'}
        ]
        # generate ORGs and make a 'main' channel
        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format('faithful_word_dev'))
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
                for channel_name in ['Preaching', 'Music', 'Gospel', 'Documentaries']: # 1-based index, not 0
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

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))

        # get all the gospel categories because they contain the 
        # preaching categories
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            joinedgospelquery = 'select * from gospel'
            cur.execute(joinedgospelquery)
            for gospel in cur:
                print('gospel: {}'.format(gospel))
                # print('basename: {}'.format(gospel['basename']))
                playlists = []
                playlisttitles = []

                with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as gospeltitlecur:
                # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

                    gospeltitlequery = 'select * from gospeltitles where gospeltitles.gospel_id = {}'.format(gospel['id'])
                    gospeltitlecur.execute(gospeltitlequery)
                    for gospeltitle in gospeltitlecur:
                        print('gospeltitle; {}'.format(gospeltitle))
                        playlisttitledict = {
                            'uuid': str(uuid.uuid4()),
                            # 'playlist_id': gospeltitle['']
                            'localizedname': gospeltitle['localizedname'],
                            'language_id': gospeltitle['language_id'],
                            'inserted_at': datetime.datetime.now(),
                            'updated_at': datetime.datetime.now()
                            }

                        playlisttitles.append(playlisttitledict)

                # set the channel id based on basename title

                channel_id = None
                media_category = None
                if gospel['basename'] == 'Plan of Salvation' or gospel['basename'] == 'Soul-winning Motivation' or gospel['basename'] == 'Soul-winning Tutorials' or gospel['basename'] == 'Soul-winning Sermons' or gospel['basename'] == 'आत्मिक जीत स्पष्टीकरण':
                        channel_id = 3
                        media_category = 1
                if gospel['basename'] == 'Word of Truth Baptist Church Sermons' or gospel['basename'] == 'FWBC Sermons' or gospel['basename'] == 'Faith Baptist Church Louisiana Sermons' or gospel['basename'] == 'Verity Baptist Church Sermons' or gospel['basename'] == 'Old Path Baptist Church Sermons' or gospel['basename'] == 'Liberty Baptist Church Sermons' or gospel['basename'] == 'Faithful Word Baptist Church LA' or gospel['basename'] == 'Temple Baptist Church Sermons' or gospel['basename'] == 'Sean Jolley Spanish' or gospel['basename'] == 'ASBC' or gospel['basename'] == 'Entire Bible Preached Project' or gospel['basename'] == 'Pillar Baptist Church' or gospel['basename'] == 'Iglesia Bautista de Santa Ana' or gospel['basename'] == 'FWBC Espanol' or gospel['basename'] == 'Win Your Wife\'s Heart by Jack Hyles' or gospel['basename'] == 'Justice by Jack Hyles' or gospel['basename'] == 'Verity Baptist Vancouver (Preaching)' or gospel['basename'] == 'Stedfast Baptist Church' or gospel['basename'] == 'Post Trib Bible Prophecy Conference' or gospel['basename'] == 'Mountain Baptist Church':
                        channel_id = 1
                        media_category = 3
                if gospel['basename'] == 'Documentaries':
                    channel_id = 4
                    media_category = 4

                if channel_id != None:
                    playlistdict = {
                        'ordinal': gospel['absolute_id'],
                        'uuid': str(uuid.uuid4()),
                        'basename': gospel['basename'],
                        'media_category': media_category,
                        # 'language_id': gospel['language_id'],
                        'small_thumbnail_path': None,
                        'med_thumbnail_path': None,
                        'large_thumbnail_path': None,
                        'banner_path': None,
                        'channel_id': channel_id,
                        'updated_at': datetime.datetime.now(),
                        'inserted_at': datetime.datetime.now()
                    }

                    # add playlist to corresponding channel
                    print('playlistdict: {}'.format(playlistdict))
    
                    playlists.append(playlistdict)

                    # store this playlist along with all its titles

                    # store the playlist
                    playlistuuid = str(uuid.uuid4())
                    with sourceconn.cursor() as storeplaylistcur:
                        storeplaylistcur.execute(sql.SQL("insert into playlists(ordinal, uuid, basename, media_category, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, banner_path, channel_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s, %s ,%s ,%s ,%s ,%s)"), 
                        [playlistdict['ordinal'],
                        playlistuuid, 
                        playlistdict['basename'],
                        playlistdict['media_category'],
                        # playlistdict['language_id'],
                        playlistdict['small_thumbnail_path'],
                        playlistdict['med_thumbnail_path'],
                        playlistdict['large_thumbnail_path'],
                        playlistdict['banner_path'],
                        playlistdict['channel_id'],
                        datetime.datetime.now(),
                        datetime.datetime.now()
                        ])

                        sourceconn.commit()

                    # find the playlist we just added and add the playlisttitles to it by uuid

                    with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as findplaylistcur:
                        findplaylistquery = 'select * from playlists where uuid = \'{}\''.format(playlistuuid)
                        findplaylistcur.execute(findplaylistquery)
                        for playlist in findplaylistcur:
                            print('playlist: {}'.format(playlist))
                            for playlisttitle in playlisttitles:
                                playlisttitle['playlist_id'] = playlist['id']

                    # store the playlisttitles with the playlist_id we found
                    with sourceconn.cursor() as storeplaylisttitlecur:
                        for playlisttitle in playlisttitles:
                            print('playlisttitle: {}'.format(playlisttitle))
                            storeplaylisttitlecur.execute(sql.SQL("insert into playlist_titles(uuid, localizedname, language_id, playlist_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s)"), 
                            [playlisttitle['uuid'], 
                            playlisttitle['localizedname'],
                            playlisttitle['language_id'],
                            # playlisttitle['language_id'],
                            playlisttitle['playlist_id'],
                            datetime.datetime.now(),
                            datetime.datetime.now()
                            ])

                            sourceconn.commit()

    def convertv12musictoplaylists(self):
        parser = argparse.ArgumentParser(
            description='add v1.2 playlists')
        # prefixing the argument with -- means it's optional
        parser.add_argument('dbname')
        # parser.add_argument('livestream_url')
        # now that we're inside a subcommand, ignore the first
        # TWO argvs, ie the command (git) and the subcommand (commit)
        args = parser.parse_args(sys.argv[2:])

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))

        # get all the music categories because they contain the 
        # preaching categories
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            joinedmusicquery = 'select * from music'
            cur.execute(joinedmusicquery)
            for music in cur:
                print('music: {}'.format(music))
                # print('basename: {}'.format(music['basename']))
                playlists = []
                playlisttitles = []

                with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as musictitlecur:
                # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

                    musictitlequery = 'select * from musictitles where musictitles.music_id = {}'.format(music['id'])
                    musictitlecur.execute(musictitlequery)
                    for musictitle in musictitlecur:
                        print('musictitle; {}'.format(musictitle))
                        playlisttitledict = {
                            'uuid': str(uuid.uuid4()),
                            # 'playlist_id': musictitle['']
                            'localizedname': musictitle['localizedname'],
                            'language_id': musictitle['language_id'],
                            'inserted_at': datetime.datetime.now(),
                            'updated_at': datetime.datetime.now()
                            }

                        playlisttitles.append(playlisttitledict)

                # set the channel id based on basename title

                channel_id = 2
                media_category = 2

                playlistdict = {
                    'ordinal': music['absolute_id'],
                    'uuid': str(uuid.uuid4()),
                    'basename': music['basename'],
                    'media_category': media_category,
                    # 'language_id': music['language_id'],
                    'small_thumbnail_path': None,
                    'med_thumbnail_path': None,
                    'large_thumbnail_path': None,
                    'banner_path': None,
                    'channel_id': channel_id,
                    'updated_at': datetime.datetime.now(),
                    'inserted_at': datetime.datetime.now()
                }

                # add playlist to corresponding channel
                print('playlistdict: {}'.format(playlistdict))

                playlists.append(playlistdict)

                # store this playlist along with all its titles

                # store the playlist
                playlistuuid = str(uuid.uuid4())
                with sourceconn.cursor() as storeplaylistcur:
                    storeplaylistcur.execute(sql.SQL("insert into playlists(ordinal, uuid, basename, media_category, small_thumbnail_path, med_thumbnail_path, large_thumbnail_path, banner_path, channel_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s, %s ,%s ,%s ,%s ,%s)"), 
                    [playlistdict['ordinal'],
                    playlistuuid, 
                    playlistdict['basename'],
                    playlistdict['media_category'],
                    # playlistdict['language_id'],
                    playlistdict['small_thumbnail_path'],
                    playlistdict['med_thumbnail_path'],
                    playlistdict['large_thumbnail_path'],
                    playlistdict['banner_path'],
                    playlistdict['channel_id'],
                    datetime.datetime.now(),
                    datetime.datetime.now()
                    ])

                    sourceconn.commit()

                # find the playlist we just added and add the playlisttitles to it by uuid

                with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as findplaylistcur:
                    findplaylistquery = 'select * from playlists where uuid = \'{}\''.format(playlistuuid)
                    findplaylistcur.execute(findplaylistquery)
                    for playlist in findplaylistcur:
                        print('playlist: {}'.format(playlist))
                        for playlisttitle in playlisttitles:
                            playlisttitle['playlist_id'] = playlist['id']

                # store the playlisttitles with the playlist_id we found
                with sourceconn.cursor() as storeplaylisttitlecur:
                    for playlisttitle in playlisttitles:
                        print('playlisttitle: {}'.format(playlisttitle))
                        storeplaylisttitlecur.execute(sql.SQL("insert into playlist_titles(uuid, localizedname, language_id, playlist_id, inserted_at, updated_at) values (%s, %s, %s, %s, %s, %s)"), 
                        [playlisttitle['uuid'], 
                        playlisttitle['localizedname'],
                        playlisttitle['language_id'],
                        # playlisttitle['language_id'],
                        playlisttitle['playlist_id'],
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

        soulwinningsermons = []

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
        
        # print('soulwinningsermons: {}'.format(soulwinningsermons))
        
        
        self._insertmediaitemrows(self._preachingrows(5, 'Soul-winning Sermons', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(6, 'FWBC Sermons', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(7, 'Verity Baptist Church Sermons', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(9, 'Word of Truth Baptist Church Sermons', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(10, 'Faith Baptist Church Louisiana Sermons', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(12, 'Old Path Baptist Church Sermons', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(14, 'Liberty Baptist Church Sermons', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(15, 'Faithful Word Baptist Church LA', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(17, 'Temple Baptist Church Sermons', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(19, 'Verity Baptist Vancouver (Preaching)', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(21, 'Sean Jolley Spanish', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(22, 'FWBC Espanol', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(23, 'Documentaries', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(24, 'Post Trib Bible Prophecy Conference', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(25, 'आत्मिक जीत स्पष्टीकरण', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(26, 'ASBC', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(27, 'Entire Bible Preached Project', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(28, 'Iglesia Bautista de Santa Ana', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(29, 'Pillar Baptist Church', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(30, 'Mountain Baptist Church', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(31, 'Win Your Wife\'s Heart by Jack Hyles', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(32, 'Justice by Jack Hyles', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(33, 'Stedfast Baptist Church', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(23, 'Documentaries', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(23, 'Documentaries', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(23, 'Documentaries', args.dbname), args.dbname)
        self._insertmediaitemrows(self._preachingrows(23, 'Documentaries', args.dbname), args.dbname)

            # sourcequery = 'SELECT * FROM mediagospel where gospel_id = 5'
            # soulwinningsermonscur.execute(sourcequery)
            # for row in soulwinningsermonscur:
            #     # records.append(row)
            #     print('row: {}'.format(row))

            #     path_split = row['path'].split('/')
            #     if path_split[0] == 'preaching':
            #         # print('path_split: {}'.format(path_split))
            #         with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
            #             found_playlist_id = False
            #             playlist_id = None

            #             ## [2] is the filename leaf node
            #             filename = path_split[2]
            #             filename_split = filename.split('-')
            #             # print('filename_split: {}'.format(filename_split))

            #             playlistquery = 'SELECT * from playlists where basename = \'Soul-winning Sermons\''
            #             if playlistquery != None: 
            #                 playlistcur.execute(playlistquery)
            #                 playlist = playlistcur.fetchone()
            #                 if playlist is not None:
            #                     print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
            #                     playlist_id = playlist['id']
            #                     found_playlist_id = True

            #         # if AM -> 10:00, if PM -> 19:00
            #         assigned_time = '10:00' if filename_split[4] == 'AM' else '19:00'
            #         preaching_date = datetime.datetime.strptime( '{}-{}-{} {}'.format(filename_split[1], filename_split[2], filename_split[3], assigned_time) , '%Y-%m-%d %H:%M')
            #         # print('preaching_date: {}'.format(preaching_date))
            #     else:
            #         preaching_date = datetime.datetime.now() - datetime.timedelta(days=3*365)
            #         if playlistquery != None: 
            #             playlistcur.execute(playlistquery)
            #             playlist = playlistcur.fetchone()
            #             if playlist is not None:
            #                 print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
            #                 playlist_id = playlist['id']
            #                 found_playlist_id = True
            #     rowdict = {
            #         'uuid': str(uuid.uuid4()),
            #         'track_number': row['track_number'],
            #         'medium': 'audio',
            #         'localizedname': row['localizedname'],
            #         'path': row['path'],
            #         'small_thumbnail_path': row['small_thumbnail_path'],
            #         'large_thumbnail_path': row['large_thumbnail_path'],
            #         'content_provider_link': None,
            #         'ipfs_link': None,
            #         'language_id': row['language_id'],
            #         'presenter_name': row['presenter_name'],
            #         'source_material': row['source_material'],
            #         'updated_at': datetime.datetime.now(),
            #         'playlist_id': playlist_id if found_playlist_id else None,
            #         'med_thumbnail_path': row['med_thumbnail_path'],
            #         'tags': [],
            #         'inserted_at': datetime.datetime.now(),
            #         'media_category': 3,
            #         'presented_at': preaching_date,
            #         'org_id': 1
            #     }
            #     print("rowdict: {}".format(rowdict))
                # soulwinningsermons.append(rowdict)


            # result = cur.fetchall()
            # print("result: {}".format(result))

            # for row in cur:
            #     # records.append(row)
            #     print('row: {}'.format(row))

            #     ## get all preaching filenames and parse-out the date preached

            #     path_split = row['path'].split('/')
            #     if path_split[0] == 'preaching':
            #         # print('path_split: {}'.format(path_split))
            #         with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
            #             found_playlist_id = False
            #             playlist_id = None

            #             ## [2] is the filename leaf node
            #             filename = path_split[2]
            #             filename_split = filename.split('-')
            #             # print('filename_split: {}'.format(filename_split))

            #             ## [0] is the org name, see if we have it already in the array
            #             org = filename_split[0].lower()
            #             ## [0] is the org name, see if we have it already in the array
            #             if org in orgs:
            #                 # print('found org: {}'.format(filename_split[0]))
            #                 if org == 'fwbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'FWBC Sermons\''
            #                 elif org == 'vbcv':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Verity Baptist Vancouver (Preaching)\''
            #                 elif org == 'asbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'ASBC\''
            #                 elif org == 'fbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Faith Baptist Church Louisiana Sermons\''
            #                 elif org == 'fwbcla':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Faithful Word Baptist Church LA\''
            #                 elif org == 'ibsa':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Iglesia Bautista de Santa Ana\''
            #                 elif org == 'lbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Liberty Baptist Church Sermons\''
            #                 elif org == 'mbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Mountain Baptist Church\''
            #                 elif org == 'opbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Old Path Baptist Church Sermons\''
            #                 elif org == 'pbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Pillar Baptist Church\''
            #                 elif org == 'sbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Stedfast Baptist Church\''
            #                 elif org == 'tbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Temple Baptist Church Sermons\''
            #                 elif org == 'vbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Verity Baptist Church Sermons\''
            #                 elif org == 'wotbc':
            #                     playlistquery = 'SELECT * from playlists where basename = \'Word of Truth Baptist Church Sermons\''
            #                 else:
            #                     playlistquery = None

            #                 if playlistquery != None: 
            #                     playlistcur.execute(playlistquery)
            #                     playlist = playlistcur.fetchone()
            #                     if playlist is not None:
            #                         print('found org: {} basename: {} playlist: {}'.format(org, playlist['basename'], playlist))
            #                         playlist_id = playlist['id']
            #                         found_playlist_id = True

            #                 # if AM -> 10:00, if PM -> 19:00
            #                 assigned_time = '10:00' if filename_split[4] == 'AM' else '19:00'
            #                 preaching_date = datetime.datetime.strptime( '{}-{}-{} {}'.format(filename_split[1], filename_split[2], filename_split[3], assigned_time) , '%Y-%m-%d %H:%M')
            #                 # print('preaching_date: {}'.format(preaching_date))

            #             else:
            #                 preaching_date = datetime.datetime.now() - datetime.timedelta(days=3*365)

            #                 if playlistquery != None: 
            #                     playlistcur.execute(playlistquery)
            #                     playlist = playlistcur.fetchone()
            #                     if playlist is not None:
            #                         print('found org: {} basename: {} playlist: {}'.format(org, playlist['basename'], playlist))
            #                         playlist_id = playlist['id']
            #                         found_playlist_id = True
            #                 # preaching_date = datetime.strptime( '{}-{}-{} {}'.format(filename_split[1], filename_split[2], filename_split[3], assigned_time) , '%Y-%m-%d %H:%M')

            #                 # print('path_split: {}'.format(path_split))

            #             rowdict = {
            #                 'uuid': str(uuid.uuid4()),
            #                 'track_number': row['track_number'],
            #                 'medium': 'audio',
            #                 'localizedname': row['localizedname'],
            #                 'path': row['path'],
            #                 'small_thumbnail_path': row['small_thumbnail_path'],
            #                 'large_thumbnail_path': row['large_thumbnail_path'],
            #                 'content_provider_link': None,
            #                 'ipfs_link': None,
            #                 'language_id': row['language_id'],
            #                 'presenter_name': row['presenter_name'],
            #                 'source_material': row['source_material'],
            #                 'updated_at': datetime.datetime.now(),
            #                 'playlist_id': playlist_id if found_playlist_id else None,
            #                 'med_thumbnail_path': row['med_thumbnail_path'],
            #                 'tags': [],
            #                 'inserted_at': datetime.datetime.now(),
            #                 'media_category': 3,
            #                 'presented_at': preaching_date,
            #                 'org_id': 1
            #             }
            #             preaching.append(rowdict)
            #                 # insertquery = 'INSERT INTO mediaitems(vendor_name) VALUES(%s)'
            #                 # cur.execute(insertquery)

            # cur.close()
        # print('preaching: {}'.format(preaching))

        # with sourceconn.cursor() as cur:
        #     for row in preaching:
        #         cur.execute(sql.SQL("insert into mediaitems(uuid, track_number, medium, localizedname, path, small_thumbnail_path, large_thumbnail_path, content_provider_link, ipfs_link, language_id, presenter_name, source_material, updated_at, playlist_id, med_thumbnail_path, tags, inserted_at, media_category, presented_at, org_id) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"), 
        #         [row['uuid'], 
        #         row['track_number'], 
        #         row['medium'],
        #         row['localizedname'],
        #         row['path'],
        #         row['small_thumbnail_path'],
        #         row['large_thumbnail_path'],
        #         row['content_provider_link'],
        #         row['ipfs_link'],
        #         row['language_id'],
        #         row['presenter_name'],
        #         row['source_material'],
        #         row['updated_at'],
        #         row['playlist_id'],
        #         row['med_thumbnail_path'],
        #         row['tags'],
        #         row['inserted_at'],
        #         row['media_category'],
        #         row['presented_at'],
        #         row['org_id']
        #         ])
        #         # cur.execute("insert into mediaitems(uuid, track_number, medium) values ({}, {}, {})".format(row['uuid'], row['track_number'], row['medium']))
        #     sourceconn.commit()

    def _preachingrows(self, gospelid, playlistname, dbname):
        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(dbname))
        # sourcecur = sourceconn.cursor()

        result = []
        preaching_date = None
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
        # with sourceconn(cursor_factory=psycopg2.extras.DictCursor) as cur:

            # delete items with null paths
            # deletequery = 'delete FROM mediagospel where path is NULL'
            # cur.execute(deletequery)

            # # get array of org shortnames

            orgquery = 'select shortname from orgs'
            cur.execute(orgquery)
            orgs = []
            for row in cur:
                orgs.extend(row)
            print('orgs: {}'.format(orgs))

            with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                found_playlist_id = False
                playlist_id = None
                playlistcur.execute(sql.SQL('SELECT * from playlists where basename = %s'), [playlistname])
                # playlistquery = 'SELECT * from playlists where basename = \'{}\''.format(playlistname)
                # if playlistquery != None: 

                # playlistcur.execute(playlistquery)
                playlist = playlistcur.fetchone()
                if playlist is not None:
                    print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
                    playlist_id = playlist['id']
                    found_playlist_id = True

                    sourcequery = 'SELECT * FROM mediagospel where gospel_id = {}'.format(gospelid)
                    cur.execute(sourcequery)
                    for row in cur:
                        # records.append(row)
                        print('row: {}'.format(row))

                        path_split = row['path'].split('/')
                        if path_split[0] == 'preaching':
                            # print('path_split: {}'.format(path_split))
                            # with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                                # found_playlist_id = False
                                # playlist_id = None

                                ## [2] is the filename leaf node
                            filename = path_split[2]
                            filename_split = filename.split('-')
                                # print('filename_split: {}'.format(filename_split))

                                # playlistquery = 'SELECT * from playlists where basename = \'{}\''.format(playlistname)
                                # if playlistquery != None: 
                                #     playlistcur.execute(playlistquery)
                                #     playlist = playlistcur.fetchone()
                                #     if playlist is not None:
                                #         print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
                                #         playlist_id = playlist['id']
                                #         found_playlist_id = True
                            org = filename_split[0].lower()
                            if org in orgs:
                                # if AM -> 10:00, if PM -> 19:00
                                assigned_time = '10:00' if filename_split[4] == 'AM' else '19:00'
                                preaching_date = datetime.datetime.strptime( '{}-{}-{} {}'.format(filename_split[1], filename_split[2], filename_split[3], assigned_time) , '%Y-%m-%d %H:%M')
                            # print('preaching_date: {}'.format(preaching_date))
                            else:
                                preaching_date = datetime.datetime.now() - datetime.timedelta(days=3*365)
                            # if playlistquery != None: 
                            #     playlistcur.execute(playlistquery)
                            #     playlist = playlistcur.fetchone()
                            #     if playlist is not None:
                            #         print('found basename: {} playlist: {}'.format(playlist['basename'], playlist))
                            #         playlist_id = playlist['id']
                            #         found_playlist_id = True
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
                            'playlist_id': playlist_id if found_playlist_id else None,
                            'med_thumbnail_path': row['med_thumbnail_path'],
                            'tags': [],
                            'inserted_at': datetime.datetime.now(),
                            'media_category': 3,
                            'presented_at': datetime.datetime.now() - datetime.timedelta(days=3*365) if preaching_date is None else preaching_date,
                            'org_id': 1
                        }
                        print("rowdict: {}".format(rowdict))
                        result.append(rowdict)
        return result

    def _insertmediaitemrows(self, rows, dbname):
        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(dbname))

        with sourceconn.cursor() as cur:
            for row in rows:
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

    def normalizegospel(self):
        parser = argparse.ArgumentParser(
            description='dbimport v1.3 pgsql file')
        # prefixing the argument with -- means it's optional

        parser.add_argument('dbname')

        args = parser.parse_args(sys.argv[2:])
        print('dbname: {}'.format(repr(args.dbname)))

        planofsalvation = []
        soulwinningmotivation = []
        soulwinningtutorials = []
        # documentaries = []

        sourceconn = psycopg2.connect("host=localhost dbname={} user=postgres".format(args.dbname))
        with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
            # delete items with null paths
            deletequery = 'delete FROM mediagospel where path is NULL'
            cur.execute(deletequery)

            sourcequery = 'SELECT * FROM mediagospel'
            cur.execute(sourcequery)
            # result = cur.fetchall()
            # print("result: {}".format(result))

            for row in cur:
                # print('row: {}'.format(row))
                path_split = row['path'].split('/')
                if path_split[0] == 'gospel':
                    print('path_split: {}'.format(path_split))
                    with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                        found_playlist_id = False
                        playlist_id = None

                        ## [2] is the filename leaf node
                        filename = path_split[2]
                        filename_split = filename.split('-')
                        print('filename_split: {}'.format(filename_split))

                        if filename_split[0] == 'BibleWayToHeaven':

                            playlistquery = 'SELECT * from playlists where basename = \'Plan of Salvation\''

                            playlistcur.execute(playlistquery)
                            playlist = playlistcur.fetchone()
                            if playlist is not None:
                                print('playlist: {}'.format(playlist))
                                playlist_id = playlist['id']
                                found_playlist_id = True

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
                                    'playlist_id': playlist_id if found_playlist_id else None,
                                    'med_thumbnail_path': row['med_thumbnail_path'],
                                    'tags': [],
                                    'inserted_at': datetime.datetime.now(),
                                    'media_category': 1,
                                    'presented_at': None,
                                    'org_id': 1
                                }
                                planofsalvation.append(rowdict)

                elif path_split[0] == 'motivation':
                    print('path_split: {}'.format(path_split))
                    with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                        found_playlist_id = False
                        playlist_id = None

                        playlistquery = 'SELECT * from playlists where basename = \'Soul-winning Motivation\''

                        playlistcur.execute(playlistquery)
                        playlist = playlistcur.fetchone()
                        if playlist is not None:
                            print('playlist: {}'.format(playlist))
                            playlist_id = playlist['id']
                            found_playlist_id = True

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
                                'playlist_id': playlist_id if found_playlist_id else None,
                                'med_thumbnail_path': row['med_thumbnail_path'],
                                'tags': [],
                                'inserted_at': datetime.datetime.now(),
                                'media_category': 1,
                                'presented_at': None,
                                'org_id': 1
                            }
                            soulwinningmotivation.append(rowdict)

                elif path_split[0] == 'tutorials':
                    print('path_split: {}'.format(path_split))
                    with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                        found_playlist_id = False
                        playlist_id = None

                        playlistquery = 'SELECT * from playlists where basename = \'Soul-winning Tutorials\''

                        playlistcur.execute(playlistquery)
                        playlist = playlistcur.fetchone()
                        if playlist is not None:
                            print('playlist: {}'.format(playlist))
                            playlist_id = playlist['id']
                            found_playlist_id = True

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
                                'playlist_id': playlist_id if found_playlist_id else None,
                                'med_thumbnail_path': row['med_thumbnail_path'],
                                'tags': [],
                                'inserted_at': datetime.datetime.now(),
                                'media_category': 1,
                                'presented_at': None,
                                'org_id': 1
                            }
                            soulwinningtutorials.append(rowdict)
                # elif path_split[0] == 'movies':
                #     print('path_split: {}'.format(path_split))
                #     with sourceconn.cursor(cursor_factory=psycopg2.extras.DictCursor) as playlistcur:
                #         found_playlist_id = False
                #         playlist_id = None

                #         playlistquery = 'SELECT * from playlists where basename = \'Documentaries\''

                #         playlistcur.execute(playlistquery)
                #         playlist = playlistcur.fetchone()
                #         if playlist is not None:
                #             print('playlist: {}'.format(playlist))
                #             playlist_id = playlist['id']
                #             found_playlist_id = True

                #             rowdict = {
                #                 'uuid': str(uuid.uuid4()),
                #                 'track_number': row['track_number'],
                #                 'medium': 'audio',
                #                 'localizedname': row['localizedname'],
                #                 'path': row['path'],
                #                 'small_thumbnail_path': row['small_thumbnail_path'],
                #                 'large_thumbnail_path': row['large_thumbnail_path'],
                #                 'content_provider_link': None,
                #                 'ipfs_link': None,
                #                 'language_id': row['language_id'],
                #                 'presenter_name': row['presenter_name'],
                #                 'source_material': row['source_material'],
                #                 'updated_at': datetime.datetime.now(),
                #                 'playlist_id': playlist_id if found_playlist_id else None,
                #                 'med_thumbnail_path': row['med_thumbnail_path'],
                #                 'tags': [],
                #                 'inserted_at': datetime.datetime.now(),
                #                 'media_category': 1,
                #                 'presented_at': None,
                #                 'org_id': 1
                #             }
                #             documentaries.append(rowdict)
            cur.close()

        with sourceconn.cursor() as cur:
            for row in planofsalvation:
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
        with sourceconn.cursor() as cur:
            for row in soulwinningmotivation:
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
        with sourceconn.cursor() as cur:
            for row in soulwinningtutorials:
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
        # with sourceconn.cursor() as cur:
        #     for row in documentaries:
        #         cur.execute(sql.SQL("insert into mediaitems(uuid, track_number, medium, localizedname, path, small_thumbnail_path, large_thumbnail_path, content_provider_link, ipfs_link, language_id, presenter_name, source_material, updated_at, playlist_id, med_thumbnail_path, tags, inserted_at, media_category, presented_at, org_id) values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"), 
        #         [row['uuid'], 
        #         row['track_number'], 
        #         row['medium'],
        #         row['localizedname'],
        #         row['path'],
        #         row['small_thumbnail_path'],
        #         row['large_thumbnail_path'],
        #         row['content_provider_link'],
        #         row['ipfs_link'],
        #         row['language_id'],
        #         row['presenter_name'],
        #         row['source_material'],
        #         row['updated_at'],
        #         row['playlist_id'],
        #         row['med_thumbnail_path'],
        #         row['tags'],
        #         row['inserted_at'],
        #         row['media_category'],
        #         row['presented_at'],
        #         row['org_id']
        #         ])
        #         # cur.execute("insert into mediaitems(uuid, track_number, medium) values ({}, {}, {})".format(row['uuid'], row['track_number'], row['medium']))
        #     sourceconn.commit()  


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


