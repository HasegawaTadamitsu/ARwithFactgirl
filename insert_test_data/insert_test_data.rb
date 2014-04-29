require 'active_record'
require 'factory_girl'
require 'composite_primary_keys'
require 'pry'



DB='hasegawa'

ActiveRecord::Base.establish_connection(
    adapter:  "postgresql",
    database: "#{DB}",
    username: "hasegawa",
    password: ""
)


ActiveRecord::Base.connection.tables.each do |table_name|
#  class_name = table_name.singularize.camelcase
  class_name = table_name.upcase
  self.class.const_set class_name, Class.new(ActiveRecord::Base)
  my_class = Object.const_get class_name

  pks = ActiveRecord::Base.connection.select_values <<EOF
select ccu.column_name as COLUMN_NAME from 
 information_schema.table_constraints tc
,information_schema.constraint_column_usage ccu
where tc.table_catalog='#{DB}'
and tc.table_name='#{table_name}'
and tc.constraint_type='PRIMARY KEY'
and tc.table_catalog=ccu.table_catalog
and tc.table_schema=ccu.table_schema
and tc.table_name=ccu.table_name
and tc.constraint_name=ccu.constraint_name
EOF

  my_class.send 'table_name=', table_name
  pks.map! { |pk|  pk.to_sym }
  my_class.send 'primary_keys=', pks 

end


Dir[File.expand_path('../model', __FILE__) << '/*.rb'].each do |file|
  require file
end


AA10000.delete_all
AA45000.delete_all

a45 = AA45000.new
a10 = AA10000.new

a45.ymd='x1'
a45.seq1=999
a45.seq2=999
a10.serverid='idx'
a10.indexxx=a45
a10.save

FactoryGirl.define do

  factory :base_AA45000, class: AA45000  do
    sequence( :id ) { |n| ["#{n}",n,n] }
    sequence( :serverid ) { |n| "server#{n}" }
  end

  factory :base  ,class: AA10000 do

    sequence( :serverid ) { |n| "server#{n}" }

    trait :with_aa45 do 
#      indexxx {   FactoryGirl.create :base_AA45000}
      association :indexxx, factory: :base_AA45000
    end

    trait :only do
      ymd  "x"
      seq1  0
      seq2  0
    end

    name "name"

    factory :AA10_with_aa45,traits: [ :with_aa45]
    factory :AA10_only,     traits: [ :only]

  end

end


#10.times do 
#  FactoryGirl.create :base_AA45000
#end

#binding.pry

5.times do 
  FactoryGirl.create :AA10_with_aa45
end
5.times do 
  FactoryGirl.create :AA10_only
end


datas  = AA10000.all
datas.each do |data|
    p data
end
datas  = AA45000.all
datas.each do |data|
    p data
end
