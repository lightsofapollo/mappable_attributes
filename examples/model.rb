class Model < SomeAbstract

  ExportNaming = MappableAttributes::Base.new do
    # Output => Input
    map :robot_name => :name
    map :robot_surname => :last_name
    map :planet => :other
    map :title do |given|
      given[:name] + ' ' + given[:last_name]
    end

  end


  # Use your imagination here...
  def attributes
    {
      :name => 'Zargon',
      :last_name => 'Zomg',
      :location => 'earth',
      :other => 'wow'
    }
  end

  def robot_attributes
    naming = ExportNaming.map_attributes(attributes)
    # =>
    # {
    #   :robot_name => 'Zargon',
    #   :robot_surname => 'Zomg ,
    #   :planet => 'earth',
    #   :other => 'wow',
    #   :title => 'Zargon Zomg'
    # }
    #
  end

end
