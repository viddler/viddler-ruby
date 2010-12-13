module Viddler
  class ApiException < ::StandardError
    attr_accessor :code, :description, :details
    
    def initialize(code, description, details)
      self.code        = code.to_i
      self.description = description
      self.details     = details
      
      super("\##{self.code}: #{self.description} (#{self.details})")
    end
  end
end