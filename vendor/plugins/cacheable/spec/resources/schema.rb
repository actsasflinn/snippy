ActiveRecord::Schema.define(:version => '20081219003437') do
  create_table :army_guys, :force => true do |t|
    t.string :name
    t.string :rank
    t.datetime :service_date
    t.datetime :created_at
    t.datetime :updated_at
  end
end
