module ApiHelpers
  # I need these methods because this project (intentionally) doesn't use Rails in any capacity.
  # Better versions exist in ActiveSupport.
  # In the "real world", I'd spend more time making these better. Or just include the AS gem.
  #
  # https://apidock.com/rails/ActiveSupport/Inflector/singularize
  def singularize(string)
    string.gsub(/s$/, '')
  end

  # swallowing all errors is usually a bad idea, but I just want to return nil if an unexpected key is given
  # https://apidock.com/rails/String/constantize
  def to_class(key)
    "#{key.downcase.split('_').map(&:capitalize).join('')}" rescue nil
  end

end
