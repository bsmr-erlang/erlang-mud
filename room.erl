-module(room).
-export([create/2,
         add_actor/2,
         add_item/2,
         add/2,
         update_actors/1,
         remove_actor/2
         ]).
-include("room.hrl").
-include("item.hrl").
-include("actor.hrl").

create(Text, Items) ->
    #room{text=Text, items=Items}.

add(Room, Item) when is_record(Item, item) ->
    add_item(Room, Item);
add(Room, Actor) when is_record(Actor, actor) ->
    add_actor(Room, Actor).

add_actor(Room, Actor) ->
    Actors=Room#room.actors,
    Room#room{actors=[Actor|Actors]}.
add_item(Room, Item) ->
    Items=Room#room.items,
    Room#room{items=[Item|Items]}.

remove_actor(Room, Actor) ->
    case lists:any(fun(X) ->
                           X == Actor
                   end,
                   Room#room.actors) of
        false ->
            Room#room{actors=Room#room.actors -- [Actor]};
        true -> {error, "no such actor"}
    end.

update_actors(Room) ->
    lists:map(fun(Actor) -> Actor ! {in_room, Room} end, Room#room.actors),
    Room.

