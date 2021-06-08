require 'pry'

class Application

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    # binding.pry

    if req.path.match(/test/) 
      return [200, { 'Content-Type' => 'application/json' }, [ {:message => "test response!"}.to_json ]]
    elsif req.path.match(/expenses/)
    
    elsif req.path.match(/trips/)
      if req.env["REQUEST_METHOD"] == "POST"
        input = JSON.parse(req.body.read)
        trip = Trip.create(name: input["name"], country: input["country"], city: input["city"])
        return [200, { 'Content-Type' => 'application/json' }, [ trip.to_json ]]
      else
        if req.path.split("/trips").length == 0 
          return [200, { 'Content-Type' => 'application/json' }, [ Trip.all.to_json ]]
        else
          trip_id = req.path.split("/trips/").last
          return [200, { 'Content-Type' => 'application/json' }, [ Trip.find_by(id: trip_id).to_json({:include => :expenses})]]
        end
      end
    else
      resp.write "Path Not Found"

    end

    resp.finish
  end

end

