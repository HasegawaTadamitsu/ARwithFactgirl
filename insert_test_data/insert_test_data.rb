# -*- coding: utf-8 -*-

require 'active_record'
require 'factory_girl'
require 'composite_primary_keys'
require 'pry'

require 'faker/japanese'
require 'faker'
#puts "#{Faker::Japanese::Name.name}"
#puts "#{Faker::Japanese::Name.last_name}"
#puts "#{Faker::Japanese::Name.first_name}"
#puts "#{Faker::Internet.url}"
#puts "#{Faker::Internet.email}"
#puts "#{Faker::Number.number(10)}"


DB='hasegawa'

ActiveRecord::Base.establish_connection(
    adapter:  "postgresql",
    database: "#{DB}",
    username: "hasegawa",
    password: ""
)

def table_commentx table
  ret = ActiveRecord::Base.connection.select_value <<EOF
select
  pd.description as TABLE_COMMENT
from
   pg_stat_user_tables psut
  ,pg_description      pd
where
  psut.relname='#{table}'
  and
    psut.relid=pd.objoid
  and
    pd.objsubid=0
EOF
  return ret
end

def table_pks table_name
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
  return pks
end

def column_from_db table 
  col = ActiveRecord::Base.connection.query <<EOF
  select
  pa.attname as COLUMN_NAME,
  pd.description as COLUMN_COMMENT
from
   pg_stat_all_tables psat
  ,pg_description     pd
  ,pg_attribute       pa
where
  psat.schemaname=(select schemaname from pg_stat_user_tables
         where relname = '#{table}')
  and
    psat.relname='#{table}'
  and
    psat.relid=pd.objoid
  and
    pd.objsubid <>0
  and
    pd.objoid=pa.attrelid
  and
    pd.objsubid=pa.attnum
order by
  pd.objsubid
EOF
end

ActiveRecord::Base.connection.tables.each do |table_name|
  table_comment =  table_commentx table_name
  class_name = "C#{table_comment}"
  self.class.const_set class_name, Class.new(ActiveRecord::Base)
  my_class = Object.const_get class_name
  my_class.send 'table_name=', table_name

  pks = table_pks table_name
  pks.map! { |pk|  pk.to_sym }
  my_class.send 'primary_keys=', pks 

  cols = column_from_db table_name
  cols.each do | col_info |
    my_class.class_eval do 
      define_method "#{col_info[1]}".to_sym do 
        return self.send col_info[0]
      end
      define_method "#{col_info[1]}=".to_sym do |arg|
        return self.send "#{col_info[0]}=", arg
      end
    end
  end
end


Dir[File.expand_path('../model', __FILE__) << '/*.rb'].each do |file|
  require file
end


Cお名前管理.delete_all
C索引.delete_all

索引 = C索引.new
お名前 = Cお名前管理.new
索引.有効年月日='x1'
索引.シーケンス1=999
索引.シーケンス2=999
お名前.サーバID="aaa"
お名前.インデックスとのヒモ付=索引
お名前.save

FactoryGirl.define do

  factory :base_AA45000, class: C索引  do
    sequence( :id ) { |n| ["#{n}",n,n] }
    sequence( :サーバID ) { |n| "server#{n}" }
  end

  factory :base  ,class:  Cお名前管理 do

    sequence( :serverid ) { |n| "server#{n}" }
    sequence( :サーバID ) { |n| "server#{n}" }

    trait :with_aa45 do 
#      indexxx {   FactoryGirl.create :base_AA45000}
      association :インデックスとのヒモ付, factory: :base_AA45000
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

#exit

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


datas  = Cお名前管理.all
datas.each do |data|
    p data
end
datas  = C索引.all
datas.each do |data|
    p data
end
