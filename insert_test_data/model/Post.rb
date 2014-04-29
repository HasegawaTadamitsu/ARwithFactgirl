
#class AA10000 < ActiveRecord::Base
#  self.table_name = 'aa10000'
#  self.primary_keys = :serverid, :ymd, :seq1, :seq2
#end

#class AA45000 < ActiveRecord::Base
#  self.table_name = 'aa45000'
#  self.primary_keys = :ymd, :seq1, :seq2
#end


class AA10000
  belongs_to :indexxx,
     class_name: 'AA45000',
    foreign_key: [ :ymd, :seq1, :seq2 ] ## AA10000's col
#    primary_key: [ :ymd, :seq1, :seq2 ]  ## AA45000's col
  accepts_nested_attributes_for :indexxx
end



