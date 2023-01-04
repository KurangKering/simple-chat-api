class Message < ApplicationRecord
    self.primary_key = :id_message
    self.inheritance_column = :_type_disabled

end
