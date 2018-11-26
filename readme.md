# Tank Game

## Written in Ruby by Valters Mednis

### Game rules

#### The board

The game consists of a grid of size `20 x 20` . Each grid can contain only `one` tank.

#### Player

Each player has a `tank`. The game starts with the following stats per player:

- 5 Health Points (`HP`)
- 3 Action Points (`AP`)

1 `AP` is added to a player every `8` hours. `AP` can be spent by:

- Moving - `1` field per `1` `AP`
- Shooting a neighboring `tank` - `2` field distance max per `1` `AP`
- Giving to another player within the attack distance

Moves are not turn-based, they can be executed at any time provided the player has enough `HP` AND `AP` .
