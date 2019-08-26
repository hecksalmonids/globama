# Migration: AddPastasTableToDatabase
Sequel.migration do
  change do
    create_table(:pastas) do
      primary_key :id
      String :trigger
      String :text
    end
  end
end