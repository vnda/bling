class Bling::BlingCommunicator
  @@communicators = { 
    "v1" => Bling::Communicators::BlingV1Communicator.new,
  } 
  def initialize(api_version, api_key)   
    raise NotImplementedError unless @@communicators.has_key? api_version
    @communicator = @@communicators[api_version]
    @api_key = api_key
  end

  def send_to_bling(type, xml)
    @communicator.send_to_bling(type, xml, @api_key)
  end

end