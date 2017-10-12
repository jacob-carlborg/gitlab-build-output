class Hash
  unless instance_methods(false).include?(:to_json)
    def to_json
      JSON.dump(self)
    end
  end
end
