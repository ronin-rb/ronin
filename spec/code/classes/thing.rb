class Thing

  def exposed
    1
  end

  def inspect
    "#<Thing: stuff>"
  end

  protected

  def not_exposed
    2
  end

end
