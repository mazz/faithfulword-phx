defmodule Db.SeedSupport do
  alias Db.Repo
  alias Db.Schema.User
  alias Db.Schema.Org
  # alias Db.Schema.{Org, Rubric, CourseCode, Task, TaskCategory, TaskItem, Assignment}
  alias FaithfulWordApi.V13
  require Logger

  def insert_org(
        basename,
        shortname
      ) do
    # item_uuid = Ecto.UUID.generate()
    task =
      Org.changeset(
        %Org{},
        %{
          basename: basename,
          shortname: shortname,
          uuid: Ecto.UUID.generate()
        }
      )

    Repo.insert!(task)
    task
  end

  # def insert_rubric(value, scale) do
  #   # item_uuid = Ecto.UUID.generate()
  #   item =
  #     Rubric.changeset(
  #       %Rubric{},
  #       %{
  #         value: value,
  #         scale: scale,
  #         uuid: Ecto.UUID.generate()
  #       }
  #     )

  #   Repo.insert!(item)
  #   item
  # end

  # def insert_course_code(code, title, org_id) do
  #   # item_uuid = Ecto.UUID.generate()
  #   item =
  #     CourseCode.changeset(
  #       %CourseCode{},
  #       %{
  #         code: code,
  #         title: title,
  #         org_id: org_id,
  #         uuid: Ecto.UUID.generate()
  #       }
  #     )

  #   Repo.insert!(item)
  #   item
  # end

  # def insert_task(
  #       archived,
  #       course_task_type,
  #       title,
  #       coursecode_code,
  #       hash_id,
  #       rubric_id,
  #       coursecode_id
  #     ) do
  #   # item_uuid = Ecto.UUID.generate()
  #   # course_task_type,
  #   # coursecode_id,
  #   # rubric_id,
  #   # org_id,
  #   # coursecode_code,
  #   # task_title,
  #   # task_uuid \\ nil

  #   {:ok, task} =
  #     V10.add_or_update_task(
  #       course_task_type,
  #       coursecode_id,
  #       rubric_id,
  #       coursecode_code,
  #       title,
  #       nil
  #     )

  #   task
  # end

  # def insert_task_category(name, ordinal, task_id, task_uuid) do
  #   # item_uuid = Ecto.UUID.generate()
  #   item =
  #     TaskCategory.changeset(
  #       %TaskCategory{},
  #       %{
  #         name: name,
  #         ordinal: ordinal,
  #         task_id: task_id,
  #         task_uuid: task_uuid,
  #         uuid: Ecto.UUID.generate()
  #       }
  #     )

  #   Repo.insert!(item)
  #   item
  # end

  # def insert_task_item(title, ordinal, task_category_id, task_category_uuid) do
  #   # item_uuid = Ecto.UUID.generate()
  #   item =
  #     TaskItem.changeset(
  #       %TaskItem{},
  #       %{
  #         title: title,
  #         ordinal: ordinal,
  #         task_category_id: task_category_id,
  #         task_category_uuid: task_category_uuid,
  #         uuid: Ecto.UUID.generate()
  #       }
  #     )

  #   Repo.insert!(item)
  # end

  # def insert_task_criteria(
  #   task_id,
  #   criteria
  #   ) do

  #     {:ok, task_criteria} = V10.add_or_update_task_criteria(
  #       task_id,
  #       criteria,
  #       nil
  #     )
  #     task_criteria
  # end

  # def insert_assignment(
  #       course_task_type,
  #       coursecode_id,
  #       rubric_id,
  #       coursecode_code,
  #       title,
  #       archived
  #     ) do
  #   # item_uuid = Ecto.UUID.generate()

  #   {:ok, assignment} = V10.add_or_update_assignment(
  #     course_task_type,
  #     coursecode_id,
  #     rubric_id,
  #     coursecode_code,
  #     title
  #   )
  #   assignment
  # end
end
