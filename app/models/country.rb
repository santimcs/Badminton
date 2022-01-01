class Country < ApplicationRecord
  mount_uploader :flag, FlagUploader
  default_scope { order('name') }	
end
