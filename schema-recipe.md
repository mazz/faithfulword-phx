## fwbc 1.3 base schema

### Book

mix phx.gen.schema Book book absolute_id:integer uuid:uuid basename:string

mix phx.gen.schema Chapter chapter absolute_id:integer uuid:uuid basename:string book_id:references:book

mix phx.gen.schema BookTitle booktitle uuid:uuid localizedname:string language_id:string book_id:references:book

book.ex:
      has_many :chapter, FaithfulWord.Chapter
      has_many :booktitle, FaithfulWord.BookTitle

mix phx.gen.schema MediaChapter mediachapter absolute_id:integer uuid:uuid track_number:integer localizedname:string path:string language_id:string presenter_name:string source_material:string chapter_id:references:chapter

chapter.ex:
      has_many :mediachapter, FaithfulWord.MediaChapter

### Gospel

mix phx.gen.schema Gospel gospel absolute_id:integer uuid:uuid basename:string

mix phx.gen.schema MediaGospel mediagospel absolute_id:integer uuid:uuid track_number:integer localizedname:string path:string language_id:string presenter_name:string source_material:string gospel_id:references:gospel

mix phx.gen.schema GospelTitle gospeltitle uuid:uuid localizedname:string language_id:string gospel_id:references:gospel


### Music

mix phx.gen.schema Music music absolute_id:integer uuid:uuid basename:string

mix phx.gen.schema MediaMusic mediamusic absolute_id:integer uuid:uuid track_number:integer localizedname:string path:string language_id:string presenter_name:string source_material:string music_id:references:music

mix phx.gen.schema MusicTitle musictitle uuid:uuid localizedname:string language_id:string music_id:references:music

### LanguageIdentifier

mix phx.gen.schema LanguageIdentifier languageidentifier uuid:uuid identifier:string source_material:string supported:boolean


### PushMessage

mix phx.gen.schema PushMessage pushmessage uuid:uuid created_at:utc_datetime updated_at:utc_datetime title:string message:string sent:boolean

push_message.ex
      field :message, :string, size: 4096

<timestamp>_create_push_message.exs
      add :message, :string, size: 4096


### ClientDevice

mix phx.gen.schema ClientDevice clientdevice uuid:uuid firebase_token:string apns_token:string preferred_language:string user_agent:string


### AppVersion

mix phx.gen.schema AppVersion appversion uuid:uuid version_number:string ios_supported:boolean android_supported:boolean

### importing db

"/Applications/Postgres.app/Contents/Versions/10/bin/pg_dump" -p5432 -U postgres --no-owner --no-acl kjvrvg_dev > ~/tmp/kjvrvg-13_dev.pgsql

mix ecto.reset

"/Applications/Postgres.app/Contents/Versions/10/bin/psql"

\c faithful_word_dev

SET session_replication_role = replica;

\q

"/Applications/Postgres.app/Contents/Versions/10/bin/psql" faithful_word_dev < ~/tmp/kjvrvg-13_dev.pgsql > /dev/null

"/Applications/Postgres.app/Contents/Versions/10/bin/psql"

\c faithful_word_dev

SET session_replication_role = DEFAULT;

\q



Ecto.Query.from(t in FaithfulWord.BookTitle, join: b in FaithfulWord.Book, on: t.book_id == b.id, where: t.language_id  == "en", order_by: b.absolute_id, select: {b.uuid, t.language_id, b.basename, t.localizedname}) |> FaithfulWord.Repo.all








Add the resource to your :api scope in lib/faithful_word_api/router.ex:
    resources "/book", BookController, except: [:new, :edit]
    resources "/chapter", ChapterController, except: [:new, :edit]

    resources "/booktitle", BookTitleController, except: [:new, :edit]
    resources "/gospeltitle", GospelTitleController, except: [:new, :edit]
    resources "/mediagospel", MediaGospelController, except: [:new, :edit]
    resources "/gospel", GospelController, except: [:new, :edit]
    resources "/mediachapter", MediaChapterController, except: [:new, :edit]
    resources "/music", MusicController, except: [:new, :edit]
    resources "/mediamusic", MediaMusicController, except: [:new, :edit]
    resources "/musictitle", MusicTitleController, except: [:new, :edit]
    resources "/languageidentifier", LanguageIdentifierController, except: [:new, :edit]
    resources "/pushmessage", PushMessageController, except: [:new, :edit]
    resources "/clientdevice", ClientDeviceController, except: [:new, :edit]
    resources "/appversion", AppVersionController, except: [:new, :edit]