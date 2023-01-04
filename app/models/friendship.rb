class Friendship < ApplicationRecord
    self.primary_keys = :id_user_1, :id_user_2

end
