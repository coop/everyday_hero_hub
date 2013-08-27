module JIRAClient
  class Configuration
    ATTRIBUTES = %i(username password site context_path auth_type)

    attr_accessor *ATTRIBUTES

    def initialize attributes = {}
      attributes.each do |key, value|
        send "#{key}=", value if ATTRIBUTES.include?(key)
      end if attributes
    end
  end
end
