-module(room).
-export([create/2,
         add/2,
         update_actors/1
         ]).
-include("room.hrl").
-include("item.hrl").
-include("actor.hrl").

create(Text, Items) ->
    #room{text=Text, items=Items}.

add(Room, Item) when is_record(Item, item) ->
    Items=Room#room.items,
    Room#room{items=[Item|Items]};
add(Room, Actor) when is_record(Actor, actor) ->
    Actors=Room#room.actors,
    Room#room{actors=[Actor|Actors]}.

update_actors(_, []) -> ok;
update_actors(Room, [Actor|Actors]) ->
    Actor ! {room, Room},
    update_actors(Actors).
update_actors(Room) ->
    update_actors(Room, Room#room.actors).

