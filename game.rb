require "yaml"
require_relative "tank.rb"

SAVE_LOCATION = "save.yml"

class Game
    attr_accessor :started

    def initialize
        @tanks = Array.new
        @started = false
        @last_ap_update = DateTime.now
    end

    def update_ap
        if DateTime.now > @last_ap_update + (8.0/24.0) 
            @tanks.each do |t|
                t.ap += 1
            end
            @last_ap_update = DateTime.now
        end
    end

    def save
        data = YAML::dump self
        File.write SAVE_LOCATION, data
        puts "Saved at #{Time.now}"
    end

    def add_player(tank)
        @tanks << tank
    end

    def remove_player(tank)
        @tanks -= tank
    end

    def tank_at(x, y)
        @tanks.each do |t|
            if t.x == x and t.y == y
                return t
            end
        end
        nil
    end

    def tank(name)
        @tanks.each do |t|
            if t.name == name
                return t
            end
        end
        nil
    end
end
