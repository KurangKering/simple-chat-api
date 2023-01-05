module UserRepository
  extend self
  include Pagy::Backend

  def list_users(exc_user, opt = {})
    opt[:page] = opt[:page] || 1
    opt[:items] = opt[:items] || 10
    opt[:search] = opt[:search] || nil
    user = User.where.not("u.id_user": exc_user)
    user = user.where("u.name LIKE ?", "%" + opt[:search] + "%") unless !opt[:search] || opt[:search].strip.empty?
    user = user.joins("AS u LEFT JOIN friendships fr ON (u.id_user = fr.id_user_1 OR u.id_user = fr.id_user_2)")
    user = user.select("u.id_user", "u.name", "u.email", "u.phone_number", "u.image", "fr.status as friendship_status", "IF(fr.id_user_1 = #{exc_user}, 1, null) requested")
    @pagy, @records = pagy(user, page: opt[:page], items: opt[:items])

    return { page: @pagy.page, next_page: @pagy.next, total_data: @pagy.count, per_page: @pagy.items, users: @records }
  end
end
