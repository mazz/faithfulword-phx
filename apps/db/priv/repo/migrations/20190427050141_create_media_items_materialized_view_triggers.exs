defmodule DB.Repo.Migrations.CreateMediaItemsMaterializedViewTriggers do
  use Ecto.Migration

  def change do
    ############# Triggers for refreshing the media_items_search materialized view
    execute(
      """
      CREATE OR REPLACE FUNCTION refresh_media_items_search()
      RETURNS TRIGGER LANGUAGE plpgsql
      AS $$
      BEGIN
      REFRESH MATERIALIZED VIEW CONCURRENTLY media_items_search;
      RETURN NULL;
      END $$;
      """
    )

    execute(
      """
      CREATE TRIGGER refresh_media_items_search
      AFTER INSERT OR UPDATE OR DELETE OR TRUNCATE
      ON mediaitems
      FOR EACH STATEMENT
      EXECUTE PROCEDURE refresh_media_items_search();
      """
    )
  end
end
