namespace :db do
  desc "Import CSV seed data into the database"
  task import: [:environment] do
    require 'csv'

    seed_path = 'db/seeds/'
    tables = ['merchants',
              'customers',
              'invoices',
              'transactions',
              'items',
              'invoice_items']

    tables.each do |table_name|
      model = table_name.classify.constantize
      file = seed_path + table_name + '.csv'
      CSV.foreach file, headers: :true do |row_data|
        model.create(row_data.to_h)
      end
      puts "Added #{model.count} #{model} row(s)."
    end
  end

  desc "Reset database and re-import seed data"
  task reseed: [:environment, 'db:drop', 'db:create', 'db:migrate', 'db:import'] do
    puts "Reset and reseed complete."
  end
end
