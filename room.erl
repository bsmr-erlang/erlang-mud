-module(room).
-export([start/1,
         start/2,
         create/2,
         add/2
         ]).
-include("room.hrl").
-include("item.hrl").
-include("actor.hrl").

start(Room) ->
    start(Room, true).
start(Room, Link) ->
    Fun = fun() -> room(Room) end,
    if
        Link -> spawn_link(Fun);
        true -> spawn(Fun)
    end.

create(Text, Items) ->
    #room{text=Text, items=Items}.

add(Room, Item) when is_record(Item, item) ->
    Items=Room#room.items,
    Room#room{items=[Item|Items]};
add(Room, Actor) when is_record(Actor, actor) ->
    Actors=Room#room.items,
    Room#room{items=[Actor|Actors]}.

room(Room) ->
    receive
        {add_item, Item}
          when is_record(Item, item)
               -> room(add(Room, Item));
        {add_actor, Actor}
          when is_record(Actor, actor)
               -> room(add(Room, Actor));
        terminate -> ok
    end.

