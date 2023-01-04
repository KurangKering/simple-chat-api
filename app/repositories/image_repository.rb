module ImageRepository
  extend self
  def input_type(input)
    if input.is_a? String
      return 'text'
    elsif (defined? input.content_type) == 'method'
      return (['image/gif', 'image/jpeg', 'image/png', 'image/jpg'].include? input.content_type) ? 'image' : nil
    end

    nil
  end

  def insert_image(input)
    require 'securerandom'
    return unless (defined? input.content_type) == 'method'

    name = input.original_filename.split('.')
    ext = name[1] ? ".#{name[1]}" : ""
    rand_name = "#{SecureRandom.hex}#{ext}"
    url = "public/upload/#{rand_name}"
    path = File.join("public", "upload", rand_name)
    upload = File.open(path, "wb") { |f| f.write(input.read) }
    url = upload ? url : nil
  end
end
