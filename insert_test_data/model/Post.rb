# -*- coding: utf-8 -*-

#class AA10000 < ActiveRecord::Base
#  self.table_name = 'aa10000'
#  self.primary_keys = :serverid, :ymd, :seq1, :seq2
#end

#class AA45000 < ActiveRecord::Base
#  self.table_name = 'aa45000'
#  self.primary_keys = :ymd, :seq1, :seq2
#end


class Cお名前管理
  belongs_to :インデックスとのヒモ付,
     class_name: 'C索引',
    foreign_key: [ :ymd, :seq1, :seq2 ] ## AA10000's col
#    primary_key: [ :ymd, :seq1, :seq2 ]  ## AA45000's col
  accepts_nested_attributes_for :インデックスとのヒモ付
end
