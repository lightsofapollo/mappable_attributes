class Model < SomeAbstract
  
  ExportNaming = MappableAttributes.map do
    map :name => :robot_name
    map :last_name => :robot_surname
    map :location => :planet    
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
    # { :robot_name => 'Zargon', :robot_surname => 'Zomg , :planet => 'earth', :other => 'wow'}
  end 
  
end