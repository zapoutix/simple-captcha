module SimpleCaptcha
  class SimpleCaptchaData
    include Mongoid::Document
    
    field :key, :type => String
    field :value, :type => String
    
    class << self
      def get_data(key)
        data = SimpleCaptchaData.where(:key => key).first || new(:key => key)
      end
      
      def remove_data(key)
        delete_all(["#{connection.quote_column_name(:key)} = ?", key])
        clear_old_data(1.hour.ago)
      end
      
      def clear_old_data(time = 1.hour.ago)
        return unless Time === time
        delete_all(["#{connection.quote_column_name(:updated_at)} < ?", time])
      end
    end
  end
end
