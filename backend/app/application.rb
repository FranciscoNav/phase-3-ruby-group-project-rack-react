require 'pry'

class Application

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    
    if req.path.match(/expenses/)
      if req.env["REQUEST_METHOD"] == "POST"
        input = JSON.parse(req.body.read)
        trip_id = req.path.split("/trips/").last.split('/expenses').first
        trip = Trip.find_by(id: trip_id)
        expense = trip.expenses.create(name: input["name"], price: input["price"])
        return [200, { 'Content-Type' => 'application/json' }, [ expense.to_json ]]
      elsif req.env["REQUEST_METHOD"] == "DELETE"
        trip_id = req.path.split("/trips/").last.split('/expenses/').first
        trip = Trip.find_by(id: trip_id)
        expense_id = req.path.split('/expenses/').last
        trip_expense = trip.expenses.find_by(id: expense_id)
        trip_expense.destroy()
      elsif req.env["REQUEST_METHOD"] == "PATCH"
        input = JSON.parse(req.body.read)
        trip_id = req.path.split("/trips/").last.split('/expenses').first
        trip = Trip.find_by(id: trip_id)
        expense_id = req.path.split('/expenses/').last
        trip_expense = trip.expenses.find_by(id: expense_id)
        trip_expense.update(input)
        return [200, { 'Content-Type' => 'application/json' }, [ trip_expense.to_json ]]
      end
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

