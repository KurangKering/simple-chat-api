module BodyValidator
    class BaseBodyValidator
        include ActiveModel::Validations
    end

    class LoginValidator < BaseBodyValidator
        attr_accessor :email, :password

        validates :email, :password, presence: true
        validates :email, email: true
        def initialize(params)
            @email = params[:email]
            @password = params[:password]
        end
    end

    class FriendshipCreateValidator < BaseBodyValidator
        attr_accessor :id_user

        validates :id_user, presence: true
        def initialize(params)
            @id_user = params[:id_user]
        end
    end

    class MessageCreateValidator < BaseBodyValidator
        attr_accessor :id_recipient, :message

        validates :id_recipient, :message, presence: true
        def initialize(params)
            @id_recipient = params[:id_recipient]
            @message = params[:message]
        end
    end
end