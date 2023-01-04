module FriendshipRepository
  extend self
  include Pagy::Backend
  def list_friends(id_user, opt = {})
    opt[:page] = opt[:page] || 1
    opt[:items] = opt[:items] || 10
    opt[:search] = opt[:search] || nil
    friends = Friendship.from("friendships fr")
    friends = friends.where("fr.status": "accepted")
    friends = friends.where("fr.id_user_1 = #{id_user} OR fr.id_user_2 = #{id_user}")
    friends = friends.where("u.name LIKE ?", "%" + opt[:search] + "%") unless !opt[:search] || opt[:search].strip.empty?
    friends = friends.joins("JOIN users u ON IF(fr.id_user_1 = #{id_user}, u.id_user = fr.id_user_2, u.id_user = fr.id_user_1)")
    friends = friends.select("u.id_user", "u.name", "u.email", "u.phone_number", "u.image")
    @pagy, @records = pagy(friends, page: opt[:page], items: opt[:items])
    { page: @pagy.page, next_page: @pagy.next, total_data: @pagy.count, per_page: @pagy.items, friends: @records }
  end

  def find(current_user, dest_user)
    friend = Friendship.from("friendships fr")
    friend = friend.where("fr.status": "accepted")
    friend = friend.where("fr.id_user_1 = #{current_user} OR fr.id_user_2 = #{current_user}")
    friend = friend.where("fr.id_user_1 = #{dest_user} OR fr.id_user_2 = #{dest_user}")
    friend = friend.joins("JOIN users u ON IF(fr.id_user_1 = #{current_user}, u.id_user = fr.id_user_2, u.id_user = fr.id_user_1)")
    friend = friend.select("u.id_user", "u.name", "u.email", "u.phone_number", "u.image")
    friend = friend.limit(1)
  end

  def list_pending(id_user, opt = {})
    opt[:page] = opt[:page] || 1
    opt[:items] = opt[:items] || 10
    opt[:search] = opt[:search] || nil

    pfriends = Friendship.from("friendships fr")
    pfriends = Friendship.from("friendships fr")
    pfriends = pfriends.where("fr.status": "pending")
    pfriends = pfriends.where("fr.id_user_1 = #{id_user} OR fr.id_user_2 = #{id_user}")
    pfriends = pfriends.where("u.name LIKE ?", "%" + opt[:search] + "%") unless !opt[:search] || opt[:search].strip.empty?
    pfriends = pfriends.joins("JOIN users u ON IF(fr.id_user_1 = #{id_user}, u.id_user = fr.id_user_2, u.id_user = fr.id_user_1)")
    pfriends = pfriends.select("fr.id_user_1", "fr.id_user_2", "u.id_user", "u.name", "u.email", "u.phone_number", "u.image")
    @pagy, @records = pagy(pfriends, page: opt[:page], items: opt[:items])
    { page: @pagy.page, next_page: @pagy.next, total_data: @pagy.count, per_page: @pagy.items, pfriends: @records }
  end

  def add(current_user, dest_user)
    success = false
    message = ''
    friend = Friendship
    friend = friend.where("id_user_1 = #{current_user} OR id_user_2 = #{current_user}")
    friend = friend.where("id_user_1 = #{dest_user} OR id_user_2 = #{dest_user}")
    friend = friend.first
    if friend
      if friend.status == 'pending'
        message = 'Request is pending'
      elsif friend.status == 'accepted'
        message = 'You are friends'
      end
    else
      friend = Friendship.create({ 'id_user_1': current_user, 'id_user_2': dest_user, 'status': 'pending' })
      if friend.persisted?
        success = true
        message = 'Request sent'
      else
        message = 'Failed'
      end
    end
    [success, message]
  end

  def accept(current_user, dest_user)
    success = false
    message = ''
    frequest = Friendship
    frequest = frequest.where("id_user_1": dest_user)
    frequest = frequest.where("id_user_2": current_user)
    frequest = frequest.where("status": 'pending')
    frequest = frequest.first
    if !frequest
      message = 'Friend request not found'
    elsif frequest.status == 'accepted'
      message = 'You are friends'
    else
      ufriend = Friendship.where({ 'id_user_1': dest_user, 'id_user_2': current_user }).first.update(status: 'accepted')
      if ufriend
        success = true
        message = 'Friend request accepted'
      else
        message = 'There is an error when accepting friend request'
      end
    end
    [success, message]
  end

  def reject(current_user, dest_user)
    success = false
    message = ''
    frequest = Friendship
    frequest = frequest.where(["id_user_1 = ?", dest_user])
    frequest = frequest.where(["id_user_2 = ?", current_user])
    frequest = frequest.where('status = "pending"')
    frequest = frequest.first

    if !frequest
      message = 'Friend request not found'
    else
      dfriend = frequest.delete
      if dfriend
        success = true
        message = 'Friend request rejected'
      else
        message = 'There is an error when rejecting friend request'
      end
    end
    [success, message]
  end

  def remove(current_user, dest_user)
    success = false
    message = ''
    frequest = Friendship
    frequest = frequest.where(["id_user_1 = :dest OR id_user_2 = :dest", { dest: dest_user }])
    frequest = frequest.where(["id_user_2 = :curr OR id_user_1 = :curr", { curr: current_user }])
    frequest = frequest.where('status = "accepted"')
    frequest = frequest.first

    if !frequest
      message = 'Friend not found'
    else
      dfriend = frequest.delete
      if dfriend
        success = true
        message = 'Friend has removed'
      else
        message = 'There is an error when removing friend'
      end
    end
    [success, message]
  end
end
