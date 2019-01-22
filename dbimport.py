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

        subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', '\c faithful_word_dev'])

        subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', '\c faithful_word_dev'])

        subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', 'SET session_replication_role = replica;'])

        os.system("psql -U postgres -d {0} -f {1}".format('faithful_word_dev', args.pgfile) )

        subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', 'SET session_replication_role = DEFAULT;'])

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE appversion RENAME TO appversions;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE book RENAME TO books;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE booktitle RENAME TO booktitles;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE channel RENAME TO channels;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE chapter RENAME TO chapters;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE church RENAME TO churches;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE clientdevice RENAME TO clientdevices;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE gospel RENAME TO gospels;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE gospeltitle RENAME TO gospeltitles;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE languageidentifier RENAME TO languageidentifiers;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE leader RENAME TO leaders;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE mediachapter RENAME TO mediachapters;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE mediagospel RENAME TO mediagospels;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\'ALTER TABLE mediaitem RENAME COLUMN \"ipfsLink\" TO ipfs_link;\'') )
        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\'ALTER TABLE mediaitem RENAME COLUMN \"contentProviderLink\" TO content_provider_link;\'') )
        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE mediaitem RENAME TO mediaitems;\"') )


        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE mediaphrase RENAME TO mediaphrases;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE mediasermon RENAME TO mediasermons;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE musictitle RENAME TO musictitles;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE org RENAME TO orgs;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE playlist RENAME TO playlists;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE pushmessage RENAME TO pushmessages;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE sermonphrase RENAME TO sermonphrases;\"') )

        os.system("psql -U postgres -d {0} -c {1}".format('faithful_word_dev', '\"ALTER TABLE tag RENAME TO tags;\"') )

        # subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', 'ALTER TABLE book RENAME TO books;'])

        # ALTER TABLE vendors RENAME TO suppliers;

        # SET session_replication_role = DEFAULT;

        # subprocess.call(['/Applications/Postgres.app/Contents/Versions/11/bin/psql', '-c', 'faithful_word_dev', '<', args.pgfile, '>' '/dev/null'])

        # SET session_replication_role = replica;

        # video_files = Dbimport.walk_folder(args.dir)
        # print('video_files: {}'.format(repr(video_files)))

        # item = 0
        # while len(video_files) > 0:
        #     print('len(video_files): {}'.format(repr(len(video_files))))
            
        #     f = video_files[item]
        #     # subprocess.call(['ffmpeg', '-i', f, '-f', 'mpegts', 'udp://127.0.0.1:23000'])

        #     subprocess.call(['ffmpeg', '-re', '-i', f, '-c', 'copy', '-bsf:a', 'aac_adtstoasc', '-f', 'flv', args.livestream_url])
        #     item = item + 1
        #     if item == len(video_files):
        #         item = 0
        #     print('item: {}', repr(item))

    # @staticmethod
    # def walk_folder(media_dir):
    #     print('walk_folder media_dir: {}'.format(repr(media_dir)))
    #     print('os.path.abspath(f): {}'.format(repr(os.path.abspath(media_dir))))

    #     all_file_paths = Dbimport._get_filepaths(os.path.abspath(media_dir))
    #     ts_paths = []
    #     for f in all_file_paths:
    #         if f.endswith('.ts') or f.endswith('.mp4'):
    #             ts_paths.append(f)
    #             print('output_name: {}'.format(f))
    #             basename = os.path.basename(f)
    #             print('basename: {}'.format(basename))
    #     return sorted(ts_paths, key=lambda i: os.path.splitext(os.path.basename(i))[0])

    # def _get_filepaths(directory):
    #     """
    #     This function will generate the file names in a directory
    #     tree by walking the tree either top-down or bottom-up. For each
    #     directory in the tree rooted at directory top (including top itself),
    #     it yields a 3-tuple (dirpath, dirnames, filenames).
    #     """
    #     file_paths = []  # List which will store all of the full filepaths.

    #     # Walk the tree.
    #     for root, directories, files in os.walk(directory):
    #         for filename in files:
    #             # Join the two strings in order to form the full filepath.
    #             filepath = os.path.join(root, filename)
    #             file_paths.append(filepath)  # Add it to the list.

    #     return file_paths # Self-explanatory.

    # @staticmethod
    # def _get_url(base, path, headers) -> str:
    #     print('_get_url: {} {}'.format(repr(base), repr(headers)))
    #     conn = http.client.HTTPConnection(base)
    #     conn.connect()
    #     conn.request('GET', path)
    #     response = conn.getresponse()
    #     data = response.read()
    #     response_string = data.decode('utf-8')
    #     print('response_string: {}'.format(repr(response_string)))

    #     conn.close()
    #     return response_string

    # @staticmethod
    # def _post_url(base, path, headers, body) -> json:
    #     print('_post_url: {} {} {}'.format(repr(base), repr(headers), repr(body)))

    #     conn = http.client.HTTPConnection(base)
    #     conn.request("POST", path, body, headers)
    #     # conn.request("POST", "/request?foo=bar&foo=baz", headers)

    #     res = conn.getresponse()
    #     data = res.read()

    #     response_string = data.decode('utf-8')
    #     result = json.loads(response_string)
    #     print('result: {}'.format(repr(result)))
    #     conn.close()
        
    #     return result

if __name__ == '__main__':
    Dbimport()
