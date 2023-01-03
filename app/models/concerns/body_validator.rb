module BodyValidator
    class LoginValidator
        include ActiveModel::Validations

        attr_accessor :email, :password

        validates :email, :password, presence: true
        validates :email, email: true


    def initialize(params)
          @email = params[:email]
          @password = params[:password]
        end
    end
end