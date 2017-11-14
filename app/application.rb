require "pry"

class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []
  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)

    elsif req.path.match(/cart/)
      if @@cart.empty?
        resp.write "Your cart is empty"
      else
        @@cart.each{|i| resp.write "#{i}\n"}
      end
    elsif req.path.match(/add/)
      add_item = req.params["item"]
      resp.write handle_add_item(add_item)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if search(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def search(search_term)
    @@items.include?(search_term)
  end

  def handle_add_item(add_item)
    if search(add_item)
      @@cart << add_item
      return "added #{add_item}"
    else
      return "We don't have that item"
    end
    binding.pry
  end
end
