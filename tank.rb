class Tank
    attr_accessor :hp, :ap, :hash, :name, :x, :y

    def initialize(game, name, hash)
        @game = game
        @name = name
        @hash = hash

        begin
            @x = Random.rand(20)
            @y = Random.rand(20)

            if @game.tank_at @x, @y 
                raise "Failed to place tank"
            end
        rescue => ex
            puts ex
            retry
        end

        @ap = 3
        @hp = 5
    end

    def move(x, y)
        raise ArgumentError, "Moving too far" unless (x - @x).abs <= 1 and (y - @y).abs <= 1
        raise ArgumentError, "Moving out of bounds" unless x >=0 and x < 20 and y >= 0 and y <= 50
        raise ArgumentError, "Not enough AP" unless @ap > 0
        raise ArgumentError, "Somebody is already there" unless (@game.tank_at x, y) == nil

        @x = x
        @y = y
        @ap = @ap - 1
    end

    def attack(x, y)
        target = @game.tank_at x, y

        raise ArgumentError, "Attacking too far" unless (x - @x.abs) <= 2 and (y - @y).abs <= 2
        raise ArgumentError, "No enemy there" unless target != nil
        raise ArgumentError, "Not enough AP" unless @ap > 0

        target.hp = target.hp - 1
        if target.hp <= 0
            @game.remove_player target
        end

        @ap = @ap - 1
    end

    def trade(x, y, ap)
        target = @game.tank_at x, y

        raise ArgumentError, "Trading too far" unless (x - @x.abs) <= 2 and (y - @y).abs <= 2
        raise ArgumentError, "No ally there" unless target != nil
        raise ArgumentError, "Not enough AP" unless @ap >= ap
        raise ArgumentError, "No stealing :)" unless ap > 0

        target.ap = target.ap + ap
        @ap = @ap - ap
    end
end

